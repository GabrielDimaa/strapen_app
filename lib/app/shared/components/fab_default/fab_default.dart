import 'package:flutter/material.dart';

class FABDefault extends FloatingActionButton {
  final VoidCallback onPressed;
  final IconData? icon;

  FABDefault({required this.onPressed, required this.icon})
    : super(
      onPressed: onPressed,
      child: Icon(icon, size: 30),
    );
}
