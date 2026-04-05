import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/services/lachispa_api_service.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/sales_provider.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/total_display.dart';
import '../widgets/currency_selector.dart';
import '../widgets/qr_display.dart';

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  final _productoController = TextEditingController();
  final _precioController = TextEditingController();
  bool _showPaymentSheet = false;
  String? _paymentRequest;
  String? _paymentHash;
  String? _pendingSaleId;

  @override
  void dispose() {
    _productoController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  void _agregarProducto() async {
    final nombre = _productoController.text.trim();
    final precioTxt = _precioController.text.trim();

    if (nombre.isEmpty || precioTxt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese producto y precio')),
      );
      return;
    }

    final precio = double.tryParse(precioTxt);
    if (precio == null || precio <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Precio inválido')));
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
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _crearInvoice() async {
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    final salesProvider = context.read<SalesProvider>();

    if (cart.totalSats <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Carrito vacío')));
      return;
    }

    if (user?.lndhubUrl == null || user?.lndhubCreds == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configure API en Settings')),
      );
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

      print('Invoice created: ${invoice.paymentHash}');
      print('Payment request: ${invoice.paymentRequest}');
      print('Total sats: ${cart.totalSats}');

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

      LachispaApiService.instance.connectWebSocket(user.lndhubCreds!);

      setState(() {
        _paymentRequest = invoice.paymentRequest;
        _paymentHash = invoice.paymentHash;
        _showPaymentSheet = true;
      });

      _esperarPago(invoice.paymentHash, pendingSaleId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creando invoice: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _esperarPago(String paymentHash, String saleId) async {
    final cart = context.read<CartProvider>();
    final salesProvider = context.read<SalesProvider>();
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser!;

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
            setState(() => _showPaymentSheet = false);
            _pendingSaleId = null;

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Pago recibido!'),
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
            content: Text('Error en pago: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    if (_showPaymentSheet && _paymentRequest != null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(title: const Text('Esperando Pago')),
        body: Center(
          child: QrDisplay(
            paymentRequest: _paymentRequest!,
            totalFiat: cart.totalFiat,
            totalSats: cart.totalSats,
            onCancel: () {
              setState(() => _showPaymentSheet = false);
              LachispaApiService.instance.disconnect();
            },
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Nueva Venta'),
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
              child: ElevatedButton(
                onPressed: cart.hasItems ? _crearInvoice : null,
                child: const Text('COBRAR'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
