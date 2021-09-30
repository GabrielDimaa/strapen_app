import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/chat/components/chat_widget.dart';
import 'package:strapen_app/app/modules/chat/components/text_field_chat_widget.dart';
import 'package:strapen_app/app/modules/chat/models/chat_model.dart';
import 'package:strapen_app/app/modules/live/components/app_bar_live_widget.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';

class ScaffoldForegroundLive extends StatelessWidget {
  final LiveController controller = Modular.get<LiveController>();

  final bool isCriadorLive;
  final BuildContext ctx;

  ScaffoldForegroundLive({required this.isCriadorLive, required this.ctx});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      appBar: AppBarLiveWidget(isCriadorLive: isCriadorLive),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, right: 20),
              child: CircleButtonAppBar(
                color: AppColors.opaci.withOpacity(0.4),
                child: Icon(Icons.ballot),
                onTap: () async => await controller.showCatalogoBottomSheet(ctx),
              ),
            ),
            Expanded(
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
                  const VerticalSizedBox(),
                  Observer(
                    builder: (_) => TextFieldChatWidget(
                      loading: controller.loadingSendComentario,
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
          ],
        ),
      ),
    );
  }
}
