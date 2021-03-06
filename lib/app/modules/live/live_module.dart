import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_info_controller.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_select_controller.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/catalogo_repository.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';
import 'package:strapen_app/app/modules/chat/repositories/chat_repository.dart';
import 'package:strapen_app/app/modules/chat/repositories/ichat_repository.dart';
import 'package:strapen_app/app/modules/live/constants/routes.dart';
import 'package:strapen_app/app/modules/live/controllers/live_controller.dart';
import 'package:strapen_app/app/modules/live/pages/live_assistir_page.dart';
import 'package:strapen_app/app/modules/live/pages/live_create_page.dart';
import 'package:strapen_app/app/modules/live/pages/live_primeira_page.dart';
import 'package:strapen_app/app/modules/live/pages/live_transmitir_page.dart';
import 'package:strapen_app/app/modules/live/repositories/ilive_repository.dart';
import 'package:strapen_app/app/modules/live/repositories/live_repository.dart';
import 'package:strapen_app/app/modules/live/services/ilive_service.dart';
import 'package:strapen_app/app/modules/live/services/live_service.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_info_controller.dart';
import 'package:strapen_app/app/modules/produto/repositories/iproduto_repository.dart';
import 'package:strapen_app/app/modules/produto/repositories/produto_repository.dart';
import 'package:strapen_app/app/modules/reserva/repositories/ireserva_repository.dart';
import 'package:strapen_app/app/modules/reserva/repositories/reserva_repository.dart';
import 'package:strapen_app/app/modules/user/controllers/user_controller.dart';
import 'package:strapen_app/app/modules/user/repositories/iseguidor_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/seguidor_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';

class LiveModule extends Module {
  @override
  final List<Bind> binds = [
    ///Repositories
    Bind((i) => LiveRepository(i.get<ICatalogoRepository>(), i.get<ISeguidorRepository>())),
    Bind((i) => UserRepository(i.get<SessionPreferences>())),
    Bind((i) => SeguidorRepository()),
    Bind((i) => CatalogoRepository()),
    Bind((i) => ProdutoRepository()),
    Bind((i) => ChatRepository()),
    Bind((i) => ReservaRepository()),

    ///Services
    Bind((i) => LiveService(i.get<ILiveRepository>())),

    ///Controllers
    Bind((i) => LiveController(
          i.get<AppController>(),
          i.get<ILiveService>(),
          i.get<IUserRepository>(),
          i.get<IChatRepository>(),
          i.get<IProdutoRepository>(),
          i.get<ICatalogoRepository>(),
          i.get<IReservaRepository>(),
        )),
    Bind((i) => CatalogoInfoController(i.get<ICatalogoRepository>())),
    Bind((i) => ProdutoInfoController(i.get<IReservaRepository>(), i.get<AppController>())),
    Bind((i) => UserController(i.get<ISeguidorRepository>(), i.get<IReservaRepository>(), i.get<ILiveService>(), i.get<AppController>())),
    Bind((i) => CatalogoSelectController(i.get<ICatalogoRepository>(), i.get<AppController>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(LIVE_TRANSMITIR_ROUTE, child: (_, args) => LiveTransmitirPage()),
    ChildRoute(LIVE_ASSISTIR_ROUTE, child: (_, args) => LiveAssistirPage(model: args.data)),
    ChildRoute(LIVE_CREATE_ROUTE, child: (_, args) => LiveCreatePage()),
    ChildRoute(LIVE_PRIMEIRA_ROUTE, child: (_, args) => LivePrimeiraPage()),
  ];
}
