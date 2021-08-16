import 'package:flutter/material.dart';
import 'package:strapen_app/app/shared/components/padding/margin_button.dart';

class ElevatedButtonDefault extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final Color? primary;
  final Color? onPrimary;

  const ElevatedButtonDefault({
    required this.child,
    this.onPressed,
    this.primary,
    this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const MarginButton(),
      child: ElevatedButton(
        child: child,
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: primary,
          onPrimary: onPrimary,
        ),
      ),
    );
  }
}
