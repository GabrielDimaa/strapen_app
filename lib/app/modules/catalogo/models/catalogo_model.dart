import 'dart:typed_data';

import 'package:strapen_app/app/modules/user/models/user_model.dart';

class CatalogoModel {
  int? id;
  DateTime? dataCriado;

  String? titulo;
  String? descricao;
  Uint8List? foto;

  //List<ProdutoModel>? produtos;

  UserModel? user;

  CatalogoModel(
    this.id,
    this.dataCriado,
    this.titulo,
    this.descricao,
    this.foto,
    this.user,
  );
}
