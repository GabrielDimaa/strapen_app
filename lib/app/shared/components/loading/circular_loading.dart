import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {
  const CircularLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: const CircularProgressIndicator(strokeWidth: 2,));
  }
}
