import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';

class PhotoMiniature extends StatelessWidget {
  final VoidCallback? onTap;
  final ImageProvider? image;
  final VoidCallback? onTapRemove;

  const PhotoMiniature({this.onTap, this.image, this.onTapRemove});

  @override
  Widget build(BuildContext context) {
    final double radius = 38;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: onTapRemove,
          borderRadius: BorderRadius.circular(100),
          child: CircleAvatar(
            backgroundColor: onTapRemove != null ? AppColors.opaci : Colors.transparent,
            radius: 9,
            child: Icon(
              Icons.close,
              size: 13,
              color: onTapRemove != null ? Colors.grey : Colors.transparent,
            ),
          ),
        ),
        CircleAvatar(
          backgroundColor: image == null ? AppColors.opaci : Colors.transparent,
          radius: radius,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(radius),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: image,
                radius: radius,
                child: Visibility(
                  visible: image == null,
                  child: Icon(
                    Icons.add_a_photo,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
