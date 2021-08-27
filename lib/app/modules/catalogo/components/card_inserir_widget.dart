import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class CardAddWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Widget? child;
  final bool notEdit;

  const CardAddWidget({required this.title, required this.onPressed, this.child, this.notEdit = false});

  @override
  Widget build(BuildContext context) {
    final TextStyle style = Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w600);
    return Card(
      color: AppColors.opaci,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(title, style: style),
                TextButton(
                  onPressed: onPressed,
                  child: Row(
                    children: [
                      Text(child != null && !notEdit ? "Editar" : "Inserir", style: style.copyWith(color: AppColors.primary)),
                      const HorizontalSizedBox(),
                      Icon(child != null && !notEdit ? Icons.edit_outlined : Icons.add_circle_outline, color: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ),
            Visibility(
              visible: child != null,
              child: Column(
                children: [
                  child ?? Container(),
                  const VerticalSizedBox(0.8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
