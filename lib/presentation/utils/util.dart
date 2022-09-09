import 'package:intl/intl.dart';

class Util {
  static String convertToCurrency(double value) {
    return NumberFormat("#,###.00").format(value);
  }
}
