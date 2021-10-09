import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

///Widget destinado a ListView na horizontal, caso tenha valor vazio.
class EmptyListHorizontalWidget extends StatelessWidget {
  final String pathImage;
  final String message;

  const EmptyListHorizontalWidget({required this.pathImage, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          pathImage,
          height: 140,
          width: 140,
        ),
        const VerticalSizedBox(1.5),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
