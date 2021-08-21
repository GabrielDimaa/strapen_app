import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';

class LinearLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      backgroundColor: AppColors.opaci,
      color: AppColors.primary,
      minHeight: 1.2,
    );
  }
}
