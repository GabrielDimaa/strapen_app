import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/home/controllers/home_controller.dart';
import 'package:strapen_app/app/modules/home/pages/home_page.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => HomeController(i.get<SessionPreferences>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => HomePage()),
  ];
}