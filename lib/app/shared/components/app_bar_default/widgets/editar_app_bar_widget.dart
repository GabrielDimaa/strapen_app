import 'package:flutter/material.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';

class EditarAppBarWidget extends StatelessWidget {
  final VoidCallback onTap;
  final bool visible;

  EditarAppBarWidget({required this.onTap, this.visible = true});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: CircleButtonAppBar(
        child: Icon(Icons.edit, color: Colors.white),
        onTap: onTap,
        messageTooltip: "Editar",
      ),
    );
  }
}
