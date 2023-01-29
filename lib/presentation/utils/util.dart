import 'package:intl/intl.dart';

class Util {
  static String convertToCurrency(double? value) {
    return value != null ? NumberFormat("#,##0.00").format(value) : "0.00";
  }
}
