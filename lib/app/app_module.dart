import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/auth/auth_module.dart';
import 'package:strapen_app/app/modules/auth/repository/auth_repository.dart';
import 'package:strapen_app/app/modules/auth/repository/auth_repository_interface.dart';
import 'package:strapen_app/app/modules/home/home_module.dart';
import 'package:strapen_app/app/modules/splash/modules/apresentacao/apresentacao_module.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository_interface.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';
import 'package:strapen_app/app/shared/routes/routes.dart';
import 'modules/splash/splash_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
    Bind((i) => UserRepository(i.get<SessionPreferences>())),
    Bind((i) => AuthRepository(i.get<IUserRepository>(), i.get<SessionPreferences>())),
    Bind.singleton((i) => AppController(i.get<IAuthRepository>(), i.get<SessionPreferences>())),
    Bind.lazySingleton((i) => SessionPreferences()),
  ];

  @override
  List<ModularRoute> get routes => [
    ModuleRoute(Modular.initialRoute, module: SplashModule()),
    ModuleRoute(APRESENTACAO_ROUTE, module: ApresentacaoModule()),
    ModuleRoute(AUTH_ROUTE, module: AuthModule()),
    ModuleRoute(HOME_ROUTE, module: HomeModule()),
  ];
}
