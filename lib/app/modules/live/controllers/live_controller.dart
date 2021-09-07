import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/live/stores/camera_store.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';

part 'live_controller.g.dart';

class LiveController = _LiveController with _$LiveController;

abstract class _LiveController with Store {
  @observable
  CameraStore cameraStore = CameraStore();

  @observable
  bool loading = false;

  @action
  void setLoading(bool value) => loading = value;

  @action
  Future<void> load({required BuildContext context}) async {
    try {
      setLoading(true);

      await cameraStore.initCamera();
    } catch(e) {
      ErrorDialog.show(context: context, content: e.toString());
    } finally {
      setLoading(false);
    }
  }
}