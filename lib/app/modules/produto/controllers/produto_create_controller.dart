import 'dart:ui';

import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/produto/factories/produto_factory.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/shared/interfaces/default_controller_interface.dart';

part 'produto_create_controller.g.dart';

class ProdutoCreateController = _ProdutoCreateController with _$ProdutoCreateController;

abstract class _ProdutoCreateController with Store implements IDefaultController {
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
  Future<void> load() async {}

  @action
  Future<void> save() async {
    try {
      setLoading(true);
    } finally {
      setLoading(false);
    }
  }
}