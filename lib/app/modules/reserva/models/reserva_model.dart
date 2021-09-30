import 'package:strapen_app/app/modules/user/models/user_model.dart';

class ReservaModel {
  String? id;

  String? idProduto;
  String? descricao;
  String? descricaoDetalhada;
  int? quantidade;
  double? preco;
  List<String>? fotos;

  UserModel? user;
  UserModel? anunciante;

  DateTime? dataHoraReserva;

  ReservaModel(
    this.id,
    this.idProduto,
    this.descricao,
    this.descricaoDetalhada,
    this.quantidade,
    this.preco,
    this.fotos,
    this.user,
    this.anunciante,
    this.dataHoraReserva,
  );
}
