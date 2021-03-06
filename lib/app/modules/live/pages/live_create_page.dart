import 'package:camera_with_rtmp/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/catalogo/stores/catalogo_store.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/padding/magin_button_without_scaffold.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/catalogo_grid_tile.dart';
import 'package:strapen_app/app/shared/components/widgets/catalogo_grid_view.dart';
import 'package:strapen_app/app/shared/extensions/datetime_extension.dart';

class LiveCreatePage extends StatefulWidget {
  @override
  _LiveCreatePageState createState() => _LiveCreatePageState();
}

class _LiveCreatePageState extends State<LiveCreatePage> {
  final LiveController controller = Modular.get<LiveController>();

  @override
  void initState() {
    super.initState();
    controller.loadCreateLive(context);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double size = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Observer(
          builder: (_) {
            if (controller.loading) {
              return CircularLoading();
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: size,
                              child: Observer(
                                builder: (_) {
                                  if (!(controller.cameraStore.cameraController?.value.isInitialized ?? false)) {
                                    return Center(
                                      child: Text(
                                        "Permita o Strapen acessar sua c??mera para iniciar a Live.",
                                        style: textTheme.bodyText2,
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  } else {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(36),
                                        bottomLeft: Radius.circular(36),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: SizedBox(
                                          width: size,
                                          height: size / controller.cameraStore.cameraController!.value.aspectRatio,
                                          child: CameraPreview(controller.cameraStore.cameraController!),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const PaddingScaffold(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const VerticalSizedBox(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text("Cat??logos", style: textTheme.headline1!.copyWith(fontWeight: FontWeight.w600)),
                                        TextButton(
                                          onPressed: () async => await controller.inserirCatalogos(),
                                          child: Observer(
                                            builder: (_) {
                                              bool edit = controller.catalogos.length > 0;
                                              return Row(
                                                children: [
                                                  Text(
                                                    edit ? "Editar" : "Inserir",
                                                    style: textTheme.bodyText2!.copyWith(color: AppColors.primary, fontSize: 18),
                                                  ),
                                                  const HorizontalSizedBox(),
                                                  Icon(
                                                    edit ? Icons.edit : Icons.add_circle_outline,
                                                    color: AppColors.primary,
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const VerticalSizedBox(),
                                    Expanded(
                                      child: Observer(builder: (_) {
                                        if (controller.catalogos.isNotEmpty) {
                                          return CatalogoGridView(
                                            itemCount: controller.catalogos.length,
                                            itemBuilder: (_, i) {
                                              final CatalogoStore cat = controller.catalogos[i];
                                              return CatalogoGridTile(
                                                image: cat.foto,
                                                title: cat.titulo!,
                                                subtitle: cat.dataCriado!.formated,
                                              );
                                            },
                                          );
                                        } else {
                                          return Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.assignment_late_outlined),
                                                const HorizontalSizedBox(),
                                                Text(
                                                  "Nem um cat??logo inserido!",
                                                  style: textTheme.bodyText1,
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 150,
                          child: AppBarDefault(
                            backgroundColorBackButton: AppColors.opaci.withOpacity(0.4),
                            actionsWidgets: [
                              Visibility(
                                visible: controller.cameraStore.hasBackAndFront,
                                child: CircleButtonAppBar(
                                  color: AppColors.opaci.withOpacity(0.4),
                                  messageTooltip: "Inverter c??mera",
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
                  ),
                  Padding(
                    padding: const MarginButtonWithoutScaffold(),
                    child: ElevatedButtonDefault(
                      child: Text("Iniciar Live"),
                      onPressed: () async {
                        try {
                          await controller.initLive(context);
                        } catch (e) {
                          ErrorDialog.show(context: context, content: e.toString());
                        }
                      },
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
}
