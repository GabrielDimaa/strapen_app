import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/shared/interfaces/repository_interface.dart';

abstract class ILiveRepository implements IRepository<LiveModel> {
  String classNameRelation();

  Future<LiveModel> save(LiveModel model);
  Future<void> saveCatalogosLive(LiveModel model);
}