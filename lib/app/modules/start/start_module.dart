import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/catalogo/catalogo_module.dart';
import 'package:strapen_app/app/modules/configuracoes/configuracoes_module.dart';
import 'package:strapen_app/app/modules/home/home_module.dart';
import 'package:strapen_app/app/modules/produto/produto_module.dart';
import 'package:strapen_app/app/modules/start/controllers/start_controller.dart';
import 'package:strapen_app/app/modules/start/pages/start_page.dart';
import 'package:strapen_app/app/shared/routes/routes.dart';

class StartModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => StartController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => StartPage(), children: [
      ModuleRoute(HOME_ROUTE, module: HomeModule()),
      ModuleRoute(PRODUTO_ROUTE, module: ProdutoModule()),
      ModuleRoute(CATALOGO_ROUTE, module: CatalogoModule()),
      ModuleRoute(CONFIGURACOES_ROUTE, module: ConfiguracoesModule()),
    ]),
  ];
}