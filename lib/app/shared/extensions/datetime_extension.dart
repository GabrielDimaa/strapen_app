import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

extension DateTimeExtension on DateTime {
  String get formatedWithHour {
    initializeDateFormatting('pt_BR', null);

    return DateFormat.yMd('pt_BR').add_Hm().format(this);
  }

  String get formated {
    initializeDateFormatting('pt_BR', null);

    return DateFormat.yMd('pt_BR').format(this);
  }
}