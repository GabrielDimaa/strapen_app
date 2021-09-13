import 'package:camera_with_rtmp/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/live/controllers/live_create_controller.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/modules/live/services/ilive_service.dart';
import 'package:strapen_app/app/modules/live/stores/camera_store.dart';
import 'package:strapen_app/app/modules/start/constants/routes.dart';
import 'package:strapen_app/app/shared/components/dialog/concluido_dialog.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/dialog/loading_dialog.dart';

part 'live_transmitir_controller.g.dart';

class LiveTransmitirController = _LiveTransmitirController with _$LiveTransmitirController;

abstract class _LiveTransmitirController with Store {
  final ILiveService _liveService;

  _LiveTransmitirController(this._liveService);

  @observable
  CameraStore cameraStore = CameraStore();

  @observable
  bool loading = false;

  @observable
  LiveModel? liveModel;

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setLiveModel(LiveModel value) => liveModel = value;

  @action
  Future<void> load({required BuildContext context, required CameraLensDirection direction}) async {
    try {
      setLoading(true);

      setLiveModel(Modular.get<LiveCreateController>().liveModel!);

      await cameraStore.initCamera(direction: direction);
      await _liveService.startLive(liveModel!, cameraStore.cameraController!);
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> stopLive(BuildContext context) async {
    await LoadingDialog.show(context, "Finalizando...", () async {
      try {
        await _liveService.stopLive(liveModel!, cameraStore.cameraController!);
      } finally {
        await cameraStore.cameraController!.stopVideoStreaming();

        Future.delayed(Duration(seconds: 3), () {
          setLoading(false);
          Modular.to.navigate(START_ROUTE);
        });

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => ConcluidoDialog(
            message: "Sua Live foi finalizada com sucesso! Você será redirecionado para a tela inicial.",
          ),
        );
      }
    });
  }
}