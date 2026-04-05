// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get welcome_title => 'La Chispa';

  @override
  String get welcome_subtitle => 'Lightning POS';

  @override
  String get get_started_button => 'COMMENCER';

  @override
  String get login_title => 'LaChispaPOS';

  @override
  String get login_subtitle => 'Lightning POS';

  @override
  String get username_label => 'Nom';

  @override
  String get username_placeholder => 'Entrez votre nom';

  @override
  String get username_required_error => 'Entrez votre nom';

  @override
  String get select_role => 'Sélectionner le rôle';

  @override
  String get employee_role => 'Employé';

  @override
  String get boss_role => 'Patron';

  @override
  String get login_button => 'CONNEXION';

  @override
  String get scan_qr_button => 'Scanner QR clé API';

  @override
  String get verifying_api_key => 'Vérification de la clé API...';

  @override
  String get api_key_error => 'Erreur: Vérifiez la clé API';

  @override
  String get invalid_qr => 'QR invalide';

  @override
  String get api_key_not_found => 'Clé API non trouvée';

  @override
  String get boss_panel_title => 'Panneau Patron';

  @override
  String get import_sales => 'IMPORTER BDD';

  @override
  String get import_sales_subtitle => 'Importer fichier JSON de l\'employé';

  @override
  String get view_history => 'VOIR HISTORIQUE';

  @override
  String get view_history_subtitle => 'Toutes les ventes importées';

  @override
  String get delete_sales => 'SUPPRIMER VENTES';

  @override
  String get delete_sales_subtitle => 'Supprimer tout l\'historique';

  @override
  String get delete_imported_db => 'Supprimer BDD importée';

  @override
  String get delete_all_imported_confirm =>
      'Supprimer toutes les ventes importées?';

  @override
  String get cancel_button => 'Annuler';

  @override
  String get delete_button => 'Supprimer';

  @override
  String get import_button => 'Importer';

  @override
  String get sales_imported => 'ventes importées';

  @override
  String get imported_db_deleted => 'BDD supprimée';

  @override
  String get employee_name => 'Employé';

  @override
  String get total_sales => 'Ventes';

  @override
  String get total_sats_label => 'Total sats';

  @override
  String get employee_panel_title => 'Panneau de ventes';

  @override
  String get new_sale => 'NOUVELLE VENTE';

  @override
  String get new_sale_subtitle => 'Démarrer une nouvelle vente';

  @override
  String get pending_sales => 'VENTES EN ATTENTE';

  @override
  String get pending_sales_subtitle => 'Voir les ventes en attente';

  @override
  String get total_today => 'Total aujourd\'hui';

  @override
  String get sales_count => 'Ventes';

  @override
  String get sale_title => 'Nouvelle vente';

  @override
  String get add_product => 'Ajouter un produit';

  @override
  String get product_name => 'Produit';

  @override
  String get product_price => 'Prix';

  @override
  String get quantity => 'Quantité';

  @override
  String get subtotal => 'Sous-total';

  @override
  String get total => 'Total';

  @override
  String get clear_cart => 'Effacer';

  @override
  String get process_sale => 'TRAITER LA VENTE';

  @override
  String get sale_processing => 'TRAITEMENT...';

  @override
  String get no_products => 'Aucun produit';

  @override
  String get scan_product => 'Scanner produit';

  @override
  String get manual_product => 'Ajouter manuel';

  @override
  String get select_currency => 'Devise';

  @override
  String get currency_usd => 'USD - Dollar';

  @override
  String get currency_eur => 'EUR - Euro';

  @override
  String get currency_cup => 'CUP - Peso cubain';

  @override
  String get currency_mlc => 'MLC - Peso convertible';

  @override
  String get currency_gbp => 'GBP - Livre sterling';

  @override
  String get currency_cad => 'CAD - Dollar canadien';

  @override
  String get currency_jpy => 'JPY - Yen japonais';

  @override
  String get currency_aud => 'AUD - Dollar australien';

  @override
  String get currency_chf => 'CHF - Franc suisse';

  @override
  String get currency_sat => 'SAT - Satoshis';

  @override
  String get history_title => 'Historique des ventes';

  @override
  String get filter_by_date => 'Filtrer par date';

  @override
  String get filter_by_employee => 'Filtrer par employé';

  @override
  String get no_sales => 'Aucune vente';

  @override
  String get export_sales => 'Exporter';

  @override
  String get export_json => 'Exporter JSON';

  @override
  String get export_csv => 'Exporter CSV';

  @override
  String get sale_date => 'Date';

  @override
  String get sale_employee => 'Employé';

  @override
  String get sale_total => 'Total';

  @override
  String get sale_items => 'Produits';

  @override
  String get settings_title => 'Paramètres';

  @override
  String get language_settings => 'Langue';

  @override
  String get currency_settings => 'Devises';

  @override
  String get server_settings => 'Serveur';

  @override
  String get about_app => 'À propos';

  @override
  String get logout => 'Déconnexion';

  @override
  String get about_title => 'À propos de LaChispaPOS';

  @override
  String get about_version => 'Version';

  @override
  String get about_description =>
      'Lightning POS - Une application pour gérer les ventes en utilisant Bitcoin via le Lightning Network.';

  @override
  String get pending_sale_title => 'Vente en attente';

  @override
  String get pending_sale_message => 'Vous avez une vente en attente:';

  @override
  String get continue_sale => 'Continuer';

  @override
  String get discard_sale => 'Abandonner';

  @override
  String get error_generic => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get loading => 'Chargement...';

  @override
  String get retry => 'Réessayer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Sauvegarder';

  @override
  String get close => 'Fermer';

  @override
  String get select_language => 'Sélectionner la langue';

  @override
  String get invoice_key_qr_title => 'QR Clé de Facturation';

  @override
  String get no_invoice_key_configured =>
      'Pas de clé de facturation configurée';

  @override
  String get select_currencies_hint =>
      'Sélectionnez les devises que vous souhaitez utiliser';

  @override
  String get invoice_qr_title => 'QR Facture';

  @override
  String get copy_button => 'Copier';

  @override
  String get step_connect_1 => 'Ouvrez LaChispa (portefeuille du owner)';

  @override
  String get step_connect_2 => 'Menu latéral > QR Clé de Facturation';

  @override
  String get step_connect_3 => 'Le QR sera affiché pour scanner';

  @override
  String get step_connect_4 => 'Scannez le QR depuis l\'app POS';

  @override
  String get steps_subtitle => 'Le QR contient l\'URL et la clé API ensemble';

  @override
  String get features_title => 'FONCTIONS';

  @override
  String get roles_title => 'ROLES';

  @override
  String get how_to_connect => 'COMMENT CONNECTER';

  @override
  String get steps_title => 'Étapes pour connecter:';

  @override
  String get developed_with => 'Développé avec';

  @override
  String get mlc_full_name => 'MLC - Peso convertible';

  @override
  String get no_sales_to_export => 'Aucune vente à exporter';

  @override
  String get sales_deleted => 'Ventes supprimées';

  @override
  String get employee => 'Employé';

  @override
  String get delete_sale_confirm => 'Supprimer cette vente?';

  @override
  String get delete_sales_title => 'Supprimer Ventes';

  @override
  String get import_sales_title => 'Importer Ventes';

  @override
  String get invalid_price => 'Prix invalide';

  @override
  String get enter_product_and_price => 'Entrez produit et prix';

  @override
  String get empty_cart => 'Panier vide';

  @override
  String get configure_api_in_settings => 'Configurez l\'API dans Paramètres';

  @override
  String get error_creating_invoice => 'Erreur création invoice';

  @override
  String get payment_received => 'Paiement reçu!';

  @override
  String get payment_error => 'Erreur de paiement';

  @override
  String get waiting_for_payment => 'En attente de paiement';

  @override
  String get cobrar => 'PERCEVOIR';

  @override
  String get copiado => 'Copié';

  @override
  String get compartir => 'Partager';

  @override
  String get pending_sale_confirm =>
      'Vous avez une vente en attente. Voulez-vous la reprendre?';

  @override
  String get retomar => 'Reprendre';

  @override
  String get discard_confirm => 'Supprimer toutes les ventes importées?';
}
