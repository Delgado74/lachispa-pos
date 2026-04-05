import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../core/services/lachispa_api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  String _rol = 'dependiente';
  bool _showScanQr = false;

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.login(nombre: _nombreController.text.trim(), rol: _rol);

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _showScanDialog(String type) {
    setState(() {
      _showScanQr = true;
    });
  }

  Future<void> _handleQrScan(String qrData) async {
    try {
      String? apiKey;
      String? url;

      if (qrData.startsWith('lndhub://')) {
        final uri = Uri.parse(qrData.replaceFirst('lndhub://', 'https://'));
        apiKey = uri.userInfo.split(':').last;
        url = '${uri.scheme}://${uri.host}${uri.path}';
      } else if (qrData.startsWith('lachispa://')) {
        final uri = Uri.parse(qrData);
        apiKey = uri.queryParameters['key'];
        url = 'https://${uri.host}';
      } else {
        apiKey = qrData;
        url = null;
      }

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception(l10n.api_key_not_found);
      }

      final authProvider = context.read<AuthProvider>();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.verifying_api_key),
            duration: const Duration(seconds: 1),
          ),
        );
      }

      LachispaApiService.instance.configure(
        baseUrl: url ?? 'https://lachispa.me',
        apiKey: apiKey,
      );

      final testOk = await LachispaApiService.instance.testConnection();

      if (!mounted) return;

      if (testOk) {
        await authProvider.login(
          nombre: _nombreController.text.trim(),
          rol: _rol,
          lndhubUrl: url ?? 'https://lachispa.me',
          lndhubCreds: apiKey,
        );

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.api_key_error),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _showScanQr = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.invalid_qr}: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _showScanQr = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = this.l10n;
    if (_showScanQr) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: Text(l10n.scan_qr_button),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() => _showScanQr = false),
          ),
        ),
        body: MobileScanner(
          onDetect: (capture) {
            final barcodes = capture.barcodes;
            if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
              _handleQrScan(barcodes.first.rawValue!);
            }
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/Logo/chispabordesredondos.png',
                    height: 100,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.login_title,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.login_subtitle,
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 48),
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(
                      labelText: l10n.username_label,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.username_required_error;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.select_role,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _RoleOption(
                                label: l10n.employee_role,
                                icon: Icons.person,
                                selected: _rol == 'dependiente',
                                onTap: () =>
                                    setState(() => _rol = 'dependiente'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _RoleOption(
                                label: l10n.boss_role,
                                icon: Icons.admin_panel_settings,
                                selected: _rol == 'jefe',
                                onTap: () => setState(() => _rol = 'jefe'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(l10n.login_button),
                      ),
                    ),
                  ),
                  if (_rol == 'dependiente') ...[
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => _showScanDialog('api'),
                      icon: const Icon(Icons.qr_code_scanner),
                      label: Text(l10n.scan_qr_button),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryColor.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppTheme.primaryColor : Colors.grey[700]!,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected ? AppTheme.primaryColor : Colors.grey,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppTheme.primaryColor : Colors.grey,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
