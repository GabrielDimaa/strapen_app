import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/home/controllers/home_controller.dart';
import 'package:strapen_app/app/modules/home/pages/home_page.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => HomeController(i.get<AppController>()), export: true),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => HomePage()),
  ];
}