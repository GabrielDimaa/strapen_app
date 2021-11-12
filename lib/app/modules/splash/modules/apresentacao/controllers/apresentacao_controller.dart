import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/auth/constants/routes.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/constants/routes.dart';
import 'package:strapen_app/app/modules/splash/modules/apresentacao/constants/routes.dart';

part 'apresentacao_controller.g.dart';

class ApresentacaoController = _ApresentacaoController with _$ApresentacaoController;

abstract class _ApresentacaoController with Store {
  @action
  void toNextApresentacao() {
    Modular.to.pushNamed(APRESENTACAO_ROUTE + APRESENTACAO_CONTA_ROUTE);
  }

  @action
  void toAuth() {
    Modular.to.navigate(AUTH_ROUTE);
  }

  @action
  void toRegistro() {
    Modular.to.navigate(AUTH_ROUTE + REGISTRO_ROUTE);
  }
}