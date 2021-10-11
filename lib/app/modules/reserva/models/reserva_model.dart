import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/modules/reserva/enums/enum_status_reserva.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';

class ReservaModel {
  String? id;

  String? idProduto;
  String? descricao;
  String? descricaoDetalhada;
  int? quantidade;
  double? preco;
  List<String>? fotos;

  LiveModel? live;

  UserModel? user;
  UserModel? anunciante;

  EnumStatusReserva? status;
  DateTime? dataHoraReserva;

  ReservaModel(
    this.id,
    this.idProduto,
    this.descricao,
    this.descricaoDetalhada,
    this.quantidade,
    this.preco,
    this.fotos,
    this.live,
    this.user,
    this.anunciante,
    this.status,
    this.dataHoraReserva,
  );
}
