import 'package:flutter/cupertino.dart';

class PaddingButton extends EdgeInsets {
  static const double horizValue = 8;
  static const double veticValue = 18;


  const PaddingButton() : super.symmetric(horizontal: horizValue, vertical: veticValue);
}