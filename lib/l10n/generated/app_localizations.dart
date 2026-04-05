import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
  ];

  /// No description provided for @welcome_title.
  ///
  /// In es, this message translates to:
  /// **'La Chispa'**
  String get welcome_title;

  /// No description provided for @welcome_subtitle.
  ///
  /// In es, this message translates to:
  /// **'Punto de Venta Lightning'**
  String get welcome_subtitle;

  /// No description provided for @get_started_button.
  ///
  /// In es, this message translates to:
  /// **'COMENZAR'**
  String get get_started_button;

  /// No description provided for @login_title.
  ///
  /// In es, this message translates to:
  /// **'LaChispaPOS'**
  String get login_title;

  /// No description provided for @login_subtitle.
  ///
  /// In es, this message translates to:
  /// **'Punto de Venta Lightning'**
  String get login_subtitle;

  /// No description provided for @username_label.
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get username_label;

  /// No description provided for @username_placeholder.
  ///
  /// In es, this message translates to:
  /// **'Ingrese su nombre'**
  String get username_placeholder;

  /// No description provided for @username_required_error.
  ///
  /// In es, this message translates to:
  /// **'Ingrese su nombre'**
  String get username_required_error;

  /// No description provided for @select_role.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Rol'**
  String get select_role;

  /// No description provided for @employee_role.
  ///
  /// In es, this message translates to:
  /// **'Dependiente'**
  String get employee_role;

  /// No description provided for @boss_role.
  ///
  /// In es, this message translates to:
  /// **'Jefe'**
  String get boss_role;

  /// No description provided for @login_button.
  ///
  /// In es, this message translates to:
  /// **'ENTRAR'**
  String get login_button;

  /// No description provided for @scan_qr_button.
  ///
  /// In es, this message translates to:
  /// **'Escanear QR API Key'**
  String get scan_qr_button;

  /// No description provided for @verifying_api_key.
  ///
  /// In es, this message translates to:
  /// **'Verificando API Key...'**
  String get verifying_api_key;

  /// No description provided for @api_key_error.
  ///
  /// In es, this message translates to:
  /// **'Error: Verifique la API Key'**
  String get api_key_error;

  /// No description provided for @invalid_qr.
  ///
  /// In es, this message translates to:
  /// **'QR inválido'**
  String get invalid_qr;

  /// No description provided for @api_key_not_found.
  ///
  /// In es, this message translates to:
  /// **'API Key no encontrada'**
  String get api_key_not_found;

  /// No description provided for @boss_panel_title.
  ///
  /// In es, this message translates to:
  /// **'Panel Jefe'**
  String get boss_panel_title;

  /// No description provided for @import_sales.
  ///
  /// In es, this message translates to:
  /// **'IMPORTAR BD'**
  String get import_sales;

  /// No description provided for @import_sales_subtitle.
  ///
  /// In es, this message translates to:
  /// **'Importar archivo JSON de dependiente'**
  String get import_sales_subtitle;

  /// No description provided for @view_history.
  ///
  /// In es, this message translates to:
  /// **'VER HISTORIAL'**
  String get view_history;

  /// No description provided for @view_history_subtitle.
  ///
  /// In es, this message translates to:
  /// **'Todas las ventas importadas'**
  String get view_history_subtitle;

  /// No description provided for @delete_sales.
  ///
  /// In es, this message translates to:
  /// **'ELIMINAR VENTAS'**
  String get delete_sales;

  /// No description provided for @delete_sales_subtitle.
  ///
  /// In es, this message translates to:
  /// **'Borrar todo el historial'**
  String get delete_sales_subtitle;

  /// No description provided for @delete_imported_db.
  ///
  /// In es, this message translates to:
  /// **'Eliminar BD Importadas'**
  String get delete_imported_db;

  /// No description provided for @delete_all_imported_confirm.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar todas las ventas importadas?'**
  String get delete_all_imported_confirm;

  /// No description provided for @cancel_button.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel_button;

  /// No description provided for @delete_button.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete_button;

  /// No description provided for @import_button.
  ///
  /// In es, this message translates to:
  /// **'Importar'**
  String get import_button;

  /// No description provided for @sales_imported.
  ///
  /// In es, this message translates to:
  /// **'ventas importadas'**
  String get sales_imported;

  /// No description provided for @imported_db_deleted.
  ///
  /// In es, this message translates to:
  /// **'BD eliminadas'**
  String get imported_db_deleted;

  /// No description provided for @employee_name.
  ///
  /// In es, this message translates to:
  /// **'Dependiente'**
  String get employee_name;

  /// No description provided for @total_sales.
  ///
  /// In es, this message translates to:
  /// **'Ventas'**
  String get total_sales;

  /// No description provided for @total_sats_label.
  ///
  /// In es, this message translates to:
  /// **'Total sats'**
  String get total_sats_label;

  /// No description provided for @employee_panel_title.
  ///
  /// In es, this message translates to:
  /// **'Panel de Ventas'**
  String get employee_panel_title;

  /// No description provided for @new_sale.
  ///
  /// In es, this message translates to:
  /// **'NUEVA VENTA'**
  String get new_sale;

  /// No description provided for @new_sale_subtitle.
  ///
  /// In es, this message translates to:
  /// **'Iniciar una nueva venta'**
  String get new_sale_subtitle;

  /// No description provided for @pending_sales.
  ///
  /// In es, this message translates to:
  /// **'VENTAS PENDIENTES'**
  String get pending_sales;

  /// No description provided for @pending_sales_subtitle.
  ///
  /// In es, this message translates to:
  /// **'Ver ventas pendientes'**
  String get pending_sales_subtitle;

  /// No description provided for @total_today.
  ///
  /// In es, this message translates to:
  /// **'Total Hoy'**
  String get total_today;

  /// No description provided for @sales_count.
  ///
  /// In es, this message translates to:
  /// **'Ventas'**
  String get sales_count;

  /// No description provided for @sale_title.
  ///
  /// In es, this message translates to:
  /// **'Nueva Venta'**
  String get sale_title;

  /// No description provided for @add_product.
  ///
  /// In es, this message translates to:
  /// **'Agregar Producto'**
  String get add_product;

  /// No description provided for @product_name.
  ///
  /// In es, this message translates to:
  /// **'Producto'**
  String get product_name;

  /// No description provided for @product_price.
  ///
  /// In es, this message translates to:
  /// **'Precio'**
  String get product_price;

  /// No description provided for @quantity.
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get quantity;

  /// No description provided for @subtotal.
  ///
  /// In es, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @total.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @clear_cart.
  ///
  /// In es, this message translates to:
  /// **'Limpiar'**
  String get clear_cart;

  /// No description provided for @process_sale.
  ///
  /// In es, this message translates to:
  /// **'PROCESAR VENTA'**
  String get process_sale;

  /// No description provided for @sale_processing.
  ///
  /// In es, this message translates to:
  /// **'PROCESANDO...'**
  String get sale_processing;

  /// No description provided for @no_products.
  ///
  /// In es, this message translates to:
  /// **'No hay productos'**
  String get no_products;

  /// No description provided for @scan_product.
  ///
  /// In es, this message translates to:
  /// **'Escanear Producto'**
  String get scan_product;

  /// No description provided for @manual_product.
  ///
  /// In es, this message translates to:
  /// **'Agregar Manual'**
  String get manual_product;

  /// No description provided for @select_currency.
  ///
  /// In es, this message translates to:
  /// **'Moneda'**
  String get select_currency;

  /// No description provided for @currency_usd.
  ///
  /// In es, this message translates to:
  /// **'USD - Dólar'**
  String get currency_usd;

  /// No description provided for @currency_eur.
  ///
  /// In es, this message translates to:
  /// **'EUR - Euro'**
  String get currency_eur;

  /// No description provided for @currency_cup.
  ///
  /// In es, this message translates to:
  /// **'CUP - Peso Cubano'**
  String get currency_cup;

  /// No description provided for @currency_mlc.
  ///
  /// In es, this message translates to:
  /// **'MLC - Peso Convertible'**
  String get currency_mlc;

  /// No description provided for @currency_gbp.
  ///
  /// In es, this message translates to:
  /// **'GBP - Libra Esterlina'**
  String get currency_gbp;

  /// No description provided for @currency_cad.
  ///
  /// In es, this message translates to:
  /// **'CAD - Dólar Canadiense'**
  String get currency_cad;

  /// No description provided for @currency_jpy.
  ///
  /// In es, this message translates to:
  /// **'JPY - Yen Japonés'**
  String get currency_jpy;

  /// No description provided for @currency_aud.
  ///
  /// In es, this message translates to:
  /// **'AUD - Dólar Australiano'**
  String get currency_aud;

  /// No description provided for @currency_chf.
  ///
  /// In es, this message translates to:
  /// **'CHF - Franco Suizo'**
  String get currency_chf;

  /// No description provided for @currency_sat.
  ///
  /// In es, this message translates to:
  /// **'SAT - Satoshis'**
  String get currency_sat;

  /// No description provided for @history_title.
  ///
  /// In es, this message translates to:
  /// **'Historial de Ventas'**
  String get history_title;

  /// No description provided for @filter_by_date.
  ///
  /// In es, this message translates to:
  /// **'Filtrar por fecha'**
  String get filter_by_date;

  /// No description provided for @filter_by_employee.
  ///
  /// In es, this message translates to:
  /// **'Filtrar por empleado'**
  String get filter_by_employee;

  /// No description provided for @no_sales.
  ///
  /// In es, this message translates to:
  /// **'No hay ventas'**
  String get no_sales;

  /// No description provided for @export_sales.
  ///
  /// In es, this message translates to:
  /// **'Exportar'**
  String get export_sales;

  /// No description provided for @export_json.
  ///
  /// In es, this message translates to:
  /// **'Exportar JSON'**
  String get export_json;

  /// No description provided for @export_csv.
  ///
  /// In es, this message translates to:
  /// **'Exportar CSV'**
  String get export_csv;

  /// No description provided for @sale_date.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get sale_date;

  /// No description provided for @sale_employee.
  ///
  /// In es, this message translates to:
  /// **'Empleado'**
  String get sale_employee;

  /// No description provided for @sale_total.
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get sale_total;

  /// No description provided for @sale_items.
  ///
  /// In es, this message translates to:
  /// **'Productos'**
  String get sale_items;

  /// No description provided for @settings_title.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get settings_title;

  /// No description provided for @language_settings.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language_settings;

  /// No description provided for @currency_settings.
  ///
  /// In es, this message translates to:
  /// **'Monedas'**
  String get currency_settings;

  /// No description provided for @server_settings.
  ///
  /// In es, this message translates to:
  /// **'Servidor'**
  String get server_settings;

  /// No description provided for @about_app.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get about_app;

  /// No description provided for @logout.
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get logout;

  /// No description provided for @about_title.
  ///
  /// In es, this message translates to:
  /// **'Acerca de LaChispaPOS'**
  String get about_title;

  /// No description provided for @about_version.
  ///
  /// In es, this message translates to:
  /// **'Versión'**
  String get about_version;

  /// No description provided for @about_description.
  ///
  /// In es, this message translates to:
  /// **'Punto de Venta Lightning - Una aplicación para gestionar ventas utilizando Bitcoin a través de Lightning Network.'**
  String get about_description;

  /// No description provided for @pending_sale_title.
  ///
  /// In es, this message translates to:
  /// **'Venta Pendiente'**
  String get pending_sale_title;

  /// No description provided for @pending_sale_message.
  ///
  /// In es, this message translates to:
  /// **'Tienes una venta pendiente:'**
  String get pending_sale_message;

  /// No description provided for @continue_sale.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continue_sale;

  /// No description provided for @discard_sale.
  ///
  /// In es, this message translates to:
  /// **'Descartar'**
  String get discard_sale;

  /// No description provided for @error_generic.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get error_generic;

  /// No description provided for @success.
  ///
  /// In es, this message translates to:
  /// **'Éxito'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @confirm.
  ///
  /// In es, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @yes.
  ///
  /// In es, this message translates to:
  /// **'Sí'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get ok;

  /// No description provided for @save.
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// No description provided for @select_language.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar idioma'**
  String get select_language;

  /// No description provided for @invoice_key_qr_title.
  ///
  /// In es, this message translates to:
  /// **'QR de Clave de Facturación'**
  String get invoice_key_qr_title;

  /// No description provided for @no_invoice_key_configured.
  ///
  /// In es, this message translates to:
  /// **'No hay Invoice Key configurada'**
  String get no_invoice_key_configured;

  /// No description provided for @select_currencies_hint.
  ///
  /// In es, this message translates to:
  /// **'Selecciona las monedas que deseas usar'**
  String get select_currencies_hint;

  /// No description provided for @invoice_qr_title.
  ///
  /// In es, this message translates to:
  /// **'QR Invoice'**
  String get invoice_qr_title;

  /// No description provided for @copy_button.
  ///
  /// In es, this message translates to:
  /// **'Copiar'**
  String get copy_button;

  /// No description provided for @step_connect_1.
  ///
  /// In es, this message translates to:
  /// **'Abre LaChispa (la billetera del owner)'**
  String get step_connect_1;

  /// No description provided for @step_connect_2.
  ///
  /// In es, this message translates to:
  /// **'Menú lateral > QR de Clave de Facturación'**
  String get step_connect_2;

  /// No description provided for @step_connect_3.
  ///
  /// In es, this message translates to:
  /// **'Se mostrará el QR para escanear'**
  String get step_connect_3;

  /// No description provided for @step_connect_4.
  ///
  /// In es, this message translates to:
  /// **'Escanea el QR desde la app POS'**
  String get step_connect_4;

  /// No description provided for @steps_subtitle.
  ///
  /// In es, this message translates to:
  /// **'El QR contiene la URL y la API Key juntos'**
  String get steps_subtitle;

  /// No description provided for @features_title.
  ///
  /// In es, this message translates to:
  /// **'FUNCIONES'**
  String get features_title;

  /// No description provided for @roles_title.
  ///
  /// In es, this message translates to:
  /// **'ROLES'**
  String get roles_title;

  /// No description provided for @how_to_connect.
  ///
  /// In es, this message translates to:
  /// **'CÓMO CONECTAR'**
  String get how_to_connect;

  /// No description provided for @steps_title.
  ///
  /// In es, this message translates to:
  /// **'Pasos para conectar:'**
  String get steps_title;

  /// No description provided for @developed_with.
  ///
  /// In es, this message translates to:
  /// **'Desarrollado con'**
  String get developed_with;

  /// No description provided for @mlc_full_name.
  ///
  /// In es, this message translates to:
  /// **'MLC - Peso Convertible'**
  String get mlc_full_name;

  /// No description provided for @no_sales_to_export.
  ///
  /// In es, this message translates to:
  /// **'No hay ventas para exportar'**
  String get no_sales_to_export;

  /// No description provided for @sales_deleted.
  ///
  /// In es, this message translates to:
  /// **'Ventas eliminadas'**
  String get sales_deleted;

  /// No description provided for @employee.
  ///
  /// In es, this message translates to:
  /// **'Dependiente'**
  String get employee;

  /// No description provided for @delete_sale_confirm.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar esta venta?'**
  String get delete_sale_confirm;

  /// No description provided for @delete_sales_title.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Ventas'**
  String get delete_sales_title;

  /// No description provided for @import_sales_title.
  ///
  /// In es, this message translates to:
  /// **'Importar Ventas'**
  String get import_sales_title;

  /// No description provided for @invalid_price.
  ///
  /// In es, this message translates to:
  /// **'Precio inválido'**
  String get invalid_price;

  /// No description provided for @enter_product_and_price.
  ///
  /// In es, this message translates to:
  /// **'Ingrese producto y precio'**
  String get enter_product_and_price;

  /// No description provided for @empty_cart.
  ///
  /// In es, this message translates to:
  /// **'Carrito vacío'**
  String get empty_cart;

  /// No description provided for @configure_api_in_settings.
  ///
  /// In es, this message translates to:
  /// **'Configure API en Settings'**
  String get configure_api_in_settings;

  /// No description provided for @error_creating_invoice.
  ///
  /// In es, this message translates to:
  /// **'Error creando invoice'**
  String get error_creating_invoice;

  /// No description provided for @payment_received.
  ///
  /// In es, this message translates to:
  /// **'¡Pago recibido!'**
  String get payment_received;

  /// No description provided for @payment_error.
  ///
  /// In es, this message translates to:
  /// **'Error en pago'**
  String get payment_error;

  /// No description provided for @waiting_for_payment.
  ///
  /// In es, this message translates to:
  /// **'Esperando Pago'**
  String get waiting_for_payment;

  /// No description provided for @cobrar.
  ///
  /// In es, this message translates to:
  /// **'COBRAR'**
  String get cobrar;

  /// No description provided for @copiado.
  ///
  /// In es, this message translates to:
  /// **'Copiado'**
  String get copiado;

  /// No description provided for @compartir.
  ///
  /// In es, this message translates to:
  /// **'Compartir'**
  String get compartir;

  /// No description provided for @pending_sale_confirm.
  ///
  /// In es, this message translates to:
  /// **'Tiene una venta pendiente. ¿Desea retomarla?'**
  String get pending_sale_confirm;

  /// No description provided for @retomar.
  ///
  /// In es, this message translates to:
  /// **'Retomar'**
  String get retomar;

  /// No description provided for @discard_confirm.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar todas las ventas importadas?'**
  String get discard_confirm;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'pt',
    'ru',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
