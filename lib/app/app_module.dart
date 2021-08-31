import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/auth/auth_module.dart';
import 'package:strapen_app/app/modules/auth/constants/routes.dart';
import 'package:strapen_app/app/modules/auth/repositories/auth_repository.dart';
import 'package:strapen_app/app/modules/auth/repositories/iauth_repository.dart';
import 'package:strapen_app/app/modules/catalogo/catalogo_module.dart';
import 'package:strapen_app/app/modules/catalogo/constants/routes.dart';
import 'package:strapen_app/app/modules/home/constants/routes.dart';
import 'package:strapen_app/app/modules/home/home_module.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/modules/produto/produto_module.dart';
import 'package:strapen_app/app/modules/splash/splash_module.dart';
import 'package:strapen_app/app/modules/start/constants/routes.dart';
import 'package:strapen_app/app/modules/start/start_module.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
    Bind((i) => UserRepository(i.get<SessionPreferences>())),
    Bind((i) => AuthRepository(i.get<IUserRepository>(), i.get<SessionPreferences>())),
    Bind.singleton((i) => AppController(i.get<IAuthRepository>(), i.get<SessionPreferences>())),
    Bind.lazySingleton((i) => SessionPreferences()),
    Bind.singleton((i) => RouteObserver<PageRoute>())
  ];

  @override
  List<ModularRoute> get routes => [
    ModuleRoute(Modular.initialRoute, module: SplashModule()),
    ModuleRoute(AUTH_ROUTE, module: AuthModule()),
    ModuleRoute(START_ROUTE, module: StartModule()),
    ModuleRoute(HOME_ROUTE, module: HomeModule()),
    ModuleRoute(CATALOGO_ROUTE, module: CatalogoModule()),
    ModuleRoute(PRODUTO_ROUTE, module: ProdutoModule()),
  ];
}
