import 'package:strapen_app/app/modules/user/models/user_model.dart';

class ProdutoModel {
  String? id;

  String? descricao;
  String? descricaoDetalhada;

  //Definido como dynamic pois para salvar, será usado File
  //E para exibir as fotos será usado String(Parse permite utilizar url para exibir imagens)
  List<dynamic>? fotos;

  int? quantidade;
  double? preco;

  UserModel? anunciante;
  UserModel? userReserva;

  ProdutoModel(
    this.id,
    this.descricao,
    this.descricaoDetalhada,
    this.fotos,
    this.quantidade,
    this.preco,
    this.anunciante,
    this.userReserva,
  );
}
