import 'dart:ui';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/repositories/iproduto_repository.dart';
import 'package:strapen_app/app/shared/interfaces/default_controller_interface.dart';

part 'produto_list_controller.g.dart';

class ProdutoListController = _ProdutoListController with _$ProdutoListController;

abstract class _ProdutoListController with Store {
  final IProdutoRepository _produtoRepository;
  final AppController _appController;

  _ProdutoListController(this._produtoRepository, this._appController);

  @observable
  ObservableList<ProdutoModel> produtos = ObservableList<ProdutoModel>();

  @observable
  bool loading = false;

  @action
  void setLoading(bool value) => loading = value;

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
  Future<void> toProdutoCreate() async {
    await Modular.to.pushNamed(PRODUTO_ROUTE + PRODUTO_CREATE_ROUTE);
    await load();
  }

  @action
  Future<void> toProdutoInfo(ProdutoModel model) async {
    await Modular.to.pushNamed(PRODUTO_ROUTE + PRODUTO_INFO_ROUTE, arguments: model);
    await load();
  }
}