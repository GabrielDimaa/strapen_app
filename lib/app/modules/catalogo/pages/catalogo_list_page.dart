import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_list_controller.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/fab_default/fab_default.dart';
import 'package:strapen_app/app/shared/components/padding/padding_scaffold.dart';
import 'package:strapen_app/app/shared/components/sized_box/vertical_sized_box.dart';
import 'package:strapen_app/app/shared/components/widgets/empty_list_widget.dart';

class CatalogoListPage extends StatefulWidget {
  @override
  _CatalogoListPageState createState() => _CatalogoListPageState();
}

class _CatalogoListPageState extends ModularState<CatalogoListPage, CatalogoListController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: Text("Catálogos")),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: FABDefault(
          onPressed: () async => await controller.toCreateCatalogo(),
          icon: Icons.add_circle_outline,
        ),
      ),
      body: Padding(
        padding: const PaddingScaffold(),
        child: EmptyListWidget(
          message: "Sua lista está vazia. Crie um catálogo de produtos para ser exibido em uma Live.",
        ),
      ),
    );
  }
}
