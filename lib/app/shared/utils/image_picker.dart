import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:strapen_app/app/app_widget.dart';

abstract class ImagePickerUtils {
  static Future<File?> getImagePicker(bool isCamera) async {
    final ImagePicker picker = ImagePicker();
    XFile? image;

    if (isCamera)
      image = await picker.pickImage(source: ImageSource.camera);
    else
      image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    File? cropImage = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      androidUiSettings: AndroidUiSettings(
        toolbarWidgetColor: Colors.white,
        toolbarColor: AppColors.background,
        statusBarColor: AppColors.background,
        backgroundColor: AppColors.background,
        dimmedLayerColor: AppColors.background,
        activeControlsWidgetColor: AppColors.primary,
      ),
    );

    return cropImage;
  }
}
