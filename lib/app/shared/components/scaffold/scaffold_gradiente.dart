import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';

class ScaffoldGradiente extends StatelessWidget {
  final AppBar? appBar;
  final Widget body;
  final EdgeInsets? padding;

  const ScaffoldGradiente({this.appBar, required this.body, this.padding});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
