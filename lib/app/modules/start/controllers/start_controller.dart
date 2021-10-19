import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/auth/constants/routes.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/constants/routes.dart';
import 'package:strapen_app/app/modules/catalogo/constants/routes.dart';
import 'package:strapen_app/app/modules/configuracoes/constants/routes.dart';
import 'package:strapen_app/app/modules/home/constants/routes.dart';
import 'package:strapen_app/app/modules/produto/constants/routes.dart';
import 'package:strapen_app/app/modules/start/constants/index_page.dart';
import 'package:strapen_app/app/modules/start/constants/routes.dart';

part 'start_controller.g.dart';

class StartController = _StartController with _$StartController;

abstract class _StartController with Store {
  @observable
  int page = HOME_PAGE;

  @action
  void setPage(int value) => page = value;

  @action
  void toInit() {
    if (Modular.get<AppController>().userModel?.foto != null) {
      Modular.to.navigate(START_ROUTE + HOME_ROUTE);
    } else {
      Modular.to.navigate(AUTH_ROUTE + REGISTRO_ROUTE + REGISTRO6_ROUTE, arguments: Modular.get<AppController>().userModel);
    }
  }

  @action
  void toHome() {
    if (page != HOME_PAGE) {
      setPage(HOME_PAGE);
      Modular.to.navigate(START_ROUTE + HOME_ROUTE);
    }
  }

  @action
  void toProduto() {
    if (page != PRODUTO_PAGE) {
      setPage(PRODUTO_PAGE);
      Modular.to.navigate(START_ROUTE + PRODUTO_ROUTE);
    }
  }

  @action
  void toCatalogo() {
    if (page != CATALOGO_PAGE) {
      setPage(CATALOGO_PAGE);
      Modular.to.navigate(START_ROUTE + CATALOGO_ROUTE);
    }
  }

  @action
  void toConfiguracoes() {
    if (page != CONFIGURACOES_PAGE) {
      setPage(CONFIGURACOES_PAGE);
      Modular.to.navigate(START_ROUTE + CONFIGURACOES_ROUTE);
    }
  }
}