import 'package:flutter/material.dart';

import '../../../app_widget.dart';

class OutlineInputDisable extends OutlineInputBorder {
  OutlineInputDisable()
      : super(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(
      color: Colors.grey,
      width: 2,
      style: BorderStyle.solid,
    ),
  );
}