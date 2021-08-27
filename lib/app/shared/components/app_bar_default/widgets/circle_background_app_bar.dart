import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';

class CircleButtonAppBar extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const CircleButtonAppBar({required this.child, this.onTap});

  static double size = 48;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: AppColors.opaci, // Button color
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
