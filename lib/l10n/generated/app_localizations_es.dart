// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcome_title => 'La Chispa';

  @override
  String get welcome_subtitle => 'Punto de Venta Lightning';

  @override
  String get get_started_button => 'COMENZAR';

  @override
  String get login_title => 'LaChispaPOS';

  @override
  String get login_subtitle => 'Punto de Venta Lightning';

  @override
  String get username_label => 'Nombre';

  @override
  String get username_placeholder => 'Ingrese su nombre';

  @override
  String get username_required_error => 'Ingrese su nombre';

  @override
  String get select_role => 'Seleccionar Rol';

  @override
  String get employee_role => 'Dependiente';

  @override
  String get boss_role => 'Jefe';

  @override
  String get login_button => 'ENTRAR';

  @override
  String get scan_qr_button => 'Escanear QR API Key';

  @override
  String get verifying_api_key => 'Verificando API Key...';

  @override
  String get api_key_error => 'Error: Verifique la API Key';

  @override
  String get invalid_qr => 'QR inválido';

  @override
  String get api_key_not_found => 'API Key no encontrada';

  @override
  String get boss_panel_title => 'Panel Jefe';

  @override
  String get import_sales => 'IMPORTAR BD';

  @override
  String get import_sales_subtitle => 'Importar archivo JSON de dependiente';

  @override
  String get view_history => 'VER HISTORIAL';

  @override
  String get view_history_subtitle => 'Todas las ventas importadas';

  @override
  String get delete_sales => 'ELIMINAR VENTAS';

  @override
  String get delete_sales_subtitle => 'Borrar todo el historial';

  @override
  String get delete_imported_db => 'Eliminar BD Importadas';

  @override
  String get delete_all_imported_confirm =>
      '¿Eliminar todas las ventas importadas?';

  @override
  String get cancel_button => 'Cancelar';

  @override
  String get delete_button => 'Eliminar';

  @override
  String get import_button => 'Importar';

  @override
  String get sales_imported => 'ventas importadas';

  @override
  String get imported_db_deleted => 'BD eliminadas';

  @override
  String get employee_name => 'Dependiente';

  @override
  String get total_sales => 'Ventas';

  @override
  String get total_sats_label => 'Total sats';

  @override
  String get employee_panel_title => 'Panel de Ventas';

  @override
  String get new_sale => 'NUEVA VENTA';

  @override
  String get new_sale_subtitle => 'Iniciar una nueva venta';

  @override
  String get pending_sales => 'VENTAS PENDIENTES';

  @override
  String get pending_sales_subtitle => 'Ver ventas pendientes';

  @override
  String get total_today => 'Total Hoy';

  @override
  String get sales_count => 'Ventas';

  @override
  String get sale_title => 'Nueva Venta';

  @override
  String get add_product => 'Agregar Producto';

  @override
  String get product_name => 'Producto';

  @override
  String get product_price => 'Precio';

  @override
  String get quantity => 'Cantidad';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get total => 'Total';

  @override
  String get clear_cart => 'Limpiar';

  @override
  String get process_sale => 'PROCESAR VENTA';

  @override
  String get sale_processing => 'PROCESANDO...';

  @override
  String get no_products => 'No hay productos';

  @override
  String get scan_product => 'Escanear Producto';

  @override
  String get manual_product => 'Agregar Manual';

  @override
  String get select_currency => 'Moneda';

  @override
  String get currency_usd => 'USD - Dólar';

  @override
  String get currency_eur => 'EUR - Euro';

  @override
  String get currency_cup => 'CUP - Peso Cubano';

  @override
  String get currency_mlc => 'MLC - Moneda Convertible';

  @override
  String get mlc_full_name => 'MLC - Moneda Convertible (CBDC)';

  @override
  String get currency_gbp => 'GBP - Libra Esterlina';

  @override
  String get currency_cad => 'CAD - Dólar Canadiense';

  @override
  String get currency_jpy => 'JPY - Yen Japonés';

  @override
  String get currency_aud => 'AUD - Dólar Australiano';

  @override
  String get currency_chf => 'CHF - Franco Suizo';

  @override
  String get currency_sat => 'SAT - Satoshis';

  @override
  String get history_title => 'Historial de Ventas';

  @override
  String get filter_by_date => 'Filtrar por fecha';

  @override
  String get filter_by_employee => 'Filtrar por empleado';

  @override
  String get no_sales => 'No hay ventas';

  @override
  String get export_sales => 'Exportar';

  @override
  String get export_json => 'Exportar JSON';

  @override
  String get export_csv => 'Exportar CSV';

  @override
  String get sale_date => 'Fecha';

  @override
  String get sale_employee => 'Empleado';

  @override
  String get sale_total => 'Total';

  @override
  String get sale_items => 'Productos';

  @override
  String get settings_title => 'Configuración';

  @override
  String get language_settings => 'Idioma';

  @override
  String get currency_settings => 'Monedas';

  @override
  String get server_settings => 'Servidor';

  @override
  String get about_app => 'Acerca de';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get about_title => 'Acerca de LaChispaPOS';

  @override
  String get about_version => 'Versión';

  @override
  String get about_description =>
      'Punto de Venta Lightning - Una aplicación para gestionar ventas utilizando Bitcoin a través de Lightning Network.';

  @override
  String get pending_sale_title => 'Venta Pendiente';

  @override
  String get pending_sale_message => 'Tienes una venta pendiente:';

  @override
  String get continue_sale => 'Continuar';

  @override
  String get discard_sale => 'Descartar';

  @override
  String get error_generic => 'Error';

  @override
  String get success => 'Éxito';

  @override
  String get loading => 'Cargando...';

  @override
  String get retry => 'Reintentar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get ok => 'Aceptar';

  @override
  String get save => 'Guardar';

  @override
  String get close => 'Cerrar';

  @override
  String get select_language => 'Seleccionar idioma';

  @override
  String get invoice_key_qr_title => 'QR de Clave de Facturación';

  @override
  String get no_invoice_key_configured => 'No hay Invoice Key configurada';

  @override
  String get select_currencies_hint => 'Selecciona las monedas que deseas usar';

  @override
  String get invoice_qr_title => 'QR Invoice';

  @override
  String get copy_button => 'Copiar';

  @override
  String get step_connect_1 => 'Abre LaChispa (la billetera del owner)';

  @override
  String get step_connect_2 => 'Menú lateral > QR de Clave de Facturación';

  @override
  String get step_connect_3 => 'Se mostrará el QR para escanear';

  @override
  String get step_connect_4 => 'Escanea el QR desde la app POS';

  @override
  String get steps_subtitle => 'El QR contiene la URL y la API Key juntos';

  @override
  String get features_title => 'FUNCIONES';

  @override
  String get roles_title => 'ROLES';

  @override
  String get how_to_connect => 'CÓMO CONECTAR';

  @override
  String get steps_title => 'Pasos para conectar:';

  @override
  String get developed_with => 'Desarrollado con';

  @override
  String get no_sales_to_export => 'No hay ventas para exportar';

  @override
  String get sales_deleted => 'Ventas eliminadas';

  @override
  String get employee => 'Dependiente';

  @override
  String get delete_sale_confirm => '¿Eliminar esta venta?';

  @override
  String get delete_sales_title => 'Eliminar Ventas';

  @override
  String get import_sales_title => 'Importar Ventas';

  @override
  String get invalid_price => 'Precio inválido';

  @override
  String get enter_product_and_price => 'Ingrese producto y precio';

  @override
  String get empty_cart => 'Carrito vacío';

  @override
  String get configure_api_in_settings => 'Configure API en Settings';

  @override
  String get error_creating_invoice => 'Error creando invoice';

  @override
  String get payment_received => '¡Pago recibido!';

  @override
  String get payment_error => 'Error en pago';

  @override
  String get waiting_for_payment => 'Esperando Pago';

  @override
  String get cobrar => 'COBRAR';

  @override
  String get copiado => 'Copiado';

  @override
  String get compartir => 'Compartir';

  @override
  String get pending_sale_confirm =>
      'Tiene una venta pendiente. ¿Desea retomarla?';

  @override
  String get retomar => 'Retomar';

  @override
  String get discard_confirm => '¿Eliminar todas las ventas importadas?';
}
