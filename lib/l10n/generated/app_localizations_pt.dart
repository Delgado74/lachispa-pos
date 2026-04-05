// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get welcome_title => 'La Chispa';

  @override
  String get welcome_subtitle => 'Lightning POS';

  @override
  String get get_started_button => 'COMEÇAR';

  @override
  String get login_title => 'LaChispaPOS';

  @override
  String get login_subtitle => 'Lightning POS';

  @override
  String get username_label => 'Nome';

  @override
  String get username_placeholder => 'Digite seu nome';

  @override
  String get username_required_error => 'Digite seu nome';

  @override
  String get select_role => 'Selecionar Função';

  @override
  String get employee_role => 'Funcionário';

  @override
  String get boss_role => 'Chefe';

  @override
  String get login_button => 'ENTRAR';

  @override
  String get scan_qr_button => 'Escanear QR API Key';

  @override
  String get verifying_api_key => 'Verificando API Key...';

  @override
  String get api_key_error => 'Erro: Verifique API Key';

  @override
  String get invalid_qr => 'QR inválido';

  @override
  String get api_key_not_found => 'API Key não encontrada';

  @override
  String get boss_panel_title => 'Painel Chefe';

  @override
  String get import_sales => 'IMPORTAR BD';

  @override
  String get import_sales_subtitle => 'Importar arquivo JSON do funcionário';

  @override
  String get view_history => 'VER HISTÓRICO';

  @override
  String get view_history_subtitle => 'Todas as vendas importadas';

  @override
  String get delete_sales => 'EXCLUIR BD';

  @override
  String get delete_sales_subtitle => 'Excluir vendas importadas';

  @override
  String get delete_imported_db => 'Excluir BD Importado';

  @override
  String get delete_all_imported_confirm =>
      'Excluir todas as vendas importadas?';

  @override
  String get cancel_button => 'Cancelar';

  @override
  String get delete_button => 'Excluir';

  @override
  String get import_button => 'Importar';

  @override
  String get sales_imported => 'vendas importadas';

  @override
  String get imported_db_deleted => 'BD excluído';

  @override
  String get employee_name => 'Funcionário';

  @override
  String get total_sales => 'Vendas';

  @override
  String get total_sats_label => 'Total sats';

  @override
  String get employee_panel_title => 'Painel de Vendas';

  @override
  String get new_sale => 'NOVA VENDA';

  @override
  String get new_sale_subtitle => 'Iniciar uma nova venda';

  @override
  String get pending_sales => 'VENDAS PENDENTES';

  @override
  String get pending_sales_subtitle => 'Ver vendas pendentes';

  @override
  String get total_today => 'Total Hoje';

  @override
  String get sales_count => 'Vendas';

  @override
  String get sale_title => 'Nova Venda';

  @override
  String get add_product => 'Adicionar Produto';

  @override
  String get product_name => 'Produto';

  @override
  String get product_price => 'Preço';

  @override
  String get quantity => 'Quantidade';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get total => 'Total';

  @override
  String get clear_cart => 'Limpar';

  @override
  String get process_sale => 'PROCESSAR VENDA';

  @override
  String get sale_processing => 'PROCESSANDO...';

  @override
  String get no_products => 'Sem produtos';

  @override
  String get scan_product => 'Escanear Produto';

  @override
  String get manual_product => 'Adicionar Manual';

  @override
  String get select_currency => 'Moeda';

  @override
  String get currency_usd => 'USD - Dólar';

  @override
  String get currency_eur => 'EUR - Euro';

  @override
  String get currency_cup => 'CUP - Peso Cubano';

  @override
  String get currency_mlc => 'MLC - Peso Conversível';

  @override
  String get currency_gbp => 'GBP - Libra Esterlina';

  @override
  String get currency_cad => 'CAD - Dólar Canadense';

  @override
  String get currency_jpy => 'JPY - Iene Japonês';

  @override
  String get currency_aud => 'AUD - Dólar Australiano';

  @override
  String get currency_chf => 'CHF - Franco Suíço';

  @override
  String get currency_sat => 'SAT - Satoshis';

  @override
  String get history_title => 'Histórico de Vendas';

  @override
  String get filter_by_date => 'Filtrar por data';

  @override
  String get filter_by_employee => 'Filtrar por funcionário';

  @override
  String get no_sales => 'Sem vendas';

  @override
  String get export_sales => 'Exportar';

  @override
  String get export_json => 'Exportar JSON';

  @override
  String get export_csv => 'Exportar CSV';

  @override
  String get sale_date => 'Data';

  @override
  String get sale_employee => 'Funcionário';

  @override
  String get sale_total => 'Total';

  @override
  String get sale_items => 'Produtos';

  @override
  String get settings_title => 'Configurações';

  @override
  String get language_settings => 'Idioma';

  @override
  String get currency_settings => 'Moedas';

  @override
  String get server_settings => 'Servidor';

  @override
  String get about_app => 'Sobre';

  @override
  String get logout => 'Sair';

  @override
  String get about_title => 'Sobre LaChispaPOS';

  @override
  String get about_version => 'Versão';

  @override
  String get about_description =>
      'Lightning POS - Um aplicativo para gerenciar vendas usando Bitcoin através da Lightning Network.';

  @override
  String get pending_sale_title => 'Venda Pendente';

  @override
  String get pending_sale_message => 'Você tem uma venda pendente:';

  @override
  String get continue_sale => 'Continuar';

  @override
  String get discard_sale => 'Descartar';

  @override
  String get error_generic => 'Erro';

  @override
  String get success => 'Sucesso';

  @override
  String get loading => 'Carregando...';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get confirm => 'Confirmar';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Salvar';

  @override
  String get close => 'Fechar';

  @override
  String get select_language => 'Selecionar idioma';

  @override
  String get invoice_key_qr_title => 'QR Chave de Fatura';

  @override
  String get no_invoice_key_configured => 'Nenhuma Invoice Key configurada';

  @override
  String get select_currencies_hint => 'Selecione as moedas que deseja usar';

  @override
  String get invoice_qr_title => 'QR Fatura';

  @override
  String get copy_button => 'Copiar';

  @override
  String get step_connect_1 => 'Abra LaChispa (carteira do owner)';

  @override
  String get step_connect_2 => 'Menu lateral > QR Chave de Fatura';

  @override
  String get step_connect_3 => 'O QR será exibido para escanear';

  @override
  String get step_connect_4 => 'Escaneie o QR do app POS';

  @override
  String get steps_subtitle => 'O QR contém a URL e a API Key juntos';

  @override
  String get features_title => 'FUNÇÕES';

  @override
  String get roles_title => 'FUNÇÕES';

  @override
  String get how_to_connect => 'COMO CONECTAR';

  @override
  String get steps_title => 'Passos para conectar:';

  @override
  String get developed_with => 'Desenvolvido com';

  @override
  String get mlc_full_name => 'MLC - Peso Conversível';

  @override
  String get no_sales_to_export => 'Sem vendas para exportar';

  @override
  String get sales_deleted => 'Vendas excluídas';

  @override
  String get employee => 'Funcionário';

  @override
  String get delete_sale_confirm => 'Excluir esta venda?';

  @override
  String get delete_sales_title => 'Excluir Vendas';

  @override
  String get import_sales_title => 'Importar Vendas';

  @override
  String get invalid_price => 'Preço inválido';

  @override
  String get enter_product_and_price => 'Informe produto e preço';

  @override
  String get empty_cart => 'Carrinho vazio';

  @override
  String get configure_api_in_settings => 'Configure API em Configurações';

  @override
  String get error_creating_invoice => 'Erro ao criar invoice';

  @override
  String get payment_received => 'Pagamento recebido!';

  @override
  String get payment_error => 'Erro no pagamento';

  @override
  String get waiting_for_payment => 'Aguardando Pagamento';

  @override
  String get cobrar => 'COBRAR';

  @override
  String get copiado => 'Copiado';

  @override
  String get compartir => 'Compartilhar';

  @override
  String get pending_sale_confirm =>
      'Você tem uma venda pendente. Deseja retomá-la?';

  @override
  String get retomar => 'Retomar';

  @override
  String get discard_confirm => 'Excluir todas as vendas importadas?';
}
