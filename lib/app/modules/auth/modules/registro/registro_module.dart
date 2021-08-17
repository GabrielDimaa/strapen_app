import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_page1.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_page2.dart';
import 'package:strapen_app/app/shared/routes/routes.dart';

class RegistroModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => RegistroController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => RegistroPage1()),
    ChildRoute(REGISTRO2_ROUTE, child: (_, args) => RegistroPage2())
  ];
}