import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/services/lachispa_api_service.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _urlController = TextEditingController(text: 'https://lachispa.me');
  final _apiKeyController = TextEditingController();
  bool _showScanApi = false;
  bool _testing = false;
  bool? _connectionOk;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    if (user?.lndhubUrl != null) {
      _urlController.text = user!.lndhubUrl!;
    }
    if (user?.lndhubCreds != null) {
      _apiKeyController.text = user!.lndhubCreds!;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    if (_urlController.text.isEmpty || _apiKeyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete todos los campos')),
      );
      return;
    }

    setState(() {
      _testing = true;
      _connectionOk = null;
    });

    try {
      LachispaApiService.instance.configure(
        baseUrl: _urlController.text.trim(),
        apiKey: _apiKeyController.text.trim(),
      );

      final ok = await LachispaApiService.instance.testConnection();

      setState(() => _connectionOk = ok);

      if (ok && mounted) {
        final auth = context.read<AuthProvider>();
        await auth.updateLndhub(
          url: _urlController.text.trim(),
          creds: _apiKeyController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Configuración guardada'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _connectionOk = false);
    } finally {
      setState(() => _testing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showScanApi) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: const Text('Escanear QR API'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() => _showScanApi = false),
          ),
        ),
        body: MobileScanner(
          onDetect: (capture) {
            final barcodes = capture.barcodes;
            if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
              final data = barcodes.first.rawValue!;
              if (data.startsWith('lndhub://')) {
                final uri = Uri.parse(
                  data.replaceFirst('lndhub://', 'lachispa://'),
                );
                _urlController.text = uri.host + uri.path;
                _apiKeyController.text = uri.userInfo;
              } else if (data.startsWith('lachispa://')) {
                final uri = Uri.parse(data);
                _urlController.text = uri.host + uri.path;
                _apiKeyController.text = uri.queryParameters['key'] ?? '';
              } else {
                _apiKeyController.text = data;
                _urlController.text = 'https://lachispa.me';
              }
              setState(() => _showScanApi = false);
              _testConnection();
            }
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Configuración')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'API Lachispa.me',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Ingrese la API Key de su wallet',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            Center(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _showScanApi = true),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Escanear QR API'),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'O ingrese manualmente:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL',
                hintText: 'https://lachispa.me o http://192.168.1.x:5000',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _apiKeyController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'API Key'),
            ),
            const SizedBox(height: 24),
            if (_connectionOk != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: _connectionOk!
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      _connectionOk! ? Icons.check_circle : Icons.error,
                      color: _connectionOk! ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _connectionOk! ? 'Conexión exitosa' : 'Error de conexión',
                      style: TextStyle(
                        color: _connectionOk! ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _testing ? null : _testConnection,
                child: _testing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('GUARDAR Y PROBAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
