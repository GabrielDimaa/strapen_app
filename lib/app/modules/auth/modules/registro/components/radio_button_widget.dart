import 'package:flutter/material.dart';

class RadioButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final Function(bool?) onChaged;
  final bool value;
  final bool groupValue;
  final String title;

  const RadioButtonWidget({
    required this.onTap,
    required this.onChaged,
    required this.value,
    required this.groupValue,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Radio(
              value: value,
              groupValue: groupValue,
              onChanged: onChaged,
            ),
            Text(title),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
