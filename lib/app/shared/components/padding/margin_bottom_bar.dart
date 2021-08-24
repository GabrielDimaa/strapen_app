import 'package:flutter/cupertino.dart';

class MarginBottomAppBar extends EdgeInsets {
  static const double value = 24;

  const MarginBottomAppBar() : super.only(left: value, right: value, bottom: value, top: 4);
}