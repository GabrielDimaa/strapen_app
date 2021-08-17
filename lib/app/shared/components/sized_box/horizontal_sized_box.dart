import 'package:flutter/material.dart';

class HorizontalSizedBox extends SizedBox {
  static const double space = 12;

  const HorizontalSizedBox([qtd = 1])
      : assert(qtd > 0),
        super(width: space * qtd);
}
