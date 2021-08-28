import 'package:mobx/mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';

part 'produto_list_controller.g.dart';

class ProdutoListController = _ProdutoListController with _$ProdutoListController;

abstract class _ProdutoListController with Store {
  @action
  Future<void> toCreateProduto() async {
    await Modular.to.pushNamed(PRODUTO_ROUTE + PRODUTO_CREATE_ROUTE);
  }
}