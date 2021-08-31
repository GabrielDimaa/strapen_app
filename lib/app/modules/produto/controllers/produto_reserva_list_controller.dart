import 'dart:ui';

import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/repositories/iproduto_repository.dart';
import 'package:strapen_app/app/shared/interfaces/default_controller_interface.dart';

part 'produto_reserva_list_controller.g.dart';

class ProdutoReservaListController = _ProdutoReservaListController with _$ProdutoReservaListController;

abstract class _ProdutoReservaListController with Store implements IDefaultController {
  final IProdutoRepository _produtoRepository;
  final AppController _appController;

  _ProdutoReservaListController(this._produtoRepository, this._appController);

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
}