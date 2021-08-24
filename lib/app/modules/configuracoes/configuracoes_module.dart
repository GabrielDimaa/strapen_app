import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/configuracoes/pages/configuracoes_page.dart';

class ConfiguracoesModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => ConfiguracoesPage()),
  ];
}