import 'package:flutter/cupertino.dart';

class PaddingScaffold extends EdgeInsets {
  static const double value = 28;

  const PaddingScaffold() : super.only(left: value, right: value, bottom: value);
}