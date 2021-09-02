import 'package:flutter_modular/flutter_modular.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/catalogo/constants/routes.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_create_controller.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_inserir_produtos_controller.dart';
import 'package:strapen_app/app/modules/catalogo/controllers/catalogo_list_controller.dart';
import 'package:strapen_app/app/modules/catalogo/pages/catalogo_create_page.dart';
import 'package:strapen_app/app/modules/catalogo/pages/catalogo_inserir_produtos.dart';
import 'package:strapen_app/app/modules/catalogo/pages/catalogo_list_page.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/catalogo_repository.dart';
import 'package:strapen_app/app/modules/catalogo/repositories/icatalogo_repository.dart';
import 'package:strapen_app/app/modules/produto/repositories/iproduto_repository.dart';
import 'package:strapen_app/app/modules/produto/repositories/produto_repository.dart';

class CatalogoModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => ProdutoRepository()),
    Bind((i) => CatalogoRepository()),
    Bind((i) => CatalogoListController(i.get<ICatalogoRepository>(), i.get<AppController>())),
    Bind((i) => CatalogoCreateController(i.get<ICatalogoRepository>(), i.get<AppController>())),
    Bind((i) => CatalogoInserirProdutosController(i.get<CatalogoCreateController>(), i.get<IProdutoRepository>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => CatalogoListPage()),
    ChildRoute(CATALOGO_CREATE_ROUTE, child: (_, args) => CatalogoCreatePage()),
    ChildRoute(CATALOGO_INSERIR_PRODUTO_ROUTE, child: (_, args) => CatalogoInserirProdutosPage()),
  ];
}
