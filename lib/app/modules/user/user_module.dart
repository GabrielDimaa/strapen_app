import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/user/constants/routes.dart';
import 'package:strapen_app/app/modules/user/controllers/user_controller.dart';
import 'package:strapen_app/app/modules/user/controllers/user_editar_controller.dart';
import 'package:strapen_app/app/modules/user/pages/user_dados_pessoais_page.dart';
import 'package:strapen_app/app/modules/user/pages/user_editar_perfil_page.dart';
import 'package:strapen_app/app/modules/user/pages/user_page.dart';
import 'package:strapen_app/app/modules/user/pages/user_senha_page.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';

class UserModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => UserRepository(i.get<SessionPreferences>())),
    Bind((i) => UserController(i.get<AppController>())),
    Bind((i) => UserEditarController(i.get<IUserRepository>(), i.get<AppController>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(USER_ROUTE, child: (_, args) => UserPage(model: args.data)),
    ChildRoute(USER_EDITAR_PERFIL_ROUTE, child: (_, args) => UserEditarPerfilPage()),
    ChildRoute(USER_DADOS_PESSOAIS_ROUTE, child: (_, args) => UserDadosPessoaisPage()),
    ChildRoute(USER_SENHA_ROUTE, child: (_, args) => UserSenhaPage()),
  ];
}
