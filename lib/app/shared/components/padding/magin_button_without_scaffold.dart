import 'package:flutter/cupertino.dart';
import 'package:strapen_app/app/shared/components/padding/margin_button.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';

class MarginButtonWithoutScaffold extends EdgeInsets {
  static const double value = PaddingScaffold.value;

  const MarginButtonWithoutScaffold() : super.only(left: value, right: value, bottom: value, top: MarginButton.value);
}