import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_create_controller.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_info_controller.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_list_controller.dart';
import 'package:strapen_app/app/modules/produto/controllers/produto_select_controller.dart';
import 'package:strapen_app/app/modules/produto/pages/produto_create_page.dart';
import 'package:strapen_app/app/modules/produto/pages/produto_info_page.dart';
import 'package:strapen_app/app/modules/produto/pages/produto_list_page.dart';
import 'package:strapen_app/app/modules/produto/pages/produto_select_page.dart';
import 'package:strapen_app/app/modules/produto/repositories/iproduto_repository.dart';
import 'package:strapen_app/app/modules/produto/repositories/produto_repository.dart';

class ProdutoModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => ProdutoRepository()),
    Bind((i) => ProdutoListController(i.get<IProdutoRepository>(), i.get<AppController>())),
    Bind((i) => ProdutoCreateController(i.get<IProdutoRepository>(), i.get<AppController>())),
    Bind((i) => ProdutoSelectController(i.get<IProdutoRepository>(), i.get<AppController>())),
    Bind((i) => ProdutoInfoController()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => ProdutoListPage()),
    ChildRoute(PRODUTO_CREATE_ROUTE, child: (_, args) => ProdutoCreatePage()),
    ChildRoute(PRODUTO_SELECT_ROUTE, child: (_, args) => ProdutoSelectPage(produtos: args.data)),
    ChildRoute(PRODUTO_INFO_ROUTE, child: (_, args) => ProdutoInfoPage(produtoModel: args.data['produtoModel'], reservaModel: args.data['reservaModel'])),
  ];
}