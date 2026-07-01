import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _format = NumberFormat.currency(
    locale: 'en_NG',
    symbol: 'NGN ',
    decimalDigits: 2,
  );

  /// Converts kobo (integer) to a formatted Naira string, e.g. "NGN 12,500.00".
  static String fromKobo(int amountKobo) {
    final naira = amountKobo / 100;
    return _format.format(naira);
  }
}
