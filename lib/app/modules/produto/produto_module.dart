import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_create_controller.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_list_controller.dart';
import 'package:strapen_app/app/modules/produto/pages/produto_list_page.dart';

class ProdutoModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => ProdutoListController()),
    Bind((i) => ProdutoCreateController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => ProdutoListPage()),
    ChildRoute(PRODUTO_CREATE_ROUTE, child: (_, args) => ProdutoListPage()),
  ];
}