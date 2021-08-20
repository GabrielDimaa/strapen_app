import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';

class OutlineInputError extends OutlineInputBorder {
  OutlineInputError()
      : super(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(
      color: AppColors.error,
      width: 3,
      style: BorderStyle.solid,
    ),
  );
}
