import 'package:camera_with_rtmp/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/home/constants/routes.dart';
import 'package:strapen_app/app/modules/live/controllers/live_create_controller.dart';
import 'package:strapen_app/app/modules/live/services/ilive_service.dart';
import 'package:strapen_app/app/modules/live/stores/camera_store.dart';
import 'package:strapen_app/app/shared/components/dialog/concluido_dialog.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';

part 'live_controller.g.dart';

class LiveController = _LiveController with _$LiveController;

abstract class _LiveController with Store {
  final ILiveService _liveService;

  _LiveController(this._liveService);

  @observable
  CameraStore cameraStore = CameraStore();

  @observable
  bool loading = false;

  @action
  void setLoading(bool value) => loading = value;

  @action
  Future<void> load({required BuildContext context, required CameraLensDirection direction}) async {
    try {
      setLoading(true);

      await cameraStore.initCamera(direction: direction);
      await _liveService.startLive(Modular.get<LiveCreateController>().liveModel!, cameraStore.cameraController!);
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> stopLive(BuildContext context) async {
    await _liveService.stopLive(cameraStore.cameraController!);

    Future.delayed(Duration(seconds: 3), () {
      Modular.to.navigate(HOME_ROUTE);
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ConcluidoDialog(
        message: "Sua Live foi finalizada com sucesso! Você será redirecionado para a tela inicial.",
      ),
    );
  }
}
