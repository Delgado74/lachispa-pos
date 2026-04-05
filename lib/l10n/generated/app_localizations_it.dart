// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get welcome_title => 'La Chispa';

  @override
  String get welcome_subtitle => 'Lightning POS';

  @override
  String get get_started_button => 'INIZIA';

  @override
  String get login_title => 'LaChispaPOS';

  @override
  String get login_subtitle => 'Lightning POS';

  @override
  String get username_label => 'Nome';

  @override
  String get username_placeholder => 'Inserisci il tuo nome';

  @override
  String get username_required_error => 'Inserisci il tuo nome';

  @override
  String get select_role => 'Seleziona ruolo';

  @override
  String get employee_role => 'Dipendente';

  @override
  String get boss_role => 'Capo';

  @override
  String get login_button => 'ACCEDI';

  @override
  String get scan_qr_button => 'Scansiona QR chiave API';

  @override
  String get verifying_api_key => 'Verifica chiave API...';

  @override
  String get api_key_error => 'Errore: Verifica chiave API';

  @override
  String get invalid_qr => 'QR non valido';

  @override
  String get api_key_not_found => 'Chiave API non trovata';

  @override
  String get boss_panel_title => 'Pannello Capo';

  @override
  String get import_sales => 'IMPORTA DB';

  @override
  String get import_sales_subtitle => 'Importa file JSON dal dipendente';

  @override
  String get view_history => 'VISUALIZZA CRONOLOGIA';

  @override
  String get view_history_subtitle => 'Tutte le vendite importate';

  @override
  String get delete_sales => 'ELIMINA VENDITE';

  @override
  String get delete_sales_subtitle => 'Elimina tutta la cronologia';

  @override
  String get delete_imported_db => 'Elimina DB importato';

  @override
  String get delete_all_imported_confirm =>
      'Eliminare tutte le vendite importate?';

  @override
  String get cancel_button => 'Annulla';

  @override
  String get delete_button => 'Elimina';

  @override
  String get import_button => 'Importa';

  @override
  String get sales_imported => 'vendite importate';

  @override
  String get imported_db_deleted => 'DB eliminato';

  @override
  String get employee_name => 'Dipendente';

  @override
  String get total_sales => 'Vendite';

  @override
  String get total_sats_label => 'Totale sats';

  @override
  String get employee_panel_title => 'Pannello vendite';

  @override
  String get new_sale => 'NUOVA VENDITA';

  @override
  String get new_sale_subtitle => 'Avvia una nuova vendita';

  @override
  String get pending_sales => 'VENDITE IN ATTESA';

  @override
  String get pending_sales_subtitle => 'Visualizza vendite in attesa';

  @override
  String get total_today => 'Totale oggi';

  @override
  String get sales_count => 'Vendite';

  @override
  String get sale_title => 'Nuova vendita';

  @override
  String get add_product => 'Aggiungi prodotto';

  @override
  String get product_name => 'Prodotto';

  @override
  String get product_price => 'Prezzo';

  @override
  String get quantity => 'Quantità';

  @override
  String get subtotal => 'Subtotale';

  @override
  String get total => 'Totale';

  @override
  String get clear_cart => 'Svuota';

  @override
  String get process_sale => 'ELABORA VENDITA';

  @override
  String get sale_processing => 'ELABORAZIONE...';

  @override
  String get no_products => 'Nessun prodotto';

  @override
  String get scan_product => 'Scansiona prodotto';

  @override
  String get manual_product => 'Aggiungi manuale';

  @override
  String get select_currency => 'Valuta';

  @override
  String get currency_usd => 'USD - Dollaro';

  @override
  String get currency_eur => 'EUR - Euro';

  @override
  String get currency_cup => 'CUP - Peso cubano';

  @override
  String get currency_mlc => 'MLC - Valuta Convertibile';

  @override
  String get mlc_full_name => 'MLC - Valuta Convertibile (CBDC)';

  @override
  String get currency_gbp => 'GBP - Sterlina britannica';

  @override
  String get currency_cad => 'CAD - Dollaro canadese';

  @override
  String get currency_jpy => 'JPY - Yen giapponese';

  @override
  String get currency_aud => 'AUD - Dollaro australiano';

  @override
  String get currency_chf => 'CHF - Franco svizzero';

  @override
  String get currency_sat => 'SAT - Satoshis';

  @override
  String get history_title => 'Cronologia vendite';

  @override
  String get filter_by_date => 'Filtra per data';

  @override
  String get filter_by_employee => 'Filtra per dipendente';

  @override
  String get no_sales => 'Nessuna vendita';

  @override
  String get export_sales => 'Esporta';

  @override
  String get export_json => 'Esporta JSON';

  @override
  String get export_csv => 'Esporta CSV';

  @override
  String get sale_date => 'Data';

  @override
  String get sale_employee => 'Dipendente';

  @override
  String get sale_total => 'Totale';

  @override
  String get sale_items => 'Prodotti';

  @override
  String get settings_title => 'Impostazioni';

  @override
  String get language_settings => 'Lingua';

  @override
  String get currency_settings => 'Valute';

  @override
  String get server_settings => 'Server';

  @override
  String get about_app => 'Informazioni';

  @override
  String get logout => 'Disconnetti';

  @override
  String get about_title => 'Informazioni su LaChispaPOS';

  @override
  String get about_version => 'Versione';

  @override
  String get about_description =>
      'Lightning POS - Un\'applicazione per gestire le vendite utilizzando Bitcoin tramite Lightning Network.';

  @override
  String get pending_sale_title => 'Vendita in attesa';

  @override
  String get pending_sale_message => 'Hai una vendita in attesa:';

  @override
  String get continue_sale => 'Continua';

  @override
  String get discard_sale => 'Scarta';

  @override
  String get error_generic => 'Errore';

  @override
  String get success => 'Successo';

  @override
  String get loading => 'Caricamento...';

  @override
  String get retry => 'Riprova';

  @override
  String get confirm => 'Conferma';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Salva';

  @override
  String get close => 'Chiudi';

  @override
  String get select_language => 'Seleziona lingua';

  @override
  String get invoice_key_qr_title => 'QR Chiave Fattura';

  @override
  String get no_invoice_key_configured => 'Nessuna chiave fattura configurata';

  @override
  String get select_currencies_hint => 'Seleziona le valute che desideri usare';

  @override
  String get invoice_qr_title => 'QR Fattura';

  @override
  String get copy_button => 'Copia';

  @override
  String get step_connect_1 => 'Apri LaChispa (wallet del proprietario)';

  @override
  String get step_connect_2 => 'Menu laterale > QR Chiave Fattura';

  @override
  String get step_connect_3 => 'Il QR verrà visualizzato per la scansione';

  @override
  String get step_connect_4 => 'Scansiona il QR dall\'app POS';

  @override
  String get steps_subtitle => 'Il QR contiene l\'URL e la chiave API insieme';

  @override
  String get features_title => 'FUNZIONI';

  @override
  String get roles_title => 'RUOLI';

  @override
  String get how_to_connect => 'COME COLLEGARE';

  @override
  String get steps_title => 'Passaggi per collegare:';

  @override
  String get developed_with => 'Sviluppato con';

  @override
  String get no_sales_to_export => 'Nessuna vendita da esportare';

  @override
  String get sales_deleted => 'Vendite eliminate';

  @override
  String get employee => 'Dipendente';

  @override
  String get delete_sale_confirm => 'Eliminare questa vendita?';

  @override
  String get delete_sales_title => 'Elimina Vendite';

  @override
  String get import_sales_title => 'Importa Vendite';

  @override
  String get invalid_price => 'Prezzo non valido';

  @override
  String get enter_product_and_price => 'Inserisci prodotto e prezzo';

  @override
  String get empty_cart => 'Carrello vuoto';

  @override
  String get configure_api_in_settings => 'Configura API in Impostazioni';

  @override
  String get error_creating_invoice => 'Errore creazione fattura';

  @override
  String get payment_received => 'Pagamento ricevuto!';

  @override
  String get payment_error => 'Errore pagamento';

  @override
  String get waiting_for_payment => 'In attesa di pagamento';

  @override
  String get cobrar => 'ADDEBITARE';

  @override
  String get copiado => 'Copiato';

  @override
  String get compartir => 'Condividere';

  @override
  String get pending_sale_confirm =>
      'Hai una vendita in attesa. Vuoi riprenderla?';

  @override
  String get retomar => 'Riprendere';

  @override
  String get discard_confirm => 'Eliminare tutte le vendite importate?';
}
