import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/shared/routes/routes.dart';

part 'apresentacao_controller.g.dart';

class ApresentacaoController = _ApresentacaoController with _$ApresentacaoController;

abstract class _ApresentacaoController with Store {
  @action
  void toNextApresentacao() {
    Modular.to.navigate(APRESENTACAO_ROUTE + APRESENTACAO_CONTA_ROUTE);
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