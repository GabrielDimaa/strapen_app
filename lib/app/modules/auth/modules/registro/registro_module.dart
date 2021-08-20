import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/controllers/registro_controller.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_concluido_page.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_page1.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_page2.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_page3.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_page4.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_page5.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/pages/registro_page6.dart';
import 'package:strapen_app/app/shared/routes/routes.dart';

class RegistroModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => RegistroController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => RegistroPage1()),
    ChildRoute(REGISTRO2_ROUTE, child: (_, args) => RegistroPage2()),
    ChildRoute(REGISTRO3_ROUTE, child: (_, args) => RegistroPage3()),
    ChildRoute(REGISTRO4_ROUTE, child: (_, args) => RegistroPage4()),
    ChildRoute(REGISTRO5_ROUTE, child: (_, args) => RegistroPage5()),
    ChildRoute(REGISTRO6_ROUTE, child: (_, args) => RegistroPage6()),
    ChildRoute(REGISTRO_CONCLUIDO_ROUTE, child: (_, args) => RegistroConcluidoPage()),
  ];
}