import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/catalogo_repository.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';
import 'package:strapen_app/app/modules/live/constants/routes.dart';
import 'package:strapen_app/app/modules/live/controllers/live_assistir_controller.dart';
import 'package:strapen_app/app/modules/live/controllers/live_transmitir_controller.dart';
import 'package:strapen_app/app/modules/live/controllers/live_create_controller.dart';
import 'package:strapen_app/app/modules/live/controllers/live_inserir_catalogos_controller.dart';
import 'package:strapen_app/app/modules/live/pages/live_create_page.dart';
import 'package:strapen_app/app/modules/live/pages/live_inserir_catalogos_page.dart';
import 'package:strapen_app/app/modules/live/pages/live_transmitir_page.dart';
import 'package:strapen_app/app/modules/live/pages/live_primeira_page.dart';
import 'package:strapen_app/app/modules/live/repositories/ilive_repository.dart';
import 'package:strapen_app/app/modules/live/repositories/live_repository.dart';
import 'package:strapen_app/app/modules/live/services/ilive_service.dart';
import 'package:strapen_app/app/modules/live/services/live_service.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';

class LiveModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => CatalogoRepository()),
    Bind((i) => UserRepository(i.get<SessionPreferences>())),
    Bind((i) => LiveRepository()),
    Bind((i) => LiveService(i.get<ILiveRepository>())),
    Bind((i) => LiveTransmitirController(i.get<ILiveService>())),
    Bind((i) => LiveAssistirController()),
    Bind((i) => LiveCreateController(i.get<AppController>(), i.get<ILiveService>(), i.get<IUserRepository>())),
    Bind((i) => LiveInserirCatalogosController(i.get<ICatalogoRepository>(), i.get<LiveCreateController>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(LIVE_TRANSMITIR_ROUTE, child: (_, args) => LiveTransmitirPage(cameraDirection: args.data)),
    ChildRoute(LIVE_ASSISTIR_ROUTE, child: (_, args) => LiveTransmitirPage(cameraDirection: args.data)),
    ChildRoute(LIVE_CREATE_ROUTE, child: (_, args) => LiveCreatePage()),
    ChildRoute(LIVE_PRIMEIRA_ROUTE, child: (_, args) => LivePrimeiraPage()),
    ChildRoute(LIVE_INSERIR_CATALOGO_ROUTE, child: (_, args) => LiveInserirCatalogosPage()),
  ];
}