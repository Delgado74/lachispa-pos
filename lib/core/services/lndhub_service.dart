import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../constants/app_constants.dart';

class LndhubService {
  final String url;
  final String authHeader;

  LndhubService({required this.url, required this.authHeader});

  factory LndhubService.fromQrData(String qrData) {
    final match = RegExp(r'lndhub://([^:]+):([^@]+)@(.+)').firstMatch(qrData);
    if (match == null) {
      throw Exception('QR LNDHub inválido');
    }

    final user = match.group(1)!;
    final pass = match.group(2)!;
    final baseUrl = match.group(3)!;

    final cleanUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    final credentials = base64.encode(utf8.encode('$user:$pass'));

    return LndhubService(url: cleanUrl, authHeader: 'Basic $credentials');
  }

  Future<InvoiceResponse> createInvoice(int amountSats, String memo) async {
    try {
      final response = await http
          .post(
            Uri.parse('$url/api/v2/lndhub/invoice'),
            headers: {
              'Authorization': authHeader,
              'Content-Type': 'application/json',
            },
            body: json.encode({'amount': amountSats, 'memo': memo}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return InvoiceResponse(
          paymentRequest: data['payment_request'] as String,
          paymentHash: data['payment_hash'] as String,
        );
      } else {
        throw Exception('Error creando invoice: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error conectando a LNDHub: $e');
    }
  }

  Stream<bool> watchPayment(String paymentHash) async* {
    final wsUrl = url.replaceFirst('http', 'wss');
    final ws = WebSocketChannel.connect(
      Uri.parse('$wsUrl/api/v2/lndhub/invoice/$paymentHash/wait'),
      protocols: ['Authorization', authHeader],
    );

    try {
      await for (final message in ws.stream) {
        if (message == null) continue;

        final data = json.decode(message as String) as Map<String, dynamic>;
        final settled = data['settled'] == true || data['settled'] == 1;
        yield settled;

        if (settled) break;
      }
    } catch (e) {
      yield false;
    } finally {
      await ws.sink.close();
    }
  }

  Future<bool> checkPayment(String paymentHash) async {
    try {
      final response = await http
          .get(
            Uri.parse('$url/api/v2/lndhub/invoice/$paymentHash'),
            headers: {'Authorization': authHeader},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data['settled'] == true || data['settled'] == 1;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> testConnection() async {
    try {
      final response = await http
          .get(
            Uri.parse('$url/api/v2/lndhub/getinfo'),
            headers: {'Authorization': authHeader},
          )
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<LndhubService?> tryConnect({
    required String localUrl,
    required String productionUrl,
    required String authHeader,
  }) async {
    try {
      final localService = LndhubService(url: localUrl, authHeader: authHeader);
      if (await localService.testConnection()) {
        return localService;
      }
    } catch (_) {}

    try {
      final prodService = LndhubService(
        url: productionUrl,
        authHeader: authHeader,
      );
      if (await prodService.testConnection()) {
        return prodService;
      }
    } catch (_) {}

    return null;
  }
}

class InvoiceResponse {
  final String paymentRequest;
  final String paymentHash;

  InvoiceResponse({required this.paymentRequest, required this.paymentHash});
}
