import 'package:flutter/material.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/back_button_default.dart';

class AppBarDefault extends AppBar {
  final Widget? title;
  final bool centerTitle;
  final bool backButton;
  final List<Widget>? actions;

  AppBarDefault({
    this.title,
    this.centerTitle = true,
    this.backButton = true,
    this.actions,
  }) : super(
    leadingWidth: 90,
    toolbarHeight: 78,
    title: title,
    centerTitle: centerTitle,
    backgroundColor: Colors.transparent,
    actions: actions,
    leading: Visibility(
      visible: backButton,
      child: Row(
        children: [
          Expanded(child: BackButtonDefault()),
        ],
      ),
    ),
  );
}
