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
      model.userReserva,
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
      null,
    );
  }
}