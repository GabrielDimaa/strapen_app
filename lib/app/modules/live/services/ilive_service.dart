import 'package:camera_with_rtmp/camera.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';

abstract class ILiveService {
  Future<LiveModel> solicitarLive(UserModel user);
  Future<void> startLive(LiveModel model, CameraController cameraController);
  Future<void> stopLive(LiveModel model, CameraController cameraController);

  Future<LiveModel> save(LiveModel model);
  Future<LiveModel?> isAovivo(UserModel userModel);
  Future<void> finalizar(LiveModel model);
  Future<List<CatalogoModel>> getCatalogosLive(String idLive);
}