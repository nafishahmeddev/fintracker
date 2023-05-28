import 'package:intl/intl.dart';

class CurrencyHelper {
  static String format(
      double amount, {
        String? symbol = "₹",
        String? name = "INR",
        String? locale = "en_IN",
      }) {
    return NumberFormat('$symbol##,##,##,###.####', locale).format(amount);
  }
}

