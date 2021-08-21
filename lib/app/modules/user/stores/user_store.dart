import 'dart:typed_data';

import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  String? id;

  @observable
  String? nome;

  @observable
  String? descricao;

  @observable
  DateTime? dataNascimento;

  @observable
  String? cpfCnpj;

  @observable
  Uint8List? foto;

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

  @action
  void setNome(String? value) => nome = value;

  @action
  void setDescricao(String? value) => descricao = value;

  @action
  void setDataNascimento(DateTime? value) => dataNascimento = value;

  @action
  void setCpfCnpj(String? value) => cpfCnpj = value;

  @action
  void setFoto(Uint8List? value) => foto = value;

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

  @computed
  bool get equalsSenha => senha == confirmarSenha;

  _UserStore(
    this.id,
    this.nome,
    this.descricao,
    this.dataNascimento,
    this.cpfCnpj,
    this.foto,
    this.username,
    this.email,
    this.telefone,
    this.cep,
    this.cidade,
    this.senha,
  );

  UserModel toModel() {
    return UserModel(
      id,
      nome,
      descricao,
      dataNascimento,
      cpfCnpj,
      foto,
      username,
      email,
      telefone,
      cep,
      cidade,
      senha,
    );
  }
}
