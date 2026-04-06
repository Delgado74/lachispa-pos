import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/services/lachispa_api_service.dart';
import '../core/services/nfc_payment_service.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/sales_provider.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/total_display.dart';
import '../widgets/currency_selector.dart';
import '../widgets/qr_display.dart';
import '../l10n/generated/app_localizations.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  final _productoController = TextEditingController();
  final _precioController = TextEditingController();
  bool _showPaymentSheet = false;
  bool _isReadingNfc = false;
  String? _paymentRequest;
  String? _paymentHash;
  String? _pendingSaleId;

  final NfcPaymentService _nfcService = NfcPaymentService();

  @override
  void dispose() {
    _productoController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  void _agregarProducto() async {
    final l10n = AppLocalizations.of(context)!;
    final nombre = _productoController.text.trim();
    final precioTxt = _precioController.text.trim();

    if (nombre.isEmpty || precioTxt.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.enter_product_and_price)));
      return;
    }

    final precio = double.tryParse(precioTxt);
    if (precio == null || precio <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.invalid_price)));
      return;
    }

    try {
      await context.read<CartProvider>().addItem(
        nombre: nombre,
        precio: precio,
        cantidad: 1,
      );

      _productoController.clear();
      _precioController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error_generic}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _crearInvoice() async {
    final l10n = AppLocalizations.of(context)!;
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    final salesProvider = context.read<SalesProvider>();

    if (cart.totalSats <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.empty_cart)));
      return;
    }

    if (user?.lndhubUrl == null || user?.lndhubCreds == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.configure_api_in_settings)));
      return;
    }

    try {
      LachispaApiService.instance.configure(
        baseUrl: user!.lndhubUrl!,
        apiKey: user.lndhubCreds!,
      );

      final invoice = await LachispaApiService.instance.createInvoice(
        amountSats: cart.totalSats,
        memo: 'Venta POS - ${user.nombre}',
      );

      if (invoice.paymentRequest.isEmpty) {
        throw Exception('Payment request vacío');
      }

      final pendingSaleId = await salesProvider.createPendingSale(
        userId: user.id,
        userNombre: user.nombre,
        items: cart.items,
        totalFiat: cart.totalFiat,
        moneda: cart.monedaVenta.codigo,
        totalSats: cart.totalSats,
        rateUsado: cart.rateUsado,
        invoiceId: invoice.paymentHash,
      );

      _pendingSaleId = pendingSaleId;
      _paymentRequest = invoice.paymentRequest;
      _paymentHash = invoice.paymentHash;

      LachispaApiService.instance.connectWebSocket(user.lndhubCreds!);

      setState(() => _showPaymentSheet = true);

      _esperarPago(invoice.paymentHash, pendingSaleId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.error_creating_invoice}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _cobrarConNfc() async {
    final l10n = AppLocalizations.of(context)!;

    final nfcAvailable = await _nfcService.isNfcAvailable();
    if (!nfcAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.nfc_not_available),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() => _isReadingNfc = true);

    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser!;

    await _nfcService.readLnurlFromCard(
      onLnurlReceived: (lnurl) async {
        print('LNURL received from card: $lnurl');

        try {
          final invoiceResult = await LachispaApiService.instance
              .createInvoiceForLnurl(
                lnurl: lnurl,
                amountSats: cart.totalSats,
                memo: 'Venta POS - ${user.nombre}',
              );

          if (invoiceResult == null) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.lnurl_error),
                  backgroundColor: Colors.red,
                ),
              );
              setState(() => _isReadingNfc = false);
            }
            return;
          }

          await _nfcService.stopReading();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invoice creada. Esperando pago...'),
                backgroundColor: Colors.green,
              ),
            );
          }

          _esperarPago(invoiceResult.paymentHash, _pendingSaleId!);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${l10n.lnurl_error}: $e'),
                backgroundColor: Colors.red,
              ),
            );
            setState(() => _isReadingNfc = false);
          }
          await _nfcService.stopReading();
        }
      },
      onError: (error) async {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.nfc_error}: $error'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isReadingNfc = false);
        }
        await _nfcService.stopReading();
      },
    );
  }

  Future<void> _esperarPago(String paymentHash, String saleId) async {
    final l10n = AppLocalizations.of(context)!;
    final cart = context.read<CartProvider>();
    final salesProvider = context.read<SalesProvider>();

    try {
      await for (final settled in LachispaApiService.instance.watchPayment(
        paymentHash,
      )) {
        if (!mounted) return;

        if (settled) {
          await salesProvider.markSaleAsCompleted(saleId);

          await cart.clearCart();
          LachispaApiService.instance.disconnect();

          if (mounted) {
            setState(() {
              _showPaymentSheet = false;
              _isReadingNfc = false;
              _pendingSaleId = null;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.payment_received),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.of(context).popUntil((route) => route.isFirst);
          }
          return;
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.payment_error}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cart = context.watch<CartProvider>();

    if (_showPaymentSheet && _paymentRequest != null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(title: Text(l10n.waiting_for_payment)),
        body: Center(
          child: QrDisplay(
            paymentRequest: _paymentRequest!,
            totalFiat: cart.totalFiat,
            totalSats: cart.totalSats,
            onPayWithNfc: () {
              setState(() {
                _showPaymentSheet = false;
              });
              _cobrarConNfc();
            },
            onCancel: () {
              setState(() => _showPaymentSheet = false);
              LachispaApiService.instance.disconnect();
            },
          ),
        ),
      );
    }

    if (_isReadingNfc) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          title: Text(l10n.waiting_for_payment),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              await _nfcService.stopReading();
              setState(() => _isReadingNfc = false);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.nfc, size: 100, color: Color(0xFFF0A500)),
              const SizedBox(height: 24),
              Text(
                l10n.nfc_ready,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${cart.totalFiat.toStringAsFixed(2)} ${cart.monedaVenta.codigo}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF0A500),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${cart.totalSats} sats',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.sale_title),
        actions: [
          if (cart.hasItems)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => cart.clearCart(),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _productoController,
                    decoration: const InputDecoration(
                      labelText: 'Producto',
                      hintText: 'Nombre',
                    ),
                    onSubmitted: (_) => _agregarProducto(),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _precioController,
                    decoration: const InputDecoration(labelText: 'Precio'),
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _agregarProducto(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _agregarProducto,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CurrencySelector(
              selected: cart.monedaVenta,
              onChanged: (m) => cart.setMoneda(m),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: cart.hasItems
                ? ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return CartItemTile(
                        nombre: item.nombre,
                        precioUnitario: item.precioUnitario,
                        moneda: item.moneda,
                        cantidad: item.cantidad,
                        subtotal: item.subtotalFiat,
                        subtotalSats: item.subtotalSats,
                        onDecrement: item.cantidad > 1
                            ? () =>
                                  cart.updateQuantity(index, item.cantidad - 1)
                            : null,
                        onIncrement: () =>
                            cart.updateQuantity(index, item.cantidad + 1),
                        onDelete: () => cart.removeItem(index),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'Agregue productos',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ),
          TotalDisplay(
            totalFiat: cart.totalFiat,
            moneda: cart.monedaVenta.codigo,
            totalSats: cart.totalSats,
            rateUsado: cart.rateUsado,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: cart.hasItems ? _crearInvoice : null,
                icon: const Icon(Icons.payment),
                label: Text(l10n.cobrar),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
