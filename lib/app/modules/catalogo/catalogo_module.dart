import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/catalogo/constants/routes.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_create_controller.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_info_controller.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_list_controller.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_select_controller.dart';
import 'package:strapen_app/app/modules/catalogo/pages/catalogo_create_page.dart';
import 'package:strapen_app/app/modules/catalogo/pages/catalogo_info_page.dart';
import 'package:strapen_app/app/modules/catalogo/pages/catalogo_list_page.dart';
import 'package:strapen_app/app/modules/catalogo/pages/catalogo_select_page.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/catalogo_repository.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_select_controller.dart';
import 'package:strapen_app/app/modules/produto/repositories/iproduto_repository.dart';
import 'package:strapen_app/app/modules/produto/repositories/produto_repository.dart';

class CatalogoModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => CatalogoRepository()),
    Bind((i) => ProdutoRepository()),
    Bind((i) => CatalogoListController(i.get<ICatalogoRepository>(), i.get<AppController>())),
    Bind((i) => CatalogoCreateController(i.get<ICatalogoRepository>(), i.get<AppController>())),
    Bind((i) => CatalogoSelectController(i.get<ICatalogoRepository>(), i.get<AppController>())),
    Bind((i) => CatalogoInfoController(i.get<ICatalogoRepository>())),
    Bind((i) => ProdutoSelectController(i.get<IProdutoRepository>(), i.get<AppController>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => CatalogoListPage()),
    ChildRoute(CATALOGO_CREATE_ROUTE, child: (_, args) => CatalogoCreatePage(catalogo: args.data)),
    ChildRoute(CATALOGO_SELECT_ROUTE, child: (_, args) => CatalogoSelectPage(catalogos: args.data)),
    ChildRoute(CATALOGO_INFO_ROUTE, child: (_, args) => CatalogoInfoPage(model: args.data)),
  ];
}
