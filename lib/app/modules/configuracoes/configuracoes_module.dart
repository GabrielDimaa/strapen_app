import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/configuracoes/controllers/configuracoes_controller.dart';
import 'package:strapen_app/app/modules/configuracoes/pages/configuracoes_page.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';

class ConfiguracoesModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => ConfiguracoesController(i.get<SessionPreferences>()), export: true),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => ConfiguracoesPage()),
  ];
}