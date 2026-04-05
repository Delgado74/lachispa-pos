// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get welcome_title => 'La Chispa';

  @override
  String get welcome_subtitle => 'Lightning POS';

  @override
  String get get_started_button => '始める';

  @override
  String get login_title => 'LaChispaPOS';

  @override
  String get login_subtitle => 'Lightning POS';

  @override
  String get username_label => '名前';

  @override
  String get username_placeholder => '名前を入力';

  @override
  String get username_required_error => '名前を入力してください';

  @override
  String get select_role => '役割を選択';

  @override
  String get employee_role => '従業員';

  @override
  String get boss_role => '店主';

  @override
  String get login_button => 'ログイン';

  @override
  String get scan_qr_button => 'API Key QRをスキャン';

  @override
  String get verifying_api_key => 'API Keyを確認中...';

  @override
  String get api_key_error => 'エラー: API Keyを確認してください';

  @override
  String get invalid_qr => '無効なQR';

  @override
  String get api_key_not_found => 'API Keyが見つかりません';

  @override
  String get boss_panel_title => '店主パネル';

  @override
  String get import_sales => 'DBインポート';

  @override
  String get import_sales_subtitle => '従業員のJSONファイルをインポート';

  @override
  String get view_history => '履歴を見る';

  @override
  String get view_history_subtitle => 'インポートされたすべての売上';

  @override
  String get delete_sales => '売上を削除';

  @override
  String get delete_sales_subtitle => 'すべての履歴を削除';

  @override
  String get delete_imported_db => 'インポートDBを削除';

  @override
  String get delete_all_imported_confirm => 'すべてのインポートされた売上を削除しますか？';

  @override
  String get cancel_button => 'キャンセル';

  @override
  String get delete_button => '削除';

  @override
  String get import_button => 'インポート';

  @override
  String get sales_imported => '件の売上をインポート';

  @override
  String get imported_db_deleted => 'DBを削除しました';

  @override
  String get employee_name => '従業員';

  @override
  String get total_sales => '売上';

  @override
  String get total_sats_label => '合計sats';

  @override
  String get employee_panel_title => '売上パネル';

  @override
  String get new_sale => '新規売上';

  @override
  String get new_sale_subtitle => '新しい売上を開始';

  @override
  String get pending_sales => '保留中の売上';

  @override
  String get pending_sales_subtitle => '保留中の売上を表示';

  @override
  String get total_today => '本日の合計';

  @override
  String get sales_count => '件数';

  @override
  String get sale_title => '新規売上';

  @override
  String get add_product => '商品を追加';

  @override
  String get product_name => '商品';

  @override
  String get product_price => '価格';

  @override
  String get quantity => '数量';

  @override
  String get subtotal => '小計';

  @override
  String get total => '合計';

  @override
  String get clear_cart => 'クリア';

  @override
  String get process_sale => '売上を処理';

  @override
  String get sale_processing => '処理中...';

  @override
  String get no_products => '商品がありません';

  @override
  String get scan_product => '商品をスキャン';

  @override
  String get manual_product => '手動で追加';

  @override
  String get select_currency => '通貨';

  @override
  String get currency_usd => 'USD - 米ドル';

  @override
  String get currency_eur => 'EUR - ユーロ';

  @override
  String get currency_cup => 'CUP - キューバペソ';

  @override
  String get currency_mlc => 'MLC - 兌換通貨';

  @override
  String get mlc_full_name => 'MLC - 兌換通貨 (CBDC)';

  @override
  String get currency_gbp => 'GBP - 英ポンド';

  @override
  String get currency_cad => 'CAD - カナダドル';

  @override
  String get currency_jpy => 'JPY - 日本円';

  @override
  String get currency_aud => 'AUD -豪ドル';

  @override
  String get currency_chf => 'CHF - スイスフラン';

  @override
  String get currency_sat => 'SAT - サトシ';

  @override
  String get history_title => '売上履歴';

  @override
  String get filter_by_date => '日付でフィルター';

  @override
  String get filter_by_employee => '従業員でフィルター';

  @override
  String get no_sales => '売上なし';

  @override
  String get export_sales => 'エクスポート';

  @override
  String get export_json => 'JSONエクスポート';

  @override
  String get export_csv => 'CSVエクスポート';

  @override
  String get sale_date => '日付';

  @override
  String get sale_employee => '従業員';

  @override
  String get sale_total => '合計';

  @override
  String get sale_items => '商品';

  @override
  String get settings_title => '設定';

  @override
  String get language_settings => '言語';

  @override
  String get currency_settings => '通貨';

  @override
  String get server_settings => 'サーバー';

  @override
  String get about_app => 'アプリについて';

  @override
  String get logout => 'ログアウト';

  @override
  String get about_title => 'LaChispaPOSについて';

  @override
  String get about_version => 'バージョン';

  @override
  String get about_description =>
      'Lightning POS - BitcoinとLightning Networkを使用した売上管理アプリ';

  @override
  String get pending_sale_title => '保留中の売上';

  @override
  String get pending_sale_message => '保留中の売上があります：';

  @override
  String get continue_sale => '続ける';

  @override
  String get discard_sale => '破棄';

  @override
  String get error_generic => 'エラー';

  @override
  String get success => '成功';

  @override
  String get loading => '読み込み中...';

  @override
  String get retry => '再試行';

  @override
  String get confirm => '確認';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get ok => 'OK';

  @override
  String get save => '保存';

  @override
  String get close => '閉じる';

  @override
  String get select_language => '言語を選択';

  @override
  String get invoice_key_qr_title => '請求キーQRコード';

  @override
  String get no_invoice_key_configured => '請求キーが設定されていません';

  @override
  String get select_currencies_hint => '使用する通貨を選択してください';

  @override
  String get invoice_qr_title => '請求書QR';

  @override
  String get copy_button => 'コピー';

  @override
  String get step_connect_1 => 'LaChispaを開く（店主のウォレット）';

  @override
  String get step_connect_2 => 'サイドメニュー > 請求キーQRコード';

  @override
  String get step_connect_3 => 'スキャン用のQRが表示されます';

  @override
  String get step_connect_4 => 'POSアプリからQRをスキャン';

  @override
  String get steps_subtitle => 'QRにはURLとAPI Keyが含まれています';

  @override
  String get features_title => '機能';

  @override
  String get roles_title => '役割';

  @override
  String get how_to_connect => '接続方法';

  @override
  String get steps_title => '接続手順：';

  @override
  String get developed_with => '開発技術';

  @override
  String get no_sales_to_export => 'エクスポートする売上がありません';

  @override
  String get sales_deleted => '売上を削除しました';

  @override
  String get employee => '従業員';

  @override
  String get delete_sale_confirm => 'この売上を削除しますか？';

  @override
  String get delete_sales_title => '売上を削除';

  @override
  String get import_sales_title => '売上をインポート';

  @override
  String get invalid_price => '無効な価格';

  @override
  String get enter_product_and_price => '商品名と価格を入力';

  @override
  String get empty_cart => 'カートが空です';

  @override
  String get configure_api_in_settings => '設定でAPIを設定してください';

  @override
  String get error_creating_invoice => '請求書作成エラー';

  @override
  String get payment_received => '支払い完了！';

  @override
  String get payment_error => '支払いエラー';

  @override
  String get waiting_for_payment => '支払い待ち';

  @override
  String get cobrar => '請求';

  @override
  String get copiado => 'コピーしました';

  @override
  String get compartir => '共有';

  @override
  String get pending_sale_confirm => '保留中の売上があります。続けますか？';

  @override
  String get retomar => '続ける';

  @override
  String get discard_confirm => 'すべてのインポートされた売上を削除しますか？';
}
