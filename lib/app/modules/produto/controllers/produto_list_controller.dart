import 'dart:ui';

import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/repositories/iproduto_repository.dart';
import 'package:strapen_app/app/shared/interfaces/default_controller_interface.dart';

part 'produto_list_controller.g.dart';

class ProdutoListController = _ProdutoListController with _$ProdutoListController;

abstract class _ProdutoListController with Store implements IDefaultController {
  final IProdutoRepository _produtoRepository;
  final AppController _appController;

  _ProdutoListController(this._produtoRepository, this._appController);

  @observable
  ObservableList<ProdutoModel> produtos = ObservableList<ProdutoModel>();

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

      List<ProdutoModel>? list = await _produtoRepository.getByUser(_appController.userModel?.id);

      if (list != null) produtos = list.asObservable();
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> toCreateProduto() async {
    await Modular.to.pushNamed(PRODUTO_ROUTE + PRODUTO_CREATE_ROUTE);
  }
}