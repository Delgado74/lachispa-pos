// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get welcome_title => 'La Chispa';

  @override
  String get welcome_subtitle => 'Lightning POS';

  @override
  String get get_started_button => 'НАЧАТЬ';

  @override
  String get login_title => 'LaChispaPOS';

  @override
  String get login_subtitle => 'Lightning POS';

  @override
  String get username_label => 'Имя';

  @override
  String get username_placeholder => 'Введите ваше имя';

  @override
  String get username_required_error => 'Введите ваше имя';

  @override
  String get select_role => 'Выбрать роль';

  @override
  String get employee_role => 'Сотрудник';

  @override
  String get boss_role => 'Начальник';

  @override
  String get login_button => 'ВХОД';

  @override
  String get scan_qr_button => 'Сканировать QR ключ API';

  @override
  String get verifying_api_key => 'Проверка ключа API...';

  @override
  String get api_key_error => 'Ошибка: Проверьте ключ API';

  @override
  String get invalid_qr => 'Неверный QR';

  @override
  String get api_key_not_found => 'Ключ API не найден';

  @override
  String get boss_panel_title => 'Панель начальника';

  @override
  String get import_sales => 'ИМПОРТ БД';

  @override
  String get import_sales_subtitle => 'Импорт JSON файла от сотрудника';

  @override
  String get view_history => 'ИСТОРИЯ';

  @override
  String get view_history_subtitle => 'Все импортированные продажи';

  @override
  String get delete_sales => 'УДАЛИТЬ ПРОДАЖИ';

  @override
  String get delete_sales_subtitle => 'Удалить всю историю';

  @override
  String get delete_imported_db => 'Удалить импортированную БД';

  @override
  String get delete_all_imported_confirm =>
      'Удалить все импортированные продажи?';

  @override
  String get cancel_button => 'Отмена';

  @override
  String get delete_button => 'Удалить';

  @override
  String get import_button => 'Импорт';

  @override
  String get sales_imported => 'продаж импортировано';

  @override
  String get imported_db_deleted => 'БД удалена';

  @override
  String get employee_name => 'Сотрудник';

  @override
  String get total_sales => 'Продажи';

  @override
  String get total_sats_label => 'Всего сат';

  @override
  String get employee_panel_title => 'Панель продаж';

  @override
  String get new_sale => 'НОВАЯ ПРОДАЖА';

  @override
  String get new_sale_subtitle => 'Начать новую продажу';

  @override
  String get pending_sales => 'ОЖИДАЮЩИЕ ПРОДАЖИ';

  @override
  String get pending_sales_subtitle => 'Просмотр ожидающих продаж';

  @override
  String get total_today => 'Итого сегодня';

  @override
  String get sales_count => 'Продажи';

  @override
  String get sale_title => 'Новая продажа';

  @override
  String get add_product => 'Добавить товар';

  @override
  String get product_name => 'Товар';

  @override
  String get product_price => 'Цена';

  @override
  String get quantity => 'Количество';

  @override
  String get subtotal => 'Подытог';

  @override
  String get total => 'Итого';

  @override
  String get clear_cart => 'Очистить';

  @override
  String get process_sale => 'ОБРАБОТАТЬ ПРОДАЖУ';

  @override
  String get sale_processing => 'ОБРАБОТКА...';

  @override
  String get no_products => 'Нет товаров';

  @override
  String get scan_product => 'Сканировать товар';

  @override
  String get manual_product => 'Добавить вручную';

  @override
  String get select_currency => 'Валюта';

  @override
  String get currency_usd => 'USD - Доллар';

  @override
  String get currency_eur => 'EUR - Евро';

  @override
  String get currency_cup => 'CUP - Кубинское песо';

  @override
  String get currency_mlc => 'MLC - Конвертируемая валюта';

  @override
  String get mlc_full_name => 'MLC - Конвертируемая валюта (ЦБВЦ)';

  @override
  String get currency_gbp => 'GBP - Британский фунт';

  @override
  String get currency_cad => 'CAD - Канадский доллар';

  @override
  String get currency_jpy => 'JPY - Японская иена';

  @override
  String get currency_aud => 'AUD - Австралийский доллар';

  @override
  String get currency_chf => 'CHF - Швейцарский франк';

  @override
  String get currency_sat => 'SAT - Сатоши';

  @override
  String get history_title => 'История продаж';

  @override
  String get filter_by_date => 'Фильтр по дате';

  @override
  String get filter_by_employee => 'Фильтр по сотруднику';

  @override
  String get no_sales => 'Нет продаж';

  @override
  String get export_sales => 'Экспорт';

  @override
  String get export_json => 'Экспорт JSON';

  @override
  String get export_csv => 'Экспорт CSV';

  @override
  String get sale_date => 'Дата';

  @override
  String get sale_employee => 'Сотрудник';

  @override
  String get sale_total => 'Итого';

  @override
  String get sale_items => 'Товары';

  @override
  String get settings_title => 'Настройки';

  @override
  String get language_settings => 'Язык';

  @override
  String get currency_settings => 'Валюты';

  @override
  String get server_settings => 'Сервер';

  @override
  String get about_app => 'О приложении';

  @override
  String get logout => 'Выйти';

  @override
  String get about_title => 'О LaChispaPOS';

  @override
  String get about_version => 'Версия';

  @override
  String get about_description =>
      'Lightning POS - Приложение для управления продажами с использованием Bitcoin через Lightning Network.';

  @override
  String get pending_sale_title => 'Ожидающая продажа';

  @override
  String get pending_sale_message => 'У вас есть ожидающая продажа:';

  @override
  String get continue_sale => 'Продолжить';

  @override
  String get discard_sale => 'Отменить';

  @override
  String get error_generic => 'Ошибка';

  @override
  String get success => 'Успешно';

  @override
  String get loading => 'Загрузка...';

  @override
  String get retry => 'Повторить';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get ok => 'ОК';

  @override
  String get save => 'Сохранить';

  @override
  String get close => 'Закрыть';

  @override
  String get select_language => 'Выбрать язык';

  @override
  String get invoice_key_qr_title => 'QR Ключ Счета';

  @override
  String get no_invoice_key_configured => 'Ключ счета не настроен';

  @override
  String get select_currencies_hint => 'Выберите валюты для использования';

  @override
  String get invoice_qr_title => 'QR Счета';

  @override
  String get copy_button => 'Копировать';

  @override
  String get step_connect_1 => 'Откройте LaChispa (кошелек владельца)';

  @override
  String get step_connect_2 => 'Боковое меню > QR Ключ Счета';

  @override
  String get step_connect_3 => 'QR будет отображен для сканирования';

  @override
  String get step_connect_4 => 'Сканируйте QR из приложения POS';

  @override
  String get steps_subtitle => 'QR содержит URL и ключ API вместе';

  @override
  String get features_title => 'ФУНКЦИИ';

  @override
  String get roles_title => 'РОЛИ';

  @override
  String get how_to_connect => 'КАК ПОДКЛЮЧИТЬ';

  @override
  String get steps_title => 'Шаги для подключения:';

  @override
  String get developed_with => 'Разработано с';

  @override
  String get no_sales_to_export => 'Нет продаж для экспорта';

  @override
  String get sales_deleted => 'Продажи удалены';

  @override
  String get employee => 'Сотрудник';

  @override
  String get delete_sale_confirm => 'Удалить эту продажу?';

  @override
  String get delete_sales_title => 'Удалить продажи';

  @override
  String get import_sales_title => 'Импорт продаж';

  @override
  String get invalid_price => 'Неверная цена';

  @override
  String get enter_product_and_price => 'Введите товар и цену';

  @override
  String get empty_cart => 'Корзина пуста';

  @override
  String get configure_api_in_settings => 'Настройте API в Настройках';

  @override
  String get error_creating_invoice => 'Ошибка создания счета';

  @override
  String get payment_received => 'Платеж получен!';

  @override
  String get payment_error => 'Ошибка платежа';

  @override
  String get waiting_for_payment => 'Ожидание платежа';

  @override
  String get cobrar => 'ОПЛАТА';

  @override
  String get copiado => 'Скопировано';

  @override
  String get compartir => 'Поделиться';

  @override
  String get pending_sale_confirm =>
      'У вас есть ожидающая продажа. Хотите ее продолжить?';

  @override
  String get retomar => 'Продолжить';

  @override
  String get discard_confirm => 'Удалить все импортированные продажи?';

  @override
  String get pay_with_nfc => 'Pagar con NFC';

  @override
  String get nfc_not_available => 'NFC no disponible';

  @override
  String get nfc_ready => 'Acerque el dispositivo al cliente';

  @override
  String get nfc_payment_cancelled => 'Pago NFC cancelado';

  @override
  String get nfc_error => 'Error NFC';

  @override
  String get tap_to_pay => 'Tocar para pagar';

  @override
  String get nfc_reading => 'Leyendo NFC...';

  @override
  String get lnurl_error => 'Error del servidor';
}
