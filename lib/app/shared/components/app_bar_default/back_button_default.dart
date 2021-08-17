import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';

class BackButtonDefault extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: 48,
      child: CircleAvatar(
        backgroundColor: AppColors.opaci,
        child: BackButton(
          color: Colors.white,
        ),
      ),
    );
  }
}
