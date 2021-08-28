import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/catalogo/constants/routes.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_list_controller.dart';
import 'package:strapen_app/app/modules/catalogo/pages/catalogo_list_page.dart';
import 'package:strapen_app/app/modules/configuracoes/configuracoes_module.dart';
import 'package:strapen_app/app/modules/configuracoes/constants/routes.dart';
import 'package:strapen_app/app/modules/home/constants/routes.dart';
import 'package:strapen_app/app/modules/home/home_module.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_list_controller.dart';
import 'package:strapen_app/app/modules/produto/pages/produto_list_page.dart';
import 'package:strapen_app/app/modules/start/controllers/start_controller.dart';
import 'package:strapen_app/app/modules/start/pages/start_page.dart';

class StartModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => StartController()),
    Bind((i) => ProdutoListController()),
    Bind((i) => CatalogoListController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => StartPage(), children: [
      ModuleRoute(HOME_ROUTE, module: HomeModule()),
      ChildRoute(PRODUTO_ROUTE, child: (_, args) => ProdutoListPage()),
      ChildRoute(CATALOGO_ROUTE, child: (_, args) => CatalogoListPage()),
      ModuleRoute(CONFIGURACOES_ROUTE, module: ConfiguracoesModule()),
    ]),
  ];
}