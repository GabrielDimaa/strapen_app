import 'package:flutter/material.dart';

class VerticalSizedBox extends SizedBox {
  static const double space = 12;

  const VerticalSizedBox([double qtd = 1])
      : assert(qtd > 0),
        super(height: space * qtd);
}