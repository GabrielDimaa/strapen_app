class SessionPreferencesModel {
  String? userId;

  String? username;
  String? email;

  String? senha;
  String? sessionToken;

  bool isFirstLive = true;

  bool get isNull => this.userId == null || this.username == null || this.email == null || this.senha == null || this.sessionToken == null;

  SessionPreferencesModel(this.userId, this.username, this.email, this.senha, this.sessionToken, this.isFirstLive);
}