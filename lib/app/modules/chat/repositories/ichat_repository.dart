import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/chat/models/chat_model.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/shared/interfaces/repository_interface.dart';

abstract class IChatRepository implements IRepository<ChatModel> {
  Future<void> sendComentario(ChatModel model);
  QueryBuilder<ParseObject> queryBuilder(LiveModel liveModel);
}