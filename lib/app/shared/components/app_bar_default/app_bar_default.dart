import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/back_button_default.dart';

class AppBarDefault extends AppBar {
  final Widget? title;
  final bool centerTitle;
  final Widget? leading;
  final List<Widget>? actions;

  AppBarDefault({
    this.title,
    this.centerTitle = true,
    this.leading,
    this.actions,
  }) : super(
    leadingWidth: 90,
    toolbarHeight: 78,
    title: title,
    centerTitle: centerTitle,
    backgroundColor: Colors.transparent,
    actions: actions?..add(const SizedBox(width: 20)),
    leading: Row(
      children: [
        if (Modular.to.canPop())
          Expanded(child: BackButtonDefault())
        else if (leading != null)
          leading
      ],
    ),
  );
}
