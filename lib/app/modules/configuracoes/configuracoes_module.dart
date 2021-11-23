import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/repositories/auth_repository.dart';
import 'package:strapen_app/app/modules/auth/repositories/iauth_repository.dart';
import 'package:strapen_app/app/modules/configuracoes/controllers/configuracoes_controller.dart';
import 'package:strapen_app/app/modules/configuracoes/pages/configuracoes_page.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';

class ConfiguracoesModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => UserRepository(i.get<SessionPreferences>())),
    Bind((i) => AuthRepository(i.get<IUserRepository>(), i.get<SessionPreferences>())),
    Bind((i) => ConfiguracoesController(i.get<IAuthRepository>()), export: true),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => ConfiguracoesPage()),
  ];
}