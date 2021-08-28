import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';

class ButtonAddPhoto extends StatelessWidget {
  final VoidCallback onTap;

  const ButtonAddPhoto({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double radius = 38;
    return CircleAvatar(
      backgroundColor: AppColors.opaci,
      radius: radius,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: radius,
            child: Icon(
              Icons.add_a_photo,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
