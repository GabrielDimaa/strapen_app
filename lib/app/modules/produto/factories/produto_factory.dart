import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/produto/stores/produto_store.dart';
import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';

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

  static ProdutoModel fromReservaModel(ReservaModel model) {
    return ProdutoModel(
      model.id,
      model.descricao,
      model.descricaoDetalhada,
      model.fotos,
      model.quantidade,
      model.preco,
      model.anunciante,
    );
  }
}