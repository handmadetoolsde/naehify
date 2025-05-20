import 'package:intl/intl.dart';
import 'package:sewingcalculator/Entity/FeeEntity.dart';


class FeeHelper {
  // Liste der verfügbaren Units
  static List<FeeEntity> fees = [
    FeeEntity(is_active: false, type: 'Versand & Versandmaterial', fix_fee: 0, percentage: 0, interactive: true, on_ek: true),
    FeeEntity(is_active: false, type: 'Lohn / Marge', fix_fee: 0, percentage: 0, interactive: true, on_ek: true),
    FeeEntity(is_active: false, type: 'Etsy', fix_fee: 0.18, percentage: 6.5, interactive: false, on_ek: false),
    FeeEntity(is_active: false, type: 'Etsy Pay', fix_fee: 0.30, percentage: 4, interactive: false, on_ek: false),
    FeeEntity(is_active: false, type: 'PayPal', fix_fee: 0.39, percentage: 2.99, interactive: false, on_ek: false),
  ];


  static String formatCurrency(double amount, bool withSymbol , {String locale = 'de_DE', String symbol = '€'}) {
    final formatter = NumberFormat.currency(locale: locale, symbol: (withSymbol) ? symbol: '');
    return formatter.format(amount);
  }

}