import 'package:flutter/material.dart';

class BottomAppBarDefault extends StatelessWidget {
  final List<Widget> children;

  const BottomAppBarDefault({required this.children});

  BorderRadius get radius => BorderRadius.circular(16);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 4,
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BottomAppBar(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
