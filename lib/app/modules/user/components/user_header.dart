import 'package:flutter/material.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class UserHeader extends StatelessWidget {
  final String title;

  const UserHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const VerticalSizedBox(),
        Text(
          title,
          style: Theme.of(context).textTheme.headline1,
        ),
        const VerticalSizedBox(2),
      ],
    );
  }
}
