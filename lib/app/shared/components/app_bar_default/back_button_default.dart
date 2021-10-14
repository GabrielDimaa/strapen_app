import 'package:flutter/material.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';

class BackButtonDefault extends CircleButtonAppBar {
  final Color? backgroundColor;
  final Color? iconColor;
  final VoidCallback? onPressed;

  BackButtonDefault({this.backgroundColor, this.iconColor, this.onPressed}) : super(
    color: backgroundColor,
    child: BackButton(
      color: iconColor ?? Colors.white,
      onPressed: onPressed,
    ),
    messageTooltip: "Voltar",
  );
}
