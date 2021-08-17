import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';

class OutlineInputDefault extends OutlineInputBorder {
  OutlineInputDefault()
      : super(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 2,
            style: BorderStyle.solid,
          ),
        );
}
