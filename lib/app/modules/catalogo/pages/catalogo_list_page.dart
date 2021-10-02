import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_widget.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_list_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/fab_default/fab_default.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';
import 'package:strapen_app/app/shared/components/padding/padding_list.dart';
import 'package:strapen_app/app/shared/components/widgets/empty_list_widget.dart';
import 'package:strapen_app/app/shared/components/widgets/list_tile_widget.dart';
import 'package:strapen_app/app/shared/extensions/datetime_extension.dart';
import 'package:transparent_image/transparent_image.dart';

class CatalogoListPage extends StatefulWidget {
  @override
  _CatalogoListPageState createState() => _CatalogoListPageState();
}

class _CatalogoListPageState extends State<CatalogoListPage> {
  final CatalogoListController controller = Modular.get<CatalogoListController>();

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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FABDefault(
          onPressed: () async => await controller.toCatalogoCreate(),
          icon: Icons.add_circle_outline,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const PaddingList(),
              child: Observer(builder: (_) {
                if (controller.loading) {
                  return const CircularLoading();
                } else {
                  if (controller.catalogos?.isEmpty ?? true) {
                    return const EmptyListWidget(
                      message: "Sua lista está vazia. Crie catálogos para serem exibidos nas Lives.",
                    );
                  } else {
                    return RefreshIndicator(
                      onRefresh: controller.atualizarListaCatalogos,
                      child: ListView.builder(
                          itemCount: controller.catalogos!.length,
                          itemBuilder: (_, i) {
                            final cat = controller.catalogos![i];
                            return ListTileWidget(
                              leadingImage: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: cat.foto,
                                height: 64,
                                width: 64,
                              ),
                              title: Text(cat.titulo!),
                              onTap: () async => await controller.toCatalogoInfo(cat),
                              subtitle: Column(
                                children: [
                                  Text(
                                    cat.dataCriado!.formated,
                                    style: textTheme.bodyText2!.copyWith(color: AppColors.primary),
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  }
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
