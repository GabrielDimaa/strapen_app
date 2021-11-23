import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/auth/constants/routes.dart';
import 'package:strapen_app/app/modules/auth/repositories/iauth_repository.dart';
import 'package:strapen_app/app/modules/user/constants/routes.dart';
import 'package:strapen_app/app/shared/components/dialog/dialog_default.dart';
import 'package:strapen_app/app/shared/components/dialog/loading_dialog.dart';

part 'configuracoes_controller.g.dart';

class ConfiguracoesController = _ConfiguracoesController with _$ConfiguracoesController;

abstract class _ConfiguracoesController with Store {
  final IAuthRepository _authRepository;

  _ConfiguracoesController(this._authRepository);

  @action
  Future<void> toMeuPerfil() async {
    await Modular.to.pushNamed(USER_ROUTE);
  }

  @action
  Future<void> toEditarDadosPessoais() async {
    await Modular.to.pushNamed(USER_ROUTE + USER_DADOS_PESSOAIS_ROUTE);
  }

  @action
  Future<void> toAlterarSenha() async {
    await Modular.to.pushNamed(USER_ROUTE + USER_SENHA_ROUTE);
  }

  @action
  Future<void> logout(BuildContext context) async {
    await DialogDefault.show(
      context: context,
      title: const Text("Sair"),
      content: const Text("Ao sair, seus dados de autenticatição não serão mais lembrados quando entrar no Strapen."),
      actions: [
        TextButton(
          child: Text("Confirmar"),
          onPressed: () async {
            try {
              await LoadingDialog.show(context, "Saindo...", () async {
                await _authRepository.logout();
              });
            } finally {
              Modular.to.navigate(AUTH_ROUTE);
            }
          },
        ),
      ],
    );
  }
}
