import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/constants/routes.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/registro_module.dart';
import 'package:strapen_app/app/modules/auth/pages/auth_page.dart';
import 'package:strapen_app/app/modules/auth/repositories/auth_repository.dart';
import 'package:strapen_app/app/modules/auth/repositories/iauth_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';

class AuthModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => UserRepository(i.get<SessionPreferences>())),
    Bind((i) => AuthRepository(i.get<IUserRepository>(), i.get<SessionPreferences>())),
    Bind((i) => AuthController(i.get<IAuthRepository>(), i.get<IUserRepository>(), i.get<AppController>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => AuthPage()),
    ModuleRoute(REGISTRO_ROUTE, module: RegistroModule())
  ];
}
