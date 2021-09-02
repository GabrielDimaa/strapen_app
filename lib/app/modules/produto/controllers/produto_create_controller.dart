import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/produto/factories/produto_factory.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/repositories/iproduto_repository.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/shared/components/dialog/dialog_default.dart';
import 'package:strapen_app/app/shared/components/dialog/loading_dialog.dart';
import 'package:strapen_app/app/shared/interfaces/default_controller_interface.dart';
import 'package:strapen_app/app/shared/utils/image_picker.dart';

part 'produto_create_controller.g.dart';

class ProdutoCreateController = _ProdutoCreateController with _$ProdutoCreateController;

abstract class _ProdutoCreateController with Store implements IDefaultController {
  final IProdutoRepository _produtoRepository;
  final AppController _appController;

  _ProdutoCreateController(this._produtoRepository, this._appController);

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
  Future<void> load() async {
    try {
      setLoading(true);
    } finally {
      initPage!.call();
      setLoading(false);
    }
  }

  @action
  Future<void> save(BuildContext context) async {
    try {
      setLoading(true);

      await LoadingDialog.show(context, "Salvando produto...", () async {
        produtoStore.setAnunciante(_appController.userModel);
        ProdutoModel? model = await _produtoRepository.save(produtoStore.toModel());

        setLoading(false);

        if (model?.id != null) Modular.to.pop(model!);
      });
    } catch (_) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> getImagePicker(bool isCamera) async {
    File? image = await ImagePickerUtils.getImagePicker(isCamera);
    if (image == null) return;

    produtoStore.setFoto(image);
    Modular.to.pop();
  }
}
