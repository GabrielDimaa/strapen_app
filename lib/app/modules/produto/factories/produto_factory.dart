import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';

abstract class ProdutoFactory {
  static ProdutoStore fromModel(ProdutoModel model) {
    return ProdutoStore(
      model.id,
      model.descricao,
      model.descricaoDetalhada,
      model.fotos!.asObservable(),
      model.quantidade,
      model.preco,
      model.anunciante,
    );
  }
  
  static ProdutoStore newStore() {
    return ProdutoStore(
      null,
      null,
      null,
      ObservableList(),
      1,
      null,
      null,
    );
  }

  static ProdutoModel newModel() {
    return ProdutoModel(
      null,
      null,
      null,
      [],
      0,
      null,
      null,
    );
  }
}