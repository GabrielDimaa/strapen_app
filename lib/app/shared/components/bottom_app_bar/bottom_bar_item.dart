import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';

class BottomAppBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback ontap;
  final bool selected;

  const BottomAppBarItem({required this.icon, required this.label, required this.ontap, required this.selected});

  BorderRadius get borderRadius => BorderRadius.circular(12);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: borderRadius,
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: selected ? AppColors.primaryOpaci : Colors.transparent,
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: 26),
            Visibility(
              visible: selected,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Text(label, style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
