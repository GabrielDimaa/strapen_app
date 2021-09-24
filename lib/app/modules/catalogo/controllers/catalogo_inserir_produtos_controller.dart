import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_create_controller.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/modules/produto/factories/produto_factory.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/repositories/iproduto_repository.dart';

part 'catalogo_inserir_produtos_controller.g.dart';

class CatalogoInserirProdutosController = _CatalogoInserirProdutosController with _$CatalogoInserirProdutosController;

abstract class _CatalogoInserirProdutosController with Store {
  final CatalogoCreateController _catalogoController;
  final IProdutoRepository _produtoRepository;

  _CatalogoInserirProdutosController(this._catalogoController, this._produtoRepository);

  @observable
  bool loading = false;

  @observable
  ObservableList<ProdutoModel> produtos = ObservableList<ProdutoModel>();

  @observable
  ObservableList<ProdutoModel> produtosSelected = ObservableList<ProdutoModel>();

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setProdutos(ObservableList<ProdutoModel> value) => produtos = value;

  @action
  void addProdutosSelected(ProdutoModel value) => produtosSelected.add(value);

  @action
  void removeProdutosSelected(ProdutoModel value) => produtosSelected.removeWhere((e) => e.id == value.id);

  @action
  Future<void> load() async {
    try {
      setLoading(true);

      List<ProdutoModel>? lista = await _produtoRepository.getByUser(_catalogoController.appController.userModel?.id);

      if (lista != null)
        setProdutos(lista.asObservable());

      produtosSelected = _catalogoController.catalogoStore.produtos?.map((e) {
        return e.toModel();
      }).toList().asObservable() ?? ObservableList<ProdutoModel>();
    } finally {
      setLoading(false);
    }
  }

  @action
  void save() {
    if (produtosSelected.isEmpty ) throw Exception("Selecione pelo menos um produto para exibir no catálogo.");

    _catalogoController.catalogoStore.produtos = produtosSelected.map((e) => ProdutoFactory.fromModel(e)).toList().asObservable();

    Modular.to.pop();
  }

  @action
  Future<void> toProdutoCreate() async {
    ProdutoModel? produtoModel = await Modular.to.pushNamed(PRODUTO_ROUTE + PRODUTO_CREATE_ROUTE);

    if (produtoModel?.id != null)
      produtos.add(produtoModel!);
  }
}