import 'dart:typed_data';

class UserModel {
  int? id;

  String? nome;
  String? descricao;
  DateTime? dataNascimento;
  String? cpfCnpj;
  Uint8List? foto;

  String? userName;
  String? email;
  String? telefone;

  String? cep;
  String? cidade;

  String? senha;

  UserModel(
    this.id,
    this.nome,
    this.descricao,
    this.dataNascimento,
    this.cpfCnpj,
    this.foto,
    this.userName,
    this.email,
    this.telefone,
    this.cep,
    this.cidade,
    this.senha,
  );
}
