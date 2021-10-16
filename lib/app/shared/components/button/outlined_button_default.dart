import 'package:flutter/material.dart';
import 'package:strapen_app/app/shared/components/padding/margin_button.dart';

class OutlinedButtonDefault extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final Color? primary;
  final Color? borderColor;
  final EdgeInsets? padding;

  const OutlinedButtonDefault({
    required this.child,
    this.onPressed,
    this.primary,
    this.borderColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const MarginButton(),
      child: OutlinedButton(
        child: child,
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          primary: primary,
          padding: padding,
          side: borderColor != null ? BorderSide(
            color: borderColor!,
          ) : null,
        ),
      ),
    );
  }
}
