import 'dart:io';

import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:transparent_image/transparent_image.dart';

class FotoPerfilWidget extends StatelessWidget {
  final dynamic foto;
  final double? radiusSize;

  const FotoPerfilWidget({required this.foto, this.radiusSize});

  @override
  Widget build(BuildContext context) {
    double radius = radiusSize ?? 70;

    return Builder(
      builder: (_) {
        ImageProvider<Object>? image;
        if (foto != null) {
          if (foto is File)
            image = Image.file(foto).image;
          else
            image = FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: foto,
            ).image;
        }

        return CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.primary,
          child: CircleAvatar(
            radius: radius - 3,
            backgroundColor: AppColors.background,
            child: image != null
                ? CircleAvatar(
              radius: radius - 8,
              backgroundImage: image,
            )
                : Container(),
          ),
        );
      },
    );
  }
}
