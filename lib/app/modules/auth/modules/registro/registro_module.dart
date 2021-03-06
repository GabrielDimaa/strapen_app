import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/constants/routes.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_concluido_page.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_page1.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_page2.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_page3.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_page4.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_page5.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_page6.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_page7.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_page8.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';

class RegistroModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => UserRepository(i.get<SessionPreferences>())),
    Bind((i) => RegistroController(i.get<IUserRepository>(), i.get<AppController>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => RegistroPage1()),
    ChildRoute(REGISTRO2_ROUTE, child: (_, args) => RegistroPage2()),
    ChildRoute(REGISTRO3_ROUTE, child: (_, args) => RegistroPage3()),
    ChildRoute(REGISTRO4_ROUTE, child: (_, args) => RegistroPage4()),
    ChildRoute(REGISTRO5_ROUTE, child: (_, args) => RegistroPage5()),
    ChildRoute(REGISTRO6_ROUTE, child: (_, args) => RegistroPage6()),
    ChildRoute(REGISTRO7_ROUTE, child: (_, args) => RegistroPage7(model: args.data)),
    ChildRoute(REGISTRO8_ROUTE, child: (_, args) => RegistroPage8()),
    ChildRoute(REGISTRO_CONCLUIDO_ROUTE, child: (_, args) => RegistroConcluidoPage()),
  ];
}