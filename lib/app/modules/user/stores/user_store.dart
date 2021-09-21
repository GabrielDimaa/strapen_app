import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  String? id;

  @observable
  String? nome;

  @observable
  String? bio;

  @observable
  DateTime? dataNascimento;

  @observable
  String? cpfCnpj;

  @observable
  dynamic foto;

  @observable
  String? username;

  @observable
  String? email;

  @observable
  String? telefone;

  @observable
  String? cep;

  @observable
  String? cidade;

  @observable
  String? senha;

  @observable
  String? confirmarSenha;

  @observable
  bool? firstLive;

  @action
  void setNome(String? value) => nome = value;

  @action
  void setBio(String? value) => bio = value;

  @action
  void setDataNascimento(DateTime? value) => dataNascimento = value;

  @action
  void setCpfCnpj(String? value) => cpfCnpj = value;

  @action
  void setFoto(dynamic value) => foto = value;

  @action
  void setUserName(String? value) => username = value;

  @action
  void setEmail(String? value) => email = value;

  @action
  void setTelefone(String? value) => telefone = value;

  @action
  void setCep(String? value) => cep = value;

  @action
  void setCidade(String? value) => cidade = value;

  @action
  void setSenha(String? value) => senha = value;

  @action
  void setConfirmarSenha(String? value) => confirmarSenha = value;

  @action
  void setFirstLive(bool? value) => firstLive = value;

  @computed
  bool get equalsSenha => senha == confirmarSenha;

  _UserStore(
    this.id,
    this.nome,
    this.bio,
    this.dataNascimento,
    this.cpfCnpj,
    this.foto,
    this.username,
    this.email,
    this.telefone,
    this.cep,
    this.cidade,
    this.senha,
    this.firstLive,
  );

  UserModel toModel() {
    return UserModel(
      id,
      nome,
      bio,
      dataNascimento,
      cpfCnpj,
      foto,
      username,
      email,
      telefone,
      cep,
      cidade,
      senha,
      firstLive,
    );
  }
}
