class UserModel {
  String? id;

  String? nome;
  String? descricao;
  DateTime? dataNascimento;
  String? cpfCnpj;
  dynamic foto;

  String? username;
  String? email;
  String? telefone;

  String? cep;
  String? cidade;

  String? senha;

  bool? firstLive;

  UserModel(
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
    this.firstLive,
  );
}
