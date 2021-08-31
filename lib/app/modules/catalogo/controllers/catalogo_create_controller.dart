import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/catalogo/factories/catalogo_factory.dart';
import 'package:strapen_app/app/modules/catalogo/stores/catalogo_store.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/shared/interfaces/default_controller_interface.dart';

part 'catalogo_create_controller.g.dart';

class CatalogoCreateController = _CatalogoCreateController with _$CatalogoCreateController;

abstract class _CatalogoCreateController with Store implements IDefaultController {
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
  Future<void> toCreateProduto() async {
    await Modular.to.pushNamed(PRODUTO_ROUTE + PRODUTO_CREATE_ROUTE);
  }
}
