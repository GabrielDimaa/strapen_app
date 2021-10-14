import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/catalogo/factories/catalogo_factory.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';
import 'package:strapen_app/app/modules/catalogo/stores/catalogo_store.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/modules/produto/factories/produto_factory.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/shared/components/dialog/dialog_default.dart';
import 'package:strapen_app/app/shared/components/dialog/loading_dialog.dart';
import 'package:strapen_app/app/shared/utils/image_picker_utils.dart';

part 'catalogo_create_controller.g.dart';

class CatalogoCreateController = _CatalogoCreateController with _$CatalogoCreateController;

abstract class _CatalogoCreateController with Store {
  final ICatalogoRepository _catalogoRepository;
  final AppController _appController;

  _CatalogoCreateController(this._catalogoRepository, this._appController);

  @observable
  CatalogoStore catalogoStore = CatalogoFactory.newStore();

  @observable
  bool loading = false;

  List<ProdutoModel>? produtosBeforeUpdate;

  @action
  void setCatalogoStore(CatalogoStore value) => catalogoStore = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  Future<void> load(CatalogoModel? catalogo) async {
    if (catalogo != null) {
      setCatalogoStore(CatalogoFactory.fromModel(catalogo));
      produtosBeforeUpdate = catalogo.produtos;
    }
  }

  @action
  Future<void> save(BuildContext context) async {
    try {
      CatalogoModel? model;

      await LoadingDialog.show(context, "Salvando catálogo...", () async {
        catalogoStore.setUser(_appController.userModel);

        model = await _catalogoRepository.save(catalogoStore.toModel(), produtosBeforeUpdate);
      });

      if (model == null) throw Exception("Houve um erro ao salvar o produto!");

      Modular.to.pop(model!);
    } catch (_) {
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
    List<ProdutoModel>? produtosModel = await Modular.to.pushNamed(PRODUTO_ROUTE + PRODUTO_SELECT_ROUTE, arguments: catalogoStore.produtos?.map((e) => e.toModel()).toList());

    if (produtosModel != null) {
      catalogoStore.setProdutos(produtosModel.map((e) => ProdutoFactory.fromModel(e)).toList().asObservable());
    }
  }

  @action
  Future<void> remover(BuildContext context) async {
    bool confirm = await DialogDefault.show(
      context: context,
      title: const Text("Remover"),
      content: const Text("Deseja remover esse catálogo?\nOs produtos contidos nele, não serão removidos."),
      actions: [
        TextButton(
          child: const Text("Confirmar"),
          onPressed: () async {
            bool success = false;
            await LoadingDialog.show(context, "Removendo catálogo...", () async {
              success = await _catalogoRepository.delete(catalogoStore.toModel());
            });
            Modular.to.pop(success);
          },
        ),
      ],
    );

    //new model para quando receber o objeto identiicar que foi excluído.
    if (confirm) Modular.to.pop(CatalogoFactory.newModel());
  }
}
