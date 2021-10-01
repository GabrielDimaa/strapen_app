import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';

class ActionAppBarHome extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ActionAppBarHome({required this.icon, required this.onTap});

  BorderRadius get borderRadius => BorderRadius.circular(12);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.secondary,
      borderRadius: borderRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 11),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: AppColors.primaryOpaci,
        ),
        child: Icon(icon),
      ),
    );
  }
}
