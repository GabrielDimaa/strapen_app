import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/user/constants/columns.dart';
import 'package:strapen_app/app/modules/user/factories/user_factory.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/modules/user/stores/user_store.dart';
import 'package:strapen_app/app/shared/components/dialog/loading_dialog.dart';
import 'package:strapen_app/app/shared/interfaces/default_controller_interface.dart';

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
  Future<void> salvarNovaSenha(BuildContext context) async {
    try {
      await LoadingDialog.show(context, "Salvando nova senha...", () async {
        await _userRepository.updateSenha(userStore.toModel());

        Modular.to.pop();
      });
    } catch (e) {
      rethrow;
    }
  }

  @action
  Future<void> salvarDadosPessoais(BuildContext context) async {
    try {
      await LoadingDialog.show(context, "Salvando dados pessoais...", () async {
        UserModel model = userStore.toModel();

        await _userRepository.updateDadosPessoais(model);
        _appController.setUserModel(model);

        Modular.to.pop();
      });
    } catch (e) {
      rethrow;
    }
  }

  @action
  void focusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
