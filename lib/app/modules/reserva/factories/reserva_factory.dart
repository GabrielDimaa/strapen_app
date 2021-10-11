import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';

abstract class ReservaFactory {
  static ReservaModel fromProdutoModel(ProdutoModel produtoModel) {
    return ReservaModel(
      null,
      produtoModel.id,
      produtoModel.descricao,
      produtoModel.descricaoDetalhada,
      produtoModel.quantidade,
      produtoModel.preco,
      produtoModel.fotos!.map((e) => e.toString()).toList(),
      null,
      null,
      produtoModel.anunciante!,
      null,
      null,
    );
  }
}