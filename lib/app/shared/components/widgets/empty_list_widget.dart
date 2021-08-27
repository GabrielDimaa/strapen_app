import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class EmptyListWidget extends StatelessWidget {
  final String? message;

  const EmptyListWidget({this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/images/empty_produtos.svg",
          height: 200,
        ),
        const VerticalSizedBox(2),
        Visibility(
          visible: message != null,
          child: Text(message ?? ""),
        ),
      ],
    );
  }
}
