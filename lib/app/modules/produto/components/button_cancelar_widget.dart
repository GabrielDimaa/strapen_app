import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';

class ButtonCancelarWidget extends StatelessWidget {
  final VoidCallback? onPressed;

  const ButtonCancelarWidget({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      child: const Text("Cancelar"),
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        primary: AppColors.error,
        side: BorderSide(color: AppColors.error),
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
