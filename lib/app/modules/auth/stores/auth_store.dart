import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/auth/models/auth_model.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  @observable
  String? email;

  @observable
  String? senha;

  @observable
  String? sessionToken;

  @action
  void setEmail(String? value) => email = value;

  @action
  void setSenha(String? value) => senha = value;

  @action
  void setSessionToken(String? value) => sessionToken = value;

  _AuthStore(
    this.email,
    this.senha,
    this.sessionToken,
  );

  AuthModel toModel() {
    return AuthModel(
      email,
      senha,
      sessionToken,
    );
  }
}
