import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';

class InputDecorationDefault extends InputDecoration {
  final String labelText;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? sufixIcon;
  final bool? alignLabelWithHint;

  InputDecorationDefault({
    required this.labelText,
    this.prefixText,
    this.prefixIcon,
    this.sufixIcon,
    this.alignLabelWithHint = false,
  }) : super(
    labelText: labelText,
    alignLabelWithHint: alignLabelWithHint,
    prefixText: prefixText,
    prefixStyle: TextStyle(color: AppColors.primary),
    prefixIcon: prefixIcon != null
        ? Padding(
            padding: const EdgeInsets.only(left: 8),
            child: prefixIcon,
          )
        : null,
    suffixIcon: sufixIcon != null
        ? Padding(
            padding: const EdgeInsets.only(right: 8),
            child: sufixIcon,
          )
        : null,
  );
}
