import 'package:strapen_app/app/modules/produto/models/produto_model.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';

class CatalogoModel {
  String? id;
  DateTime? dataCriado;

  String? titulo;
  String? descricao;
  dynamic foto;

  List<ProdutoModel>? produtos;

  UserModel? user;

  CatalogoModel(
    this.id,
    this.dataCriado,
    this.titulo,
    this.descricao,
    this.foto,
    this.produtos,
    this.user,
  );
}
