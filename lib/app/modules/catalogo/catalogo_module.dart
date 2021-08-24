import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/catalogo/pages/catalogo_page.dart';

class CatalogoModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => CatalogoPage()),
  ];
}