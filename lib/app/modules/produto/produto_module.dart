import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_create_controller.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_list_controller.dart';
import 'package:strapen_app/app/modules/produto/pages/produto_create_page.dart';
import 'package:strapen_app/app/modules/produto/pages/produto_list_page.dart';
import 'package:strapen_app/app/modules/produto/repositories/iproduto_repository.dart';
import 'package:strapen_app/app/modules/produto/repositories/produto_repository.dart';

class ProdutoModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => ProdutoRepository()),
    Bind((i) => ProdutoListController(i.get<IProdutoRepository>(), i.get<AppController>())),
    Bind((i) => ProdutoCreateController(i.get<IProdutoRepository>(), i.get<AppController>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => ProdutoListPage()),
    ChildRoute(PRODUTO_CREATE_ROUTE, child: (_, args) => ProdutoCreatePage()),
  ];
}