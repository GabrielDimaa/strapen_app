import 'package:intl/intl.dart';

extension StringExtension on String? {
  bool isNullOrEmpty() => this == null || this!.trim().isEmpty;
  bool notIsNullOrEmpty() => !this.isNullOrEmpty();

  String extrairNum() {
    if (this.isNullOrEmpty()) {
      return '';
    }

    final iReg = RegExp(r'(\d+)');
    return iReg.allMatches(this!).map((m) => m.group(0)).join('');
  }

  DateTime parseToDate() {
    return DateFormat("yyyy-MM-dd").parse(this!);
  }

  DateTime parseToDateTime() {
    return DateFormat("yyyy-MM-ddTHH:mm:ss").parse(this!);
  }
}