import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_create_controller.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_list_controller.dart';
import 'package:strapen_app/app/modules/catalogo/pages/catalogo_create_page.dart';
import 'package:strapen_app/app/modules/catalogo/pages/catalogo_list_page.dart';
import 'package:strapen_app/app/shared/routes/routes.dart';

class CatalogoModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => CatalogoListController()),
    Bind((i) => CatalogoCreateController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => CatalogoListPage()),
    ChildRoute(CATALOGO_CREATE_ROUTE, child: (_, args) => CatalogoCreatePage()),
  ];
}
