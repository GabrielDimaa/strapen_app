import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';

class SnapBottomSheet extends StatelessWidget {
  const SnapBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 5,
        width: 50,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
