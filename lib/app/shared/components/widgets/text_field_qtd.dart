import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strapen_app/app/app_widget.dart';

class TextFieldQtd extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final bool? enabled;

  const TextFieldQtd({
    required this.controller,
    this.focusNode,
    this.onSubmitted,
    this.onChanged,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buttonQtd(
          icon: Icons.remove,
          color: AppColors.primaryOpaci,
          onTap: () {
            int currentQtd = int.parse(controller.text.isEmpty ? "1" : controller.text);
            if (currentQtd > 1) controller.text = "${currentQtd - 1}";
          },
        ),
        SizedBox(
          width: 60,
          child: TextField(
            textAlign: TextAlign.center,
            controller: controller,
            focusNode: focusNode,
            onSubmitted: onSubmitted,
            textInputAction: TextInputAction.next,
            enabled: enabled,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(3),
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ),
        _buttonQtd(
          icon: Icons.add,
          color: AppColors.primary,
          onTap: () {
            int currentQtd = int.parse(controller.text.isEmpty ? "0" : controller.text);
            controller.text = "${currentQtd + 1}";
          },
        ),
      ],
    );
  }

  Widget _buttonQtd({required IconData icon, required Color color, required VoidCallback onTap}) {
    final BorderRadius radius = BorderRadius.circular(8);

    return InkWell(
      onTap: onTap,
      borderRadius: radius,
      child: Ink(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          borderRadius: radius,
          color: color,
        ),
        child: Icon(
          icon,
          size: 18,
        ),
      ),
    );
  }
}
