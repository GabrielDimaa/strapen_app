import 'package:strapen_app/app/modules/user/models/user_model.dart';

class LiveModel {
  String? id;

  String? streamKey;
  String? liveId;
  String? playBackId;

  UserModel? user;

  LiveModel(this.id, this.liveId, this.streamKey, this.playBackId, this.user);
}