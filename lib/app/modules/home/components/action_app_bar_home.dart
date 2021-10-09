import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';

class ActionAppBarHome extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String messageTooltip;

  const ActionAppBarHome({required this.icon, required this.onTap, required this.messageTooltip});

  BorderRadius get borderRadius => BorderRadius.circular(12);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: messageTooltip,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.secondary.withOpacity(0.4),
        borderRadius: borderRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 11),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: AppColors.primaryOpaci,
          ),
          child: Icon(icon),
        ),
      ),
    );
  }
}
