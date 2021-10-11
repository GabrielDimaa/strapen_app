import 'package:strapen_app/app/modules/reserva/models/reserva_model.dart';
import 'package:strapen_app/app/shared/interfaces/repository_interface.dart';

abstract class IReservaRepository implements IRepository<ReservaModel> {
  Future<ReservaModel> save(ReservaModel model);
  Future<List<ReservaModel>> getAllCompras(String idUser, {int? limit});
  Future<List<ReservaModel>> getAllReservas(String idUser, {int? limit});
  Future<void> startListener(String idLive);
  void stopListener();
}