import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/catalogo/components/catalogo_widget.dart';
import 'package:strapen_app/app/modules/catalogo/components/criar_catalogo_widget.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_create_controller.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_info_controller.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/remover_app_bar_widget.dart';

class CatalogoCreatePage extends StatefulWidget {
  final CatalogoModel? catalogo;

  const CatalogoCreatePage({this.catalogo});

  @override
  _CatalogoCreatePageState createState() => _CatalogoCreatePageState();
}

class _CatalogoCreatePageState extends ModularState<CatalogoCreatePage, CatalogoCreateController> {
  final CatalogoInfoController catalogoInfoController = Modular.get<CatalogoInfoController>();

  @override
  void initState() {
    super.initState();

    controller.load(widget.catalogo);
    catalogoInfoController.setCatalogoStore(controller.catalogoStore);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBarDefault(
          title: const Text("Catálogo"),
          actionsWidgets: [
            RemoverAppBarWidget(
              onTap: () async => await controller.remover(context),
              visible: widget.catalogo != null,
            ),
          ],
          bottomWidgets: const TabBar(
            tabs: [
              const Tab(text: "Criar"),
              const Tab(text: "Preview"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CriarCatalogoWidget(),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: CatalogoWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
