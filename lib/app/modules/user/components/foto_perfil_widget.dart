import 'dart:io';

import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:transparent_image/transparent_image.dart';

class FotoPerfilWidget extends StatelessWidget {
  final dynamic foto;
  final double? radiusSize;
  final bool isAovivo;

  const FotoPerfilWidget({required this.foto, this.radiusSize, this.isAovivo = false});

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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: radius,
              backgroundColor: isAovivo ? AppColors.error : AppColors.primary,
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
            ),
            Visibility(
              visible: isAovivo,
              child: Card(
                margin: const EdgeInsets.only(top: 4),
                color: AppColors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: const Text("AO VIVO"),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
