import 'package:camera_with_rtmp/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/modules/live/stores/camera_store.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class LivePage extends StatefulWidget {
  final CameraStore cameraStore;

  const LivePage({required this.cameraStore});

  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends ModularState<LivePage, LiveController> {
  @override
  void initState() {
    super.initState();
    controller.cameraStore = widget.cameraStore;
    controller.load(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) {
          if (controller.loading) {
            return CircularLoading();
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: controller.cameraStore.cameraController!.value.aspectRatio,
                      child: CameraPreview(controller.cameraStore.cameraController!),
                    ),
                    SizedBox(
                      height: 150,
                      child: AppBarDefault(
                        backgroundColorBackButton: AppColors.opaci.withOpacity(0.4),
                        leadingWidth: 500,
                        leadingWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const HorizontalSizedBox(),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(36),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 4,
                                  ),
                                  const HorizontalSizedBox(0.5),
                                  Text(
                                    "AO VIVO",
                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        actionsWidgets: [
                          Visibility(
                            visible: controller.cameraStore.hasBackAndFront,
                            child: CircleButtonAppBar(
                              color: AppColors.opaci.withOpacity(0.4),
                              onTap: () async {
                                try {
                                  controller.setLoading(true);

                                  await controller.cameraStore.alterarDirecaoCamera();
                                } catch (e) {
                                  ErrorDialog.show(context: context, content: e.toString());
                                } finally {
                                  controller.setLoading(false);
                                }
                              },
                              child: Observer(
                                builder: (_) => Icon(
                                  controller.cameraStore.currentCamera?.lensDirection == CameraLensDirection.front ? Icons.camera_rear : Icons.camera_front,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() async {
    await widget.cameraStore.cameraController!.dispose();
    await controller.cameraStore.cameraController!.dispose();
    super.dispose();
  }
}
