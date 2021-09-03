import 'package:flutter/material.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';

class BackButtonDefault extends CircleButtonAppBar {
  final Color? backgroundColor;

  BackButtonDefault({this.backgroundColor}) : super(
    color: backgroundColor,
    child: BackButton(
      color: Colors.white,
    ),
  );
}
