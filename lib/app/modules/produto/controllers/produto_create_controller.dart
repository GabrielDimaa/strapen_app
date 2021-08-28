import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/produto/factories/produto_factory.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/shared/interfaces/default_controller_interface.dart';

part 'produto_create_controller.g.dart';

class ProdutoCreateController = _ProdutoCreateController with _$ProdutoCreateController;

abstract class _ProdutoCreateController with Store implements IDefaultController {
  @observable
  ProdutoStore produtoStore = ProdutoFactory.novo();

  @observable
  bool loading = false;

  @override
  VoidCallback? initPage;

  @action
  void setLoading(bool value) => loading = value;

  @override
  void setInitPage(VoidCallback function) => initPage = function;

  @action
  Future<void> load() async {}

  @action
  Future<void> save() async {
    try {
      setLoading(true);
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> getImagePicker(bool isCamera) async {
    final ImagePicker picker = ImagePicker();
    XFile? image;

    if (isCamera)
      image = await picker.pickImage(source: ImageSource.camera);
    else
      image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

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

    if (cropImage == null) return;

    produtoStore.setFoto(await cropImage.readAsBytes().asObservable());

    Modular.to.pop();
  }
}
