import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/user/components/foto_perfil_widget.dart';
import 'package:strapen_app/app/modules/user/controllers/user_controller.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';

class UserPage extends StatefulWidget {
  final UserModel? model;

  const UserPage({required this.model});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends ModularState<UserPage, UserController> {
  @override
  void initState() {
    super.initState();
    controller.load(widget.model);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBarDefault(
        title: Text("Perfil"),
        actionsWidgets: [
          Observer(
            builder: (_) => Visibility(
              visible: controller.isPerfilPessoal,
              child: CircleButtonAppBar(
                child: Icon(Icons.edit, color: Colors.white),
                onTap: () async => await controller.toEditarPerfil(),
              ),
            ),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (controller.loading) {
            return const CircularLoading();
          } else {
            return SingleChildScrollView(
              padding: const PaddingScaffold(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Observer(
                        builder: (_) => FotoPerfilWidget(
                          foto: controller.userStore.foto,
                          radiusSize: 52,
                          liveModel: controller.liveModel,
                          onTap: () async => await controller.toAssistirLive(),
                        ),
                      ),
                      const HorizontalSizedBox(2),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Observer(
                                builder: (_) => Text(
                                  "@${controller.userStore.username!}",
                                  overflow: TextOverflow.fade,
                                  style: textTheme.bodyText2!.copyWith(color: AppColors.primary, fontSize: 18),
                                ),
                              ),
                              const VerticalSizedBox(0.5),
                              Observer(builder: (_) => Text(controller.userStore.nome!, overflow: TextOverflow.fade)),
                              const VerticalSizedBox(0.5),
                              Observer(builder: (_) => Text(controller.userStore.telefone!)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const VerticalSizedBox(1.5),
                  Observer(
                    builder: (_) => Visibility(
                      visible: controller.userStore.bio.notIsNullOrEmpty(),
                      child: Column(
                        children: [
                          Text(
                            "Bio",
                            style: textTheme.bodyText2!.copyWith(fontSize: 18),
                          ),
                          const VerticalSizedBox(0.5),
                          Text(controller.userStore.bio ?? ""),
                        ],
                      ),
                    ),
                  ),
                  const VerticalSizedBox(1.5),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    overflowDirection: VerticalDirection.down,
                    overflowButtonSpacing: 12,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Observer(
                          builder: (_) => _itemBar(
                            qtd: controller.countLive,
                            text: "Lives",
                          ),
                        ),
                      ),
                      const HorizontalSizedBox(),
                      Align(
                        alignment: Alignment.center,
                        child: Observer(
                          builder: (_) => _itemBar(
                            qtd: controller.countSeguidores,
                            text: "Seguidores",
                          ),
                        ),
                      ),
                      const HorizontalSizedBox(),
                      Align(
                        alignment: Alignment.center,
                        child: Observer(
                          builder: (_) => _itemBar(
                            qtd: controller.countSeguindo,
                            text: "Seguindo",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const VerticalSizedBox(2),
                  Observer(
                    builder: (_) => Visibility(
                      visible: !controller.isPerfilPessoal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Observer(
                            builder: (_) => _buttonSeguir(context: context),
                          ),
                        ],
                      ),
                      replacement: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Reservas",
                            style: textTheme.bodyText2!.copyWith(fontSize: 18),
                          ),
                          TextButton(
                            onPressed: () async => await controller.toReservas(),
                            child: Row(
                              children: [
                                const Text("Ver todos"),
                                Icon(Icons.keyboard_arrow_right),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _itemBar({required int qtd, required String text}) {
    return SizedBox(
      width: 66,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("$qtd", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const VerticalSizedBox(0.3),
          Text(text, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buttonSeguir({required BuildContext context}) {
    return InkWell(
      onTap: () async {
        try {
          if (controller.seguindo) {
            await showModalBottomSheet(
              context: context,
              builder: (_) => BottomSheet(
                onClosing: () {},
                builder: (_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VerticalSizedBox(),
                    TextButton(
                      onPressed: () async {
                        try {
                          await controller.deixarDeSeguir(context);
                        } finally {
                          Modular.to.pop();
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_remove_outlined,
                          ),
                          const HorizontalSizedBox(),
                          const Text(
                            "Deixar de seguir",
                          ),
                        ],
                      ),
                    ),
                    const VerticalSizedBox(),
                  ],
                ),
              ),
            );
          } else {
            await controller.seguirDeixarDeSeguir(context);
          }
        } catch (e) {
          ErrorDialog.show(context: context, content: e.toString());
        }
      },
      splashColor: controller.seguindo ? AppColors.primaryDark.withOpacity(0.4) : AppColors.secondary.withOpacity(0.4),
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        width: 136,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary),
          color: controller.seguindo ? AppColors.primaryOpaci : AppColors.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              controller.seguindo ? "Seguindo " : "Seguir",
              style: TextStyle(
                color: controller.seguindo ? AppColors.primary : Colors.white,
              ),
            ),
            if (controller.seguindo) Icon(Icons.keyboard_arrow_down, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
