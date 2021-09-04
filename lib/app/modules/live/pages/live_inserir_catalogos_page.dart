import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/live/controllers/live_inserir_catalogos_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/button/elevated_button_default.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/padding/magin_button_without_scaffold.dart';
import 'package:strapen_app/app/shared/components/padding/padding_list.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/empty_list_widget.dart';
import 'package:strapen_app/app/shared/extensions/datetime_extension.dart';

class LiveInserirCatalogosPage extends StatefulWidget {
  const LiveInserirCatalogosPage({Key? key}) : super(key: key);

  @override
  _LiveInserirCatalogosPageState createState() => _LiveInserirCatalogosPageState();
}

class _LiveInserirCatalogosPageState extends ModularState<LiveInserirCatalogosPage, LiveInserirCatalogosController> {
  @override
  void initState() {
    super.initState();
    controller.load();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBarDefault(title: Text("Catálogos")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const VerticalSizedBox(),
          Padding(
            padding: const PaddingScaffold(),
            child: Text("Selecione os catálogos que serão exibidos na Live."),
          ),
          Expanded(
            child: Padding(
              padding: const PaddingList(),
              child: Observer(
                builder: (_) {
                  if (!controller.loading) {
                    if (controller.catalogos.isNotEmpty) {
                      return ListView.builder(
                        itemCount: controller.catalogos.length,
                        itemBuilder: (_, i) {
                          final CatalogoModel cat = controller.catalogos[i];
                          return Card(
                            color: AppColors.opaci,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Observer(
                                builder: (_) => CheckboxListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  title: Text(
                                    cat.descricao!,
                                    overflow: TextOverflow.ellipsis,
                                    style: textTheme.bodyText2,
                                  ),
                                  subtitle: Text(
                                    cat.dataCriado!.formated,
                                    style: textTheme.bodyText2!.copyWith(color: AppColors.primary),
                                  ),
                                  dense: true,
                                  secondary: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      cat.foto!,
                                      height: 42,
                                      width: 42,
                                    ),
                                  ),
                                  value: controller.catalogosSelected.any((e) => e.id == cat.id),
                                  onChanged: (value) {
                                    if (value!)
                                      controller.addCatalogosSelected(cat);
                                    else
                                      controller.removeCatalogosSelected(cat);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: EmptyListWidget(
                          message: "Crie catálogos para exibir em sua Live.",
                        ),
                      );
                    }
                  } else {
                    return const CircularLoading();
                  }
                },
              ),
            ),
          ),
          Padding(
            padding: const MarginButtonWithoutScaffold(),
            child: ElevatedButtonDefault(
              child: Text("Confirmar"),
              onPressed: () async {
                try {
                  controller.save();
                } catch (e) {
                  ErrorDialog.show(context: context, content: e.toString());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
