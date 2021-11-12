import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';

class ScaffoldGradiente extends StatelessWidget {
  final AppBar? appBar;
  final Widget body;
  final EdgeInsets? padding;
  final Future<bool> Function()? onWillPop;

  const ScaffoldGradiente({this.appBar, required this.body, this.padding, this.onWillPop});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: appBar,
        extendBody: true,
        body: Container(
          padding: padding,
          child: body,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColors.gradiente,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }
}
