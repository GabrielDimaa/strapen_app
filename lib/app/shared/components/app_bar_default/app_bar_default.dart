import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/back_button_default.dart';

class AppBarDefault extends AppBar {
  final Widget? title;
  final bool centerTitle;
  final Widget? leadingWidget;
  final List<Widget>? actionsWidgets;
  final PreferredSizeWidget? bottomWidgets;
  final Color? backgroundColor;
  final Color? backgroundColorBackButton;
  final Color? iconColor;
  final double? leadingSize;
  final VoidCallback? onPressedBackButton;

  AppBarDefault({
    this.title,
    this.centerTitle = true,
    this.leadingWidget,
    this.actionsWidgets,
    this.bottomWidgets,
    this.backgroundColor,
    this.backgroundColorBackButton,
    this.iconColor,
    this.leadingSize,
    this.onPressedBackButton,
  }) : super(
    leadingWidth: leadingSize ?? 90,
    toolbarHeight: 78,
    title: title,
    centerTitle: centerTitle,
    backgroundColor: backgroundColor ?? AppColors.background,
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
          BackButtonDefault(
            backgroundColor: backgroundColorBackButton,
            iconColor: iconColor,
            onPressed: onPressedBackButton,
          )
      ],
    ) : leadingWidget,
  );
}