import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class LachispaApiService {
  static final LachispaApiService instance = LachispaApiService._();

  String? _baseUrl;
  String? _apiKey;
  WebSocketChannel? _wsChannel;

  LachispaApiService._();

  void configure({required String baseUrl, required String apiKey}) {
    _baseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    _apiKey = apiKey;
  }

  bool get isConfigured => _baseUrl != null && _apiKey != null;

  Map<String, String> get _headers => {
    'X-Api-Key': _apiKey!,
    'Content-Type': 'application/json',
  };

  Future<Map<String, dynamic>> getWallet() async {
    if (!isConfigured) {
      throw Exception('LachispaAPI no configurada');
    }

    final response = await http
        .get(Uri.parse('$_baseUrl/api/v1/wallet'), headers: _headers)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error getting wallet: ${response.statusCode}');
    }
  }

  Future<InvoiceResult> createInvoice({
    required int amountSats,
    required String memo,
    int expiry = 3600,
  }) async {
    if (!isConfigured) {
      throw Exception('LachispaAPI no configurada');
    }

    final body = json.encode({
      'out': false,
      'amount': amountSats,
      'memo': memo,
      'expiry': expiry,
      'unit': 'sat',
    });

    final response = await http
        .post(
          Uri.parse('$_baseUrl/api/v1/payments'),
          headers: _headers,
          body: body,
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 201) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      print('Invoice response: $data');

      final paymentHash =
          data['payment_hash'] as String? ?? data['checking_id'] as String?;
      final paymentRequest =
          data['bolt11'] as String? ?? data['payment_request'] as String? ?? '';

      if (paymentRequest.isEmpty && paymentHash != null) {
        final decoded = await _decodePaymentRequest(paymentHash);
        if (decoded.isNotEmpty) {
          return InvoiceResult(
            paymentHash: paymentHash,
            paymentRequest: decoded,
          );
        }
      }

      return InvoiceResult(
        paymentHash: paymentHash ?? '',
        paymentRequest: paymentRequest,
      );
    } else {
      String errorMsg = 'Error creating invoice: ${response.statusCode}';
      try {
        final errorBody = json.decode(response.body);
        errorMsg += ' - $errorBody';
      } catch (_) {}
      throw Exception(errorMsg);
    }
  }

  Future<String> _decodePaymentRequest(String paymentHash) async {
    try {
      final body = json.encode({'data': paymentHash});
      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/v1/payments/decode'),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        print('Decode response: $data');
        return data['payment_request'] as String? ??
            data['bolt11'] as String? ??
            '';
      }
    } catch (e) {
      print('Error decoding: $e');
    }
    return '';
  }

  Future<bool> checkPayment(String paymentHash) async {
    if (!isConfigured) {
      throw Exception('LachispaAPI no configurada');
    }

    final response = await http
        .get(
          Uri.parse('$_baseUrl/api/v1/payments/$paymentHash'),
          headers: _headers,
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return data['paid'] as bool? ?? false;
    } else {
      return false;
    }
  }

  Stream<bool> watchPayment(String paymentHash) async* {
    if (_wsChannel != null) {
      try {
        await for (final data in _wsChannel!.stream) {
          try {
            final json = jsonDecode(data as String);
            if (json['payment'] != null &&
                json['payment']['payment_hash'] == paymentHash) {
              yield true;
              return;
            }
          } catch (_) {}
        }
      } catch (e) {
        print('WebSocket error: $e');
      }
    }

    for (int i = 0; i < 60; i++) {
      final paid = await checkPayment(paymentHash);
      if (paid) {
        yield true;
        return;
      }
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  void connectWebSocket(String invoiceKey) {
    final wsUrl = _baseUrl!
        .replaceFirst('https://', 'wss://')
        .replaceFirst('http://', 'ws://');
    _wsChannel = WebSocketChannel.connect(
      Uri.parse('$wsUrl/api/v1/ws/$invoiceKey'),
    );
  }

  Stream<Map<String, dynamic>>? get wsStream => _wsChannel?.stream.map((data) {
    return json.decode(data as String) as Map<String, dynamic>;
  });

  void disconnect() {
    _wsChannel?.sink.close();
    _wsChannel = null;
  }

  Future<bool> testConnection() async {
    if (!isConfigured) return false;
    try {
      await getWallet();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<InvoiceResult?> createInvoiceForLnurl({
    required String lnurl,
    required int amountSats,
    required String memo,
  }) async {
    try {
      String decodedUrl = lnurl;

      if (lnurl.startsWith('LNURL1')) {
        final decoded = _decodeLnurl(lnurl);
        if (decoded == null) {
          throw Exception('LNURL inválido');
        }
        decodedUrl = decoded;
      } else if (lnurl.startsWith('LNURLW://') ||
          lnurl.startsWith('lnurlw://')) {
        decodedUrl = lnurl
            .replaceFirst('LNURLW://', 'https://')
            .replaceFirst('lnurlw://', 'https://');
      }

      String finalUrl = decodedUrl;
      if (!finalUrl.startsWith('http')) {
        finalUrl = 'https://$finalUrl';
      }

      if (!finalUrl.contains('?')) {
        finalUrl = '$finalUrl?';
      } else {
        finalUrl = '$finalUrl&';
      }
      finalUrl =
          '${finalUrl}amount=$amountSats&comment=${Uri.encodeComponent(memo)}';

      print('[LNURL] Fetching: $finalUrl');

      final response = await http
          .get(Uri.parse(finalUrl))
          .timeout(const Duration(seconds: 15));

      print('[LNURL] Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'ERROR') {
          final reason = data['reason'] ?? 'Error desconocido';
          print('[LNURL] Error del servidor: $reason');
          throw Exception(reason);
        }

        if (data['pr'] != null) {
          final paymentRequest = data['pr'] as String;
          final paymentHash = await _getPaymentHashFromRequest(paymentRequest);
          return InvoiceResult(
            paymentHash: paymentHash,
            paymentRequest: paymentRequest,
          );
        }

        if (data['tag'] == 'withdrawRequest') {
          print('[LNURL] Es un withdrawRequest, creando invoice y enviando...');

          final callback = data['callback'] as String;
          final k1 = data['k1'] as String;

          final myInvoice = await createInvoice(
            amountSats: amountSats,
            memo: memo,
          );

          if (myInvoice.paymentRequest.isEmpty) {
            throw Exception('No se pudo crear la invoice');
          }

          String callbackUrl = callback;
          if (!callbackUrl.contains('?')) {
            callbackUrl = '$callbackUrl?';
          } else {
            callbackUrl = '$callbackUrl&';
          }
          callbackUrl =
              '${callbackUrl}k1=$k1&pr=${Uri.encodeComponent(myInvoice.paymentRequest)}';

          print('[LNURL] Enviando invoice al callback: $callbackUrl');

          final callbackResponse = await http
              .get(Uri.parse(callbackUrl))
              .timeout(const Duration(seconds: 15));

          print(
            '[LNURL] Callback response: ${callbackResponse.statusCode} - ${callbackResponse.body}',
          );

          if (callbackResponse.statusCode == 200) {
            final cbData = json.decode(callbackResponse.body);
            if (cbData['success'] == true) {
              return InvoiceResult(
                paymentHash: myInvoice.paymentHash,
                paymentRequest: myInvoice.paymentRequest,
              );
            }
          }

          return InvoiceResult(
            paymentHash: myInvoice.paymentHash,
            paymentRequest: myInvoice.paymentRequest,
          );
        }

        if (data['success'] == true) {
          return InvoiceResult(
            paymentHash: 'lnurlw_${DateTime.now().millisecondsSinceEpoch}',
            paymentRequest: '',
          );
        }
      }

      print('LNURLw response: ${response.statusCode} - ${response.body}');
      throw Exception('Error del servidor LNURL');
    } catch (e) {
      print('Error creating invoice for LNURL: $e');
      rethrow;
    }
  }

  String? _decodeLnurl(String encoded) {
    try {
      final encodedPart = encoded.substring(6);
      final padded = encodedPart.padRight(
        encodedPart.length + (4 - encodedPart.length % 4) % 4,
        '=',
      );
      final replaced = padded.replaceAll('-', '+').replaceAll('_', '/');
      final decoded = base64Decode(replaced);
      return String.fromCharCodes(decoded);
    } catch (e) {
      return null;
    }
  }

  Future<String> _getPaymentHashFromRequest(String paymentRequest) async {
    try {
      final body = json.encode({'data': paymentRequest});
      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/v1/payments/decode'),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data['payment_hash'] as String? ?? '';
      }
    } catch (e) {
      print('Error getting payment hash: $e');
    }
    return '';
  }
}

class InvoiceResult {
  final String paymentHash;
  final String paymentRequest;

  InvoiceResult({required this.paymentHash, required this.paymentRequest});
}
