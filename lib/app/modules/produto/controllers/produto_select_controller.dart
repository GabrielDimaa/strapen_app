import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/modules/produto/factories/produto_factory.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/repositories/iproduto_repository.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';

part 'produto_select_controller.g.dart';

class ProdutoSelectController = _ProdutoSelectController with _$ProdutoSelectController;

abstract class _ProdutoSelectController with Store {
  final IProdutoRepository _produtoRepository;
  final AppController _appController;

  _ProdutoSelectController(this._produtoRepository, this._appController);

  @observable
  bool loading = false;

  @observable
  ObservableList<ProdutoStore> produtos = ObservableList<ProdutoStore>();

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setProdutos(ObservableList<ProdutoStore> value) => produtos = value;

  @action
  Future<void> load(List<ProdutoModel>? produtosModel) async {
    try {
      setLoading(true);

      List<ProdutoModel>? list = await _produtoRepository.getByUser(_appController.userModel?.id);

      if (list != null)
        setProdutos(list.map((e) => ProdutoFactory.fromModel(e)).toList().asObservable());

      if (produtosModel != null) {
        produtosModel.forEach((cat) {
          final ProdutoStore? catalogo = produtos.firstWhere((e) => cat.id == e.id, orElse: null);
          if (catalogo != null) catalogo.setSelected(true);
        });
      }
    } finally {
      setLoading(false);
    }
  }

  @action
  void save() {
    List<ProdutoStore> selecteds = produtos.where((e) => e.selected).toList();
    if (selecteds.isEmpty) throw Exception("Selecione pelo menos um produto para exibir no catálogo.");

    Modular.to.pop(selecteds.map((e) => e.toModel()).toList());
  }

  @action
  Future<void> toProdutoCreate() async {
    ProdutoModel? produtoModel = await Modular.to.pushNamed(PRODUTO_ROUTE + PRODUTO_CREATE_ROUTE);

    if (produtoModel?.id != null)
      produtos.add(ProdutoFactory.fromModel(produtoModel!));
  }
}