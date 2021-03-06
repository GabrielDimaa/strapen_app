import 'package:camera_with_rtmp/camera.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/live/models/live_demonstracao_model.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/modules/live/repositories/ilive_repository.dart';
import 'package:strapen_app/app/modules/live/services/ilive_service.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/shared/apis/mux_api.dart';

class LiveService implements ILiveService {
  final ILiveRepository _liveRepository;

  LiveService(this._liveRepository);

  @override
  Future<LiveModel> solicitarLive(UserModel user) async {
    try {
      var response = await MuxApi.post("", data: {
        "low_latency": true,
        "playback_policy": "public",
        "new_asset_settings": {
          "playback_policy": "public",
        },
      });

      if (response == null)
        throw Exception("Houve um erro ao realizar a requisição.\nVerifique a conexão da internet.");

      return LiveModel(
        null,
        response['id'],
        response['stream_key'],
        (response['playback_ids'] as List).first['id'],
        null,
        null,
        null,
        user,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<LiveDemonstracaoModel> getLivesDemonstracao(String idUser) async => await _liveRepository.getLivesDemonstracao(idUser);

  @override
  Future<void> startLive(LiveModel model, CameraController cameraController) async {
    await MuxApi.startLive(model, cameraController);
  }

  @override
  Future<void> stopLive(LiveModel model, CameraController cameraController) async {
    try {
      if (cameraController.value.isInitialized || cameraController.value.isStreamingVideoRtmp) {
        await MuxApi.put("${model.liveId}/complete");
      }
    } finally {
      await _liveRepository.finalizar(model);
    }
  }

  @override
  Future<LiveModel> save(LiveModel model) async => await _liveRepository.save(model);

  @override
  Future<LiveModel?> isAovivo(UserModel userModel) async => await _liveRepository.isAovivo(userModel);

  @override
  Future<void> finalizar(LiveModel model) async => await _liveRepository.finalizar(model);

  @override
  Future<List<CatalogoModel>> getCatalogosLive(String idLive) async => await _liveRepository.getCatalogosLive(idLive);

  @override
  Future<int> getCountLives(String idUser) async => await _liveRepository.getCountLives(idUser);

  @override
  Future<void> startListener(String idLive) async => await _liveRepository.startListener(idLive);

  @override
  void stopListener() => _liveRepository.stopListener();
}
