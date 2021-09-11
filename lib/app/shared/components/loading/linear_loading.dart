import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';

class LinearLoading extends StatelessWidget {
  final bool visible;

  const LinearLoading({required this.visible});

  @override
  Widget build(BuildContext context) {
    return visible ? LinearProgressIndicator(
      backgroundColor: AppColors.opaci,
      color: AppColors.primary,
      minHeight: 1.2,
    ) : Container(height: 1);
  }
}
