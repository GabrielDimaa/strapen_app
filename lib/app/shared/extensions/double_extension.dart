import 'package:intl/intl.dart';

extension DoubleExtension on double? {
  String formatReal() {
    NumberFormat formatter = NumberFormat.simpleCurrency(locale: "pt_BR");
    return formatter.format(this);
  }
}