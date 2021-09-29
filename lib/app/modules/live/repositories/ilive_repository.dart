import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/shared/interfaces/repository_interface.dart';

abstract class ILiveRepository implements IRepository<LiveModel> {
  Future<LiveModel> save(LiveModel model);
  Future<LiveModel?> isAovivo(UserModel userModel);
  Future<void> finalizar(LiveModel model);
  Future<List<CatalogoModel>> getCatalogosLive(String idLive);
}