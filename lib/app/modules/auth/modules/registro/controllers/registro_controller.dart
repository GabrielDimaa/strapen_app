import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/auth/constants/routes.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/components/foto_dialog.dart';
import 'package:strapen_app/app/modules/auth/modules/registro/constants/routes.dart';
import 'package:strapen_app/app/modules/start/constants/routes.dart';
import 'package:strapen_app/app/modules/user/factories/user_factory.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/modules/user/stores/user_store.dart';
import 'package:strapen_app/app/shared/components/dialog/error_dialog.dart';
import 'package:strapen_app/app/shared/utils/image_picker_utils.dart';

part 'registro_controller.g.dart';

class RegistroController = _RegistroController with _$RegistroController;

abstract class _RegistroController with Store {
  final IUserRepository _userRepository;
  final AppController _appController;

  _RegistroController(this._userRepository, this._appController);

  @observable
  UserStore userStore = UserFactory.newStore();

  @observable
  bool loading = false;

  @observable
  bool visibleSenha = false;

  @observable
  bool visibleConfirmarSenha = false;

  @observable
  bool showErrorEqualsSenha = false;

  @action
  void setVisibleSenha(bool value) => visibleSenha = value;

  @action
  void setVisibleConfirmarSenha(bool value) => visibleConfirmarSenha = value;

  @action
  void setShowErrorEqualsSenha(bool value) => showErrorEqualsSenha = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  Future<void> onSavedForm(BuildContext context, GlobalKey<FormState> formKey, VoidCallback onPressed) async {
    try {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();

        if (userStore.equalsSenha)
          onPressed.call();
        else
          throw Exception("As senhas não conferem!");
      }
    } catch (e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }

  @action
  void focusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @action
  Future<void> getImagePicker(bool isCamera) async {
    File? image = await ImagePickerUtils.getImagePicker(isCamera);
    if (image == null) return;

    userStore.setFoto(image);
    Modular.to.pop();
  }

  @action
  Future<void> existsData(String column, String data, String messageError) async {
    try {
      setLoading(true);
      await _userRepository.existsData(column, data, messageError);
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> nextPage(int page) async {
    await Modular.to.pushNamed(AUTH_ROUTE + REGISTRO_ROUTE + REGISTRO_ROUTE + page.toString());
  }

  @action
  Future<void> finalizarCadastro(BuildContext context) async {
    try {
      setLoading(true);

      UserModel model = userStore.toModel();
      model = await _userRepository.save(model, withFoto: false);
      _appController.setUserModel(model);
      //Seta o usuário no appController após ser salvo

      userStore.id = model.id;
      model.foto = userStore.foto;

      try {
        model = await _userRepository.saveFoto(model);

        //Seta a foto recém salva
        _appController.userModel!.foto = model.foto;

        Modular.to.navigate(AUTH_ROUTE + REGISTRO_ROUTE + REGISTRO_CONCLUIDO_ROUTE);
      } catch (e) {
        setLoading(false);
        await FotoDialog.show(context);
      }
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> salvarFoto(BuildContext context) async {
    try {
      setLoading(true);

      final UserModel model = await _userRepository.saveFoto(userStore.toModel());
      _appController.setUserModel(userStore.toModel()..foto = model.foto);

      Modular.to.navigate(AUTH_ROUTE + REGISTRO_ROUTE + REGISTRO_CONCLUIDO_ROUTE);
    } finally {
      setLoading(false);
    }
  }

  @action
  void toAuth() => Modular.to.navigate(AUTH_ROUTE);

  @action
  void toHome() => Modular.to.navigate(START_ROUTE);
}
