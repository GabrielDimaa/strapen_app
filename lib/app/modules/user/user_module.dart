import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/user/constants/routes.dart';
import 'package:strapen_app/app/modules/user/controllers/user_editar_controller.dart';
import 'package:strapen_app/app/modules/user/pages/user_dados_pessoais_page.dart';
import 'package:strapen_app/app/modules/user/pages/user_page.dart';
import 'package:strapen_app/app/modules/user/pages/user_senha_page.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';

class UserModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => UserRepository(i.get<SessionPreferences>())),
    Bind((i) => UserEditarController(
          i.get<IUserRepository>(),
          i.get<AppController>(),
          i.get<SessionPreferences>(),
        )),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(USER_ROUTE, child: (_, args) => UserPage()),
    ChildRoute(USER_DADOS_PESSOAIS_ROUTE, child: (_, args) => UserDadosPessoaisPage()),
    ChildRoute(USER_SENHA_ROUTE, child: (_, args) => UserSenhaPage()),
  ];
}
