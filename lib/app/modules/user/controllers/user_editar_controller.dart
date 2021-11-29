import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/user/constants/columns.dart';
import 'package:strapen_app/app/modules/user/factories/user_factory.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/modules/user/stores/user_store.dart';
import 'package:strapen_app/app/shared/components/dialog/dialog_default.dart';
import 'package:strapen_app/app/shared/components/dialog/loading_dialog.dart';
import 'package:strapen_app/app/shared/interfaces/default_controller_interface.dart';
import 'package:strapen_app/app/shared/utils/image_picker_utils.dart';

part 'user_editar_controller.g.dart';

class UserEditarController = _UserEditarController with _$UserEditarController;

abstract class _UserEditarController with Store implements IDefaultController {
  final IUserRepository _userRepository;
  final AppController _appController;

  _UserEditarController(this._userRepository, this._appController);

  @observable
  UserStore userStore = UserFactory.newStore();

  @observable
  bool loading = false;

  @action
  void setUserStore(UserStore value) => userStore = value;

  @action
  void setLoading(bool value) => loading = value;

  @override
  VoidCallback? initPage;

  @override
  void setInitPage(VoidCallback function) => initPage = function;

  @action
  Future<void> load() async {
    try {
      setLoading(true);

      setUserStore(UserFactory.fromModel(_appController.userModel!));
    } finally {
      initPage?.call();
      setLoading(false);
    }
  }

  @action
  Future<void> esqueceuSenha(BuildContext context) async {
    try {
      bool success = false;

      await LoadingDialog.show(context, "Enviando e-mail...", () async {
        await _userRepository.esqueceuSenha(userStore.email!);

        success = true;
      });

      if (success) {
        await DialogDefault.show(
          context: context,
          title: const Text("E-mail enviado"),
          content: const Text("Confira as instruções de redefinição de senha enviadas no e-mail."),
          labelButtonDefault: "Ok",
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @action
  Future<void> update(BuildContext context, String message, Function? fieldsValid) async {
    try {
      bool confirm = await DialogDefault.show(
        context: context,
        title: const Text("Alterar"),
        content: const Text("Confirme para alterar os dados da sua conta."),
        actions: [
          TextButton(
            child: const Text("Confirmar"),
            onPressed: () => Modular.to.pop(true),
          ),
        ],
      );

      if (confirm) {
        UserModel model = userStore.toModel();

        await LoadingDialog.show(context, message, () async {
          await fieldsValid?.call();

          await _userRepository.update(model);
          _appController.setUserModel(model);
        });

        Modular.to.pop(model);
      }
    } catch (e) {
      rethrow;
    }
  }

  @action
  Future<void> existsCpfCnpj() async {
    await _userRepository.existsData(USER_CPFCNPJ_COLUMN, userStore.cpfCnpj!, "Já existe esse CPF ou CNPJ cadastrado no Strapen.", id: userStore.id);
  }

  @action
  Future<void> existsTelefone() async {
    await _userRepository.existsData(USER_TELEFONE_COLUMN, userStore.telefone!, "Já existe esse número de telefone cadastrado no Strapen.", id: userStore.id);
  }

  @action
  Future<void> existsUsername() async {
    await _userRepository.existsData(USER_USERNAME_COLUMN, userStore.username!, "Nome de usuário já está em uso.", id: userStore.id);
  }

  @action
  Future<void> getImagePicker(bool isCamera) async {
    File? image = await ImagePickerUtils.getImagePicker(isCamera);
    if (image == null) return;

    userStore.setFoto(image);
    Modular.to.pop();
  }

  @action
  void focusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
