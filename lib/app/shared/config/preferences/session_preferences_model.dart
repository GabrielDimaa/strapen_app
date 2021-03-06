class SessionPreferencesModel {
  String? userId;

  String? username;
  String? email;

  String? senha;
  String? sessionToken;

  bool get isNull => this.userId == null || this.username == null || this.email == null || this.senha == null || this.sessionToken == null;
  bool get withoutSenha => (this.userId != null && this.username != null && this.email != null && this.sessionToken != null) && this.senha == null;

  SessionPreferencesModel(this.userId, this.username, this.email, this.senha, this.sessionToken);
}