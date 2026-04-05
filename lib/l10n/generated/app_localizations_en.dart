// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome_title => 'La Chispa';

  @override
  String get welcome_subtitle => 'Lightning POS';

  @override
  String get get_started_button => 'GET STARTED';

  @override
  String get login_title => 'LaChispaPOS';

  @override
  String get login_subtitle => 'Lightning POS';

  @override
  String get username_label => 'Name';

  @override
  String get username_placeholder => 'Enter your name';

  @override
  String get username_required_error => 'Enter your name';

  @override
  String get select_role => 'Select Role';

  @override
  String get employee_role => 'Employee';

  @override
  String get boss_role => 'Boss';

  @override
  String get login_button => 'LOGIN';

  @override
  String get scan_qr_button => 'Scan API Key QR';

  @override
  String get verifying_api_key => 'Verifying API Key...';

  @override
  String get api_key_error => 'Error: Verify API Key';

  @override
  String get invalid_qr => 'Invalid QR';

  @override
  String get api_key_not_found => 'API Key not found';

  @override
  String get boss_panel_title => 'Boss Panel';

  @override
  String get import_sales => 'IMPORT DB';

  @override
  String get import_sales_subtitle => 'Import JSON file from employee';

  @override
  String get view_history => 'VIEW HISTORY';

  @override
  String get view_history_subtitle => 'All imported sales';

  @override
  String get delete_sales => 'DELETE SALES';

  @override
  String get delete_sales_subtitle => 'Delete all history';

  @override
  String get delete_imported_db => 'Delete Imported DB';

  @override
  String get delete_all_imported_confirm => 'Delete all imported sales?';

  @override
  String get cancel_button => 'Cancel';

  @override
  String get delete_button => 'Delete';

  @override
  String get import_button => 'Import';

  @override
  String get sales_imported => 'sales imported';

  @override
  String get imported_db_deleted => 'DB deleted';

  @override
  String get employee_name => 'Employee';

  @override
  String get total_sales => 'Sales';

  @override
  String get total_sats_label => 'Total sats';

  @override
  String get employee_panel_title => 'Sales Panel';

  @override
  String get new_sale => 'NEW SALE';

  @override
  String get new_sale_subtitle => 'Start a new sale';

  @override
  String get pending_sales => 'PENDING SALES';

  @override
  String get pending_sales_subtitle => 'View pending sales';

  @override
  String get total_today => 'Total Today';

  @override
  String get sales_count => 'Sales';

  @override
  String get sale_title => 'New Sale';

  @override
  String get add_product => 'Add Product';

  @override
  String get product_name => 'Product';

  @override
  String get product_price => 'Price';

  @override
  String get quantity => 'Quantity';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get total => 'Total';

  @override
  String get clear_cart => 'Clear';

  @override
  String get process_sale => 'PROCESS SALE';

  @override
  String get sale_processing => 'PROCESSING...';

  @override
  String get no_products => 'No products';

  @override
  String get scan_product => 'Scan Product';

  @override
  String get manual_product => 'Add Manual';

  @override
  String get select_currency => 'Currency';

  @override
  String get currency_usd => 'USD - Dollar';

  @override
  String get currency_eur => 'EUR - Euro';

  @override
  String get currency_cup => 'CUP - Cuban Peso';

  @override
  String get currency_mlc => 'MLC - Convertible Peso';

  @override
  String get currency_gbp => 'GBP - British Pound';

  @override
  String get currency_cad => 'CAD - Canadian Dollar';

  @override
  String get currency_jpy => 'JPY - Japanese Yen';

  @override
  String get currency_aud => 'AUD - Australian Dollar';

  @override
  String get currency_chf => 'CHF - Swiss Franc';

  @override
  String get currency_sat => 'SAT - Satoshis';

  @override
  String get history_title => 'Sales History';

  @override
  String get filter_by_date => 'Filter by date';

  @override
  String get filter_by_employee => 'Filter by employee';

  @override
  String get no_sales => 'No sales';

  @override
  String get export_sales => 'Export';

  @override
  String get export_json => 'Export JSON';

  @override
  String get export_csv => 'Export CSV';

  @override
  String get sale_date => 'Date';

  @override
  String get sale_employee => 'Employee';

  @override
  String get sale_total => 'Total';

  @override
  String get sale_items => 'Products';

  @override
  String get settings_title => 'Settings';

  @override
  String get language_settings => 'Language';

  @override
  String get currency_settings => 'Currency';

  @override
  String get server_settings => 'Server';

  @override
  String get about_app => 'About';

  @override
  String get logout => 'Logout';

  @override
  String get about_title => 'About LaChispaPOS';

  @override
  String get about_version => 'Version';

  @override
  String get about_description =>
      'Lightning POS - An application to manage sales using Bitcoin through Lightning Network.';

  @override
  String get pending_sale_title => 'Pending Sale';

  @override
  String get pending_sale_message => 'You have a pending sale:';

  @override
  String get continue_sale => 'Continue';

  @override
  String get discard_sale => 'Discard';

  @override
  String get error_generic => 'Error';

  @override
  String get success => 'Success';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get confirm => 'Confirm';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Save';

  @override
  String get close => 'Close';

  @override
  String get select_language => 'Select language';

  @override
  String get invoice_key_qr_title => 'Invoice Key QR';

  @override
  String get no_invoice_key_configured => 'No Invoice Key configured';

  @override
  String get select_currencies_hint => 'Select the currencies you want to use';

  @override
  String get invoice_qr_title => 'Invoice QR';

  @override
  String get copy_button => 'Copy';

  @override
  String get step_connect_1 => 'Open LaChispa (owner\'s wallet)';

  @override
  String get step_connect_2 => 'Side menu > Invoice Key QR';

  @override
  String get step_connect_3 => 'QR will be displayed to scan';

  @override
  String get step_connect_4 => 'Scan the QR from POS app';

  @override
  String get steps_subtitle => 'The QR contains the URL and API Key together';

  @override
  String get features_title => 'FEATURES';

  @override
  String get roles_title => 'ROLES';

  @override
  String get how_to_connect => 'HOW TO CONNECT';

  @override
  String get steps_title => 'Steps to connect:';

  @override
  String get developed_with => 'Developed with';

  @override
  String get mlc_full_name => 'MLC - Convertible Peso';

  @override
  String get no_sales_to_export => 'No sales to export';

  @override
  String get sales_deleted => 'Sales deleted';

  @override
  String get employee => 'Employee';

  @override
  String get delete_sale_confirm => 'Delete this sale?';

  @override
  String get delete_sales_title => 'Delete Sales';

  @override
  String get import_sales_title => 'Import Sales';

  @override
  String get invalid_price => 'Invalid price';

  @override
  String get enter_product_and_price => 'Enter product and price';

  @override
  String get empty_cart => 'Empty cart';

  @override
  String get configure_api_in_settings => 'Configure API in Settings';

  @override
  String get error_creating_invoice => 'Error creating invoice';

  @override
  String get payment_received => 'Payment received!';

  @override
  String get payment_error => 'Payment error';

  @override
  String get waiting_for_payment => 'Waiting for Payment';

  @override
  String get cobrar => 'CHARGE';

  @override
  String get copiado => 'Copied';

  @override
  String get compartir => 'Share';

  @override
  String get pending_sale_confirm =>
      'You have a pending sale. Do you want to resume it?';

  @override
  String get retomar => 'Resume';

  @override
  String get discard_confirm => 'Delete all imported sales?';
}
