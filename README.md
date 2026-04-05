# LaChispaPOS

Punto de Venta Lightning para LNBits (Lachispa.me)

## Descripción

LaChispaPOS es una aplicación de punto de venta (POS) que permite cobrar en Bitcoin Lightning Network usando billeteras LNBits. Diseñado para negocios que usan Lachispa.me como billetera.

## Características

- 💰 Cobro por QR Lightning
- 🌐 Multi-moneda (CUP, MLC, USD, EUR, SATs)
- 📈 Tasas de cambio en tiempo real (Yadio.io)
- 👥 Roles: Dependiente y Jefe
- 📤 Exportar/Importar ventas
- 💾 Ventas pendientes (recuperación si se cierra la app)
- 📱 Interfaz oscura estilo Lachispa

## Cómo Conectar

### Opción 1: Escaneo de QR (Recomendado)

1. Abre **LaChispa** (la billetera Lightning del owner)
2. Ve a **Menú lateral** → **QR de Clave de Facturación**
3. Se mostrará el **QR** para escanear
4. Escanea el **QR** desde la app LaChispaPOS en la pantalla de login

### Opción 2: Manual

1. En la app, ve a **Configuración** (icono QR)
2. Copia la **Invoice/read key** manualmente
3. Pega en el campo **API Key**
4. Toca **Guardar y probar**

## Roles

### Dependiente
- Realizar ventas
- Exportar base de datos
- Ver historial propio

### Jefe
- Importar ventas de dependientes
- Ver todas las ventas
- Eliminar ventas importadas

## Monedas Soportadas

- CUP (Peso Cubano)
- MLC (Moneda Convertible - CBDC)
- USD (Dólar Estadounidense)
- EUR (Euro)
- GBP (Libra Esterlina)
- CAD (Dólar Canadiense)
- JPY (Yen Japonés)
- AUD (Dólar Australiano)
- CHF (Franco Suizo)
- SATs (Satoshis)

## Instalación

```bash
flutter pub get
flutter build apk --debug
```

## Tech Stack

- Flutter
- Provider (State Management)
- SQLite (Base de datos local)
- LNBits API
- Yadio.io (Tasas de cambio)

## Licencia

MIT
