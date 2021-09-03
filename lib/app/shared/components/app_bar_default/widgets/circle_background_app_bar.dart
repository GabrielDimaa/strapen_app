import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';

class CircleButtonAppBar extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? color;

  const CircleButtonAppBar({required this.child, this.onTap, this.color});

  static double size = 48;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: color ?? AppColors.opaci, // Button color
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: child,
          ),
        ),
      ),
    );
  }
}
