import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/live/controllers/live_create_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/padding/magin_button_without_scaffold.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/horizontal_sized_box.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/catalogo_grid_tile.dart';
import 'package:strapen_app/app/shared/extensions/datetime_extension.dart';

class LiveCreatePage extends StatefulWidget {
  @override
  _LiveCreatePageState createState() => _LiveCreatePageState();
}

class _LiveCreatePageState extends ModularState<LiveCreatePage, LiveCreateController> {
  @override
  void initState() {
    super.initState();
    controller.load(context);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              children: [
                Padding(
                  padding: const PaddingScaffold(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const VerticalSizedBox(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text("Catálogos", style: textTheme.headline1!.copyWith(fontWeight: FontWeight.w600)),
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
                        child: Observer(
                          builder: (_) => GridView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: controller.catalogos.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.68,
                            ),
                            itemBuilder: (_, i) {
                              final CatalogoModel cat = controller.catalogos[i];
                              return CatalogoGridTile(
                                image: cat.foto,
                                title: cat.descricao!,
                                subtitle: cat.dataCriado!.formated,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: AppBarDefault(
                    actionsWidgets: [
                      CircleButtonAppBar(
                        child: Icon(
                          Icons.camera_front,
                          color: Colors.white,
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
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
