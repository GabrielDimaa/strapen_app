import 'package:flutter/material.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';

class RemoverAppBarWidget extends StatelessWidget {
  final VoidCallback onTap;
  final bool visible;

  RemoverAppBarWidget({required this.onTap, this.visible = true});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: CircleButtonAppBar(
        child: Icon(Icons.delete, color: Colors.white),
        onTap: onTap,
        messageTooltip: "Remover",
      ),
    );
  }
}