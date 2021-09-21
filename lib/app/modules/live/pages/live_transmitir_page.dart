import 'package:camera_with_rtmp/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/chat/components/chat_widget.dart';
import 'package:strapen_app/app/modules/chat/components/text_field_chat_widget.dart';
import 'package:strapen_app/app/modules/chat/models/chat_model.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';

class LiveTransmitirPage extends StatefulWidget {
  final CameraLensDirection cameraDirection;

  const LiveTransmitirPage({required this.cameraDirection});

  @override
  _LiveTransmitirPageState createState() => _LiveTransmitirPageState();
}

class _LiveTransmitirPageState extends State<LiveTransmitirPage> {
  final LiveController controller = Modular.get<LiveController>();

  @override
  void initState() {
    super.initState();
    controller.loadTransmitirLive(context);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double size = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Observer(
          builder: (_) {
            if (controller.loading) {
              return CircularLoading();
            } else {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: Observer(
                      builder: (_) {
                        if (!(controller.cameraStore.cameraController?.value.isInitialized ?? false)) {
                          return Center(
                            child: Text(
                              "Permita o Strapen acessar sua câmera para iniciar a Live.",
                              style: textTheme.bodyText2,
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else {
                          return Stack(
                            children: [
                              AspectRatio(
                                aspectRatio: controller.cameraStore.cameraController!.value.aspectRatio,
                                child: CameraPreview(controller.cameraStore.cameraController!),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                  Positioned.fill(
                    child: Scaffold(
                      resizeToAvoidBottomInset: true,
                      backgroundColor: Colors.transparent,
                      appBar: _appBar(),
                      body: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width,
                              child: ChatWidget(
                                model: ChatModel(null, null, controller.appController.userModel!, controller.liveModel),
                              ),
                            ),
                            Observer(
                              builder: (_) => TextFieldChatWidget(
                                loading: controller.loadingSendMessage,
                                sendComentario: (String? comentario) {
                                  try {
                                    controller.sendComentario(comentario);
                                  } catch (e) {
                                    ErrorDialog.show(context: context, content: e.toString());
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBarDefault(
      backgroundColorBackButton: AppColors.opaci.withOpacity(0.4),
      leadingSize: 500,
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
        PopupMenuButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          onSelected: (index) async {
            switch (index) {
              case 0:
                try {
                  controller.setLoading(true);
                  await controller.cameraStore.alterarDirecaoCamera();
                } catch (e) {
                  ErrorDialog.show(context: context, content: e.toString());
                } finally {
                  controller.setLoading(false);
                }
                break;
              case 1:
                await controller.stopLive(context);
                break;
            }
          },
          child: CircleButtonAppBar(
            color: AppColors.opaci.withOpacity(0.4),
            child: Icon(Icons.more_vert, color: Colors.white),
          ),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 0,
                enabled: controller.cameraStore.hasBackAndFront,
                child: const Text("Alterar câmera"),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(
                  "Terminar Live",
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  @override
  void dispose() async {
    super.dispose();
    await controller.cameraStore.cameraController!.dispose();
  }
}
