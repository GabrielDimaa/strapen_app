import 'dart:io';

import 'package:flutter/material.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:transparent_image/transparent_image.dart';

class Photo extends StatelessWidget {
  final VoidCallback? onTap;
  final dynamic image;

  Photo({this.onTap, this.image});

  BorderRadius get _borderRadius => BorderRadius.circular(16);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        borderRadius: _borderRadius,
        onTap: image == null ? onTap : null,
        child: Ink(
          height: 180,
          width: 180,
          decoration: BoxDecoration(color: AppColors.opaci, borderRadius: _borderRadius),
          child: image != null
              ? ClipRRect(
                  borderRadius: _borderRadius,
                  child: image is File ? Image.file(image!) : FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: image,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Icon(Icons.add_photo_alternate, size: 78), Text("Adicione foto do seu produto.")],
                  ),
                ),
        ),
      ),
    );
  }
}
