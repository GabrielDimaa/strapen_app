import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/catalogo/components/criar_catalogo_widget.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_create_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/circle_background_app_bar.dart';

class CatalogoCreatePage extends StatefulWidget {
  @override
  _CatalogoCreatePageState createState() => _CatalogoCreatePageState();
}

class _CatalogoCreatePageState extends ModularState<CatalogoCreatePage, CatalogoCreateController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBarDefault(
          title: const Text("Catálogo"),
          actionsWidgets: [
            CircleButtonAppBar(
              child: Icon(Icons.delete, color: Colors.white),
              onTap: () {},
              messageTooltip: "Remover",
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
            Center(child: Text("Ainda não implementado")),
          ],
        ),
      ),
    );
  }
}
