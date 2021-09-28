import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';

class AppBarLiveWidget extends StatelessWidget with PreferredSizeWidget {
  final LiveController controller = Modular.get<LiveController>();

  final bool isCriadorLive;

  AppBarLiveWidget({required this.isCriadorLive});

  @override
  Widget build(BuildContext context) {
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
        Visibility(
          visible: isCriadorLive,
          child: PopupMenuButton(
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
          replacement: CircleButtonAppBar(
            color: AppColors.opaci.withOpacity(0.4),
            child: Icon(Icons.close, color: Colors.white),
            onTap: () async => await controller.stopWatch(context),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
