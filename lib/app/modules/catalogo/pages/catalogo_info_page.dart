import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/catalogo/components/catalogo_widget.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_info_controller.dart';
import 'package:strapen_app/app/modules/catalogo/factories/catalogo_factory.dart';
import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/app_bar_default.dart';
import 'package:strapen_app/app/shared/components/app_bar_default/widgets/editar_app_bar_widget.dart';
import 'package:strapen_app/app/shared/components/loading/circular_loading.dart';

class CatalogoInfoPage extends StatefulWidget {
  final CatalogoModel model;

  const CatalogoInfoPage({required this.model});

  @override
  _CatalogoInfoPageState createState() => _CatalogoInfoPageState();
}

class _CatalogoInfoPageState extends State<CatalogoInfoPage> {
  final CatalogoInfoController controller = Modular.get<CatalogoInfoController>();

  @override
  void initState() {
    super.initState();
    controller.setCatalogoStore(CatalogoFactory.fromModel(widget.model));
    controller.load(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(
        title: Text("Catálogo"),
        onPressedBackButton: () => Modular.to.pop(controller.catalogoStore!.toModel()),
        actionsWidgets: [
          EditarAppBarWidget(onTap: () async => await controller.editarCatalogo()),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (controller.loading) {
            return CircularLoading();
          } else {
            return Observer(
              builder: (_) => CatalogoWidget(),
            );
          }
        },
      ),
    );
  }
}
