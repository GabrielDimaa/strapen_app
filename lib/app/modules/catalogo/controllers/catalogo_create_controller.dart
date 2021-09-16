import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/catalogo/constants/routes.dart';
import 'package:strapen_app/app/modules/catalogo/factories/catalogo_factory.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';
import 'package:strapen_app/app/modules/catalogo/stores/catalogo_store.dart';
import 'package:strapen_app/app/shared/components/dialog/loading_dialog.dart';
import 'package:strapen_app/app/shared/interfaces/default_controller_interface.dart';
import 'package:strapen_app/app/shared/utils/image_picker_utils.dart';

part 'catalogo_create_controller.g.dart';

class CatalogoCreateController = _CatalogoCreateController with _$CatalogoCreateController;

abstract class _CatalogoCreateController with Store implements IDefaultController {
  final ICatalogoRepository _catalogoRepository;
  final AppController appController;

  _CatalogoCreateController(this._catalogoRepository, this.appController);

  @observable
  CatalogoStore catalogoStore = CatalogoFactory.newStore();

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
  Future<void> save(BuildContext context) async {
    try {
      CatalogoModel? model;

      await LoadingDialog.show(context, "Salvando catálogo...", () async {
        catalogoStore.setUser(appController.userModel);

        model = await _catalogoRepository.save(catalogoStore.toModel());
      });

      Modular.to.pop(model ?? CatalogoFactory.newModel());
    } catch(_) {
      rethrow;
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
