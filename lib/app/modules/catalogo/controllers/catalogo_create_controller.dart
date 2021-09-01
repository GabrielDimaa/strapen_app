import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/catalogo/constants/routes.dart';
import 'package:strapen_app/app/modules/catalogo/factories/catalogo_factory.dart';
import 'package:strapen_app/app/modules/catalogo/stores/catalogo_store.dart';
import 'package:strapen_app/app/shared/interfaces/default_controller_interface.dart';
import 'package:strapen_app/app/shared/utils/image_picker.dart';

part 'catalogo_create_controller.g.dart';

class CatalogoCreateController = _CatalogoCreateController with _$CatalogoCreateController;

abstract class _CatalogoCreateController with Store implements IDefaultController {
  final AppController appController;

  _CatalogoCreateController(this.appController);

  @observable
  CatalogoStore catalogoStore = CatalogoFactory.novo();

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
    File? image = await ImagePickerUtils.getImagePicker(isCamera);
    if (image == null) return;

    catalogoStore.setFoto(image);
    Modular.to.pop();
  }

  @action
  Future<void> inserirProdutos() async {
    await Modular.to.pushNamed(CATALOGO_ROUTE + CATALOGO_INSERIR_PRODUTO_ROUTE);
  }
}
