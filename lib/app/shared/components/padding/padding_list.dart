import 'package:flutter/cupertino.dart';

class PaddingList extends EdgeInsets {
  static const double value = 14;

  const PaddingList() : super.only(left: value, right: value);
}