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
import 'package:strapen_app/app/shared/utils/image_picker_utils.dart';

part 'produto_create_controller.g.dart';

class ProdutoCreateController = _ProdutoCreateController with _$ProdutoCreateController;

abstract class _ProdutoCreateController with Store implements IDefaultController {
  final IProdutoRepository _produtoRepository;
  final AppController _appController;

  _ProdutoCreateController(this._produtoRepository, this._appController);

  @observable
  ProdutoStore produtoStore = ProdutoFactory.newStore();

  @observable
  bool loading = false;

  @override
  VoidCallback? initPage;

  @action
  void setProdutoStore(ProdutoStore value) => produtoStore = value;

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
      ProdutoModel? model;

      await LoadingDialog.show(context, "Salvando produto...", () async {
        produtoStore.setAnunciante(_appController.userModel);
        model = await _produtoRepository.save(produtoStore.toModel());
      });

      if (model == null) throw Exception("Houve um erro ao salvar o produto!");

      Modular.to.pop(model!);
    } catch (_) {
      rethrow;
    }
  }

  @action
  Future<void> remover(BuildContext context) async {
    bool confirm = await DialogDefault.show(
      context: context,
      title: const Text("Remover"),
      content: const Text("Deseja remover esse produto?"),
      actions: [
        TextButton(
          child: const Text("Confirmar"),
          onPressed: () async {
            bool success = false;
            await LoadingDialog.show(context, "Removendo produto...", () async {
              success = await _produtoRepository.delete(produtoStore.toModel());
            });
            Modular.to.pop(success);
          },
        ),
      ],
    );

    //new model para quando receber o objeto identiicar que foi excluído.
    if (confirm) Modular.to.pop(ProdutoFactory.newModel());
  }

  @action
  Future<void> getImagePicker(bool isCamera) async {
    File? image = await ImagePickerUtils.getImagePicker(isCamera);
    if (image == null) return;

    produtoStore.setFoto(image);
    Modular.to.pop();
  }
}
