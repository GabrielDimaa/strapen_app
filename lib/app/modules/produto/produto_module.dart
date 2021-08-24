import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/produto/pages/produto_page.dart';

class ProdutoModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => ProdutoPage()),
  ];
}