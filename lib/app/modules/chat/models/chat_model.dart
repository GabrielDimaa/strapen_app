import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';

class ChatModel {
  String? id;

  String? comentario;
  UserModel? user;
  LiveModel? live;

  ChatModel(this.id, this.comentario, this.user, this.live);
}