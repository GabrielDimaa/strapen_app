import 'dart:typed_data';

import 'package:strapen_app/app/modules/user/models/user_model.dart';

class ProdutoModel {
  int? id;

  String? descricao;
  String? descricaoDetalhada;

  List<Uint8List>? fotos;

  int? quantidade;
  double? valor;

  UserModel? anunciante;
  UserModel? userReserva;

  ProdutoModel(
    this.id,
    this.descricao,
    this.descricaoDetalhada,
    this.fotos,
    this.quantidade,
    this.valor,
    this.anunciante,
    this.userReserva,
  );
}
