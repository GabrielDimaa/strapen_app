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
import 'package:strapen_app/app/modules/live/repositories/ilive_repository.dart';
import 'package:strapen_app/app/modules/live/repositories/live_repository.dart';
import 'package:strapen_app/app/modules/live/services/ilive_service.dart';
import 'package:strapen_app/app/modules/live/services/live_service.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';

class LiveModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => CatalogoRepository()),
    Bind((i) => LiveRepository()),
    Bind((i) => LiveService(i.get<ILiveRepository>())),
    Bind((i) => LiveController(i.get<ILiveService>())),
    Bind((i) => LiveCreateController(i.get<AppController>(), i.get<ILiveService>(), i.get<SessionPreferences>())),
    Bind((i) => LiveInserirCatalogosController(i.get<ICatalogoRepository>(), i.get<LiveCreateController>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => LivePage(cameraDirection: args.data)),
    ChildRoute(LIVE_CREATE_ROUTE, child: (_, args) => LiveCreatePage()),
    ChildRoute(LIVE_PRIMEIRA_ROUTE, child: (_, args) => LivePrimeiraPage()),
    ChildRoute(LIVE_INSERIR_CATALOGO_ROUTE, child: (_, args) => LiveInserirCatalogosPage()),
  ];
}