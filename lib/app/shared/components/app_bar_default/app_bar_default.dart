import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/back_button_default.dart';

class AppBarDefault extends AppBar {
  final Widget? title;
  final bool centerTitle;
  final Widget? leadingWidget;
  final List<Widget>? actionsWidgets;
  final PreferredSizeWidget? bottomWidgets;

  AppBarDefault({
    this.title,
    this.centerTitle = true,
    this.leadingWidget,
    this.actionsWidgets,
    this.bottomWidgets,
  }) : super(
    leadingWidth: 90,
    toolbarHeight: bottomWidgets == null ? 78 : 126,
    title: title,
    centerTitle: centerTitle,
    backgroundColor: Colors.transparent,
    bottom: bottomWidgets,
    actions: [
      if (actionsWidgets != null)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: actionsWidgets..add(const SizedBox(width: 20)),
        ),
    ],
    leading: leadingWidget == null ? Row(
      children: [
        const SizedBox(width: 20),
        if (Modular.to.canPop())
          BackButtonDefault()
      ],
    ) : leadingWidget,
  );
}