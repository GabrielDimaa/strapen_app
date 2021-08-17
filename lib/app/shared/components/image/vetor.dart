import 'package:flutter/material.dart';

class Vetor extends StatelessWidget {
  final String path;

  const Vetor({required this.path});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.1,
      child: Image.asset(path, isAntiAlias: true,),
    );
  }
}
