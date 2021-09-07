import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/catalogo_repository.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';
import 'package:strapen_app/app/modules/live/constants/routes.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/modules/live/controllers/live_create_controller.dart';
import 'package:strapen_app/app/modules/live/controllers/live_inserir_catalogos_controller.dart';
import 'package:strapen_app/app/modules/live/pages/live_create_page.dart';
import 'package:strapen_app/app/modules/live/pages/live_inserir_catalogos_page.dart';
import 'package:strapen_app/app/modules/live/pages/live_page.dart';
import 'package:strapen_app/app/modules/live/pages/live_primeira_page.dart';

class LiveModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => CatalogoRepository()),
    Bind((i) => LiveController()),
    Bind((i) => LiveCreateController(i.get<AppController>())),
    Bind((i) => LiveInserirCatalogosController(i.get<ICatalogoRepository>(), i.get<LiveCreateController>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => LivePage(cameraStore: args.data)),
    ChildRoute(LIVE_CREATE_ROUTE, child: (_, args) => LiveCreatePage()),
    ChildRoute(LIVE_PRIMEIRA_ROUTE, child: (_, args) => LivePrimeiraPage()),
    ChildRoute(LIVE_INSERIR_CATALOGO_ROUTE, child: (_, args) => LiveInserirCatalogosPage()),
  ];
}