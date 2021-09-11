import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/app_controller.dart';
import 'package:strapen_app/app/modules/user/factories/user_factory.dart';
import 'package:strapen_app/app/modules/user/repositories/iuser_repository.dart';
import 'package:strapen_app/app/modules/user/stores/user_store.dart';
import 'package:strapen_app/app/shared/components/dialog/loading_dialog.dart';
import 'package:strapen_app/app/shared/config/preferences/session_preferences.dart';

part 'user_editar_controller.g.dart';

class UserEditarController = _UserEditarController with _$UserEditarController;

abstract class _UserEditarController with Store {
  final IUserRepository _userRepository;
  final AppController _appController;
  final SessionPreferences _sessionPreferences;

  _UserEditarController(this._userRepository, this._appController, this._sessionPreferences);

  @observable
  UserStore userStore = UserFactory.newStore();

  @observable
  bool loading = false;

  @action
  void setUserStore(UserStore value) => userStore = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  Future<void> load() async {
    try {
      setLoading(true);

      setUserStore(UserFactory.fromModel(_appController.userModel!));
    } finally {
      setLoading(false);
    }
  }

  @action
  Future<void> salvarNovaSenha(BuildContext context) async {
    try {
      await LoadingDialog.show(context, "Salvando nova senha...", () async {
        await _userRepository.updateSenha(userStore.toModel());
        await _sessionPreferences.updateSenha(userStore.senha!);

        Modular.to.pop();
      });
    } catch (e) {
      rethrow;
    }
  }
}
