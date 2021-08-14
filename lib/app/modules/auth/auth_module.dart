import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/controllers/auth_controller.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/registro_module.dart';
import 'package:strapen_app/app/modules/auth/pages/auth_page.dart';
import 'package:strapen_app/app/shared/routes/routes.dart';

class AuthModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => AuthController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => AuthPage()),
    ModuleRoute(REGISTRO_ROUTE, module: RegistroModule())
  ];
}
