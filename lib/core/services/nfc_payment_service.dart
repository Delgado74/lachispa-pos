import 'dart:async';
import 'package:nfc_manager/nfc_manager.dart';

class NfcPaymentService {
  static final NfcPaymentService _instance = NfcPaymentService._internal();
  factory NfcPaymentService() => _instance;
  NfcPaymentService._internal();

  bool _isListening = false;
  StreamController<String>? _nfcDataController;

  Future<bool> isNfcAvailable() async {
    return await NfcManager.instance.isAvailable();
  }

  Future<void> readLnurlFromCard({
    required Function(String) onLnurlReceived,
    required Function(String) onError,
  }) async {
    if (_isListening) {
      await stopReading();
    }

    final isAvailable = await isNfcAvailable();
    if (!isAvailable) {
      onError('NFC no disponible en este dispositivo');
      return;
    }

    _nfcDataController = StreamController<String>.broadcast();
    _isListening = true;

    _nfcDataController!.stream.listen(onLnurlReceived);

    try {
      await NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          try {
            print('[NFC] Tag detectado');

            final ndef = Ndef.from(tag);
            print('[NFC] NDEF from tag: $ndef');

            if (ndef != null) {
              final cachedMessage = await ndef.cachedMessage;
              print('[NFC] Cached message: $cachedMessage');

              if (cachedMessage != null && cachedMessage.records.isNotEmpty) {
                print(
                  '[NFC] Número de records: ${cachedMessage.records.length}',
                );

                for (int i = 0; i < cachedMessage.records.length; i++) {
                  final record = cachedMessage.records[i];
                  print('[NFC] --- Record $i ---');
                  print('[NFC] typeNameFormat: ${record.typeNameFormat}');
                  print('[NFC] type: ${record.type}');
                  print('[NFC] identifier: ${record.identifier}');

                  final payloadBytes = record.payload;
                  print('[NFC] payload length: ${payloadBytes.length}');
                  print(
                    '[NFC] payload bytes (first 20): ${payloadBytes.take(20).map((e) => e.toRadixString(16).padLeft(2, '0')).join(' ')}',
                  );

                  final firstByte = payloadBytes.isNotEmpty
                      ? payloadBytes[0]
                      : 0;
                  print(
                    '[NFC] Primer byte: $firstByte (0x${firstByte.toRadixString(16)})',
                  );

                  String payloadStr = '';

                  if (record.typeNameFormat ==
                          NdefTypeNameFormat.nfcWellknown &&
                      record.type.isNotEmpty &&
                      record.type[0] == 0x55) {
                    print('[NFC] Tipo U (URL well-known)');
                    if (payloadBytes.isNotEmpty) {
                      final prefixByte = payloadBytes[0];
                      if (prefixByte < payloadBytes.length - 1) {
                        payloadStr = String.fromCharCodes(
                          payloadBytes.sublist(prefixByte + 1),
                        );
                      } else {
                        payloadStr = String.fromCharCodes(payloadBytes);
                      }
                    }
                  } else {
                    payloadStr = String.fromCharCodes(payloadBytes);
                  }

                  print('[NFC] payload decodeado: "$payloadStr"');
                  payloadStr = payloadStr.trim();
                  print('[NFC] payload trim: "$payloadStr"');

                  if (payloadStr.toLowerCase().contains('lnurl')) {
                    final lower = payloadStr.toLowerCase();
                    final idx = lower.indexOf('lnurl');
                    final lnurl = payloadStr.substring(idx);
                    print('[NFC] ¡LNURL encontrado!: $lnurl');
                    _nfcDataController?.add(lnurl);
                    await stopReading();
                    return;
                  }
                }
              } else {
                print('[NFC] No hay cached message o records');
              }
            } else {
              print('[NFC] No hay NDEF en este tag');
            }

            onError('No se encontró LNURL en la tarjeta');
            await stopReading();
          } catch (e, stack) {
            print('[NFC] Error: $e');
            print('[NFC] Stack: $stack');
            onError('Error leyendo NFC: $e');
            await stopReading();
          }
        },
        onError: (error) async {
          print('[NFC] onError: ${error.message}');
          onError('Error NFC: ${error.message}');
          await stopReading();
        },
      );
    } catch (e) {
      print('[NFC] Excepción: $e');
      _isListening = false;
      onError('Error iniciando NFC: $e');
    }
  }

  Future<void> stopReading() async {
    if (_isListening) {
      try {
        await NfcManager.instance.stopSession();
      } catch (e) {}
      _isListening = false;
      _nfcDataController?.close();
      _nfcDataController = null;
    }
  }

  bool get isListening => _isListening;
}
