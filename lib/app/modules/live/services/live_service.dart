import 'package:camera_with_rtmp/camera.dart';
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
        user,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> startLive(LiveModel model, CameraController cameraController) async {
    await MuxApi.startLive(model, cameraController);
  }

  @override
  Future<void> stopLive(CameraController cameraController) async {
    if (cameraController.value.isInitialized || cameraController.value.isStreamingVideoRtmp) {
      await cameraController.stopVideoStreaming();

      await cameraController.dispose();
    }
  }

  @override
  Future<LiveModel> save(LiveModel model) async {
    return await _liveRepository.save(model);
  }
}
