import 'package:flutter/material.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';

class BackButtonDefault extends CircleButtonAppBar {
  final Color? backgroundColor;
  final Color? iconColor;

  BackButtonDefault({this.backgroundColor, this.iconColor}) : super(
    color: backgroundColor,
    child: BackButton(
      color: iconColor ?? Colors.white
    ),
    messageTooltip: "Voltar",
  );
}
