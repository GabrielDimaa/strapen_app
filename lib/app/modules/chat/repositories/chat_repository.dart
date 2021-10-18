import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/chat/constants/columns.dart';
import 'package:strapen_app/app/modules/chat/models/chat_model.dart';
import 'package:strapen_app/app/modules/chat/repositories/ichat_repository.dart';
import 'package:strapen_app/app/modules/live/constants/columns.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/modules/live/repositories/live_repository.dart';
import 'package:strapen_app/app/modules/user/constants/columns.dart';
import 'package:strapen_app/app/modules/user/repositories/user_repository.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';
import 'package:strapen_app/app/shared/utils/connectivity_utils.dart';
import 'package:strapen_app/app/shared/utils/parse_errors_utils.dart';

class ChatRepository implements IChatRepository {
  @override
  String className() => "Chat";

  String messageError() => "Houve um erro ao enviar comentário.\nSe o erro persistir reinicie o aplicativo!";

  @override
  void validate(ChatModel model) {
    if (model.comentario.isNullOrEmpty()) throw Exception(messageError);
    if (model.user?.id == null) throw Exception(messageError);
    if (model.live?.id == null) throw Exception(messageError);
  }

  @override
  ParseObject toParseObject(ChatModel model) {
    ParseObject parseObject = ParseObject(className())
      ..set<String?>(CHAT_ID_COLUMN, model.id)
      ..set<String>(CHAT_COMENTARIO_COLUMN, model.comentario!)
      ..set<ParseUser>(
        CHAT_USER_COLUMN,
        ParseUser(null, null, null)..set(USER_ID_COLUMN, model.user!.id!),
      )
      ..set<ParseObject>(CHAT_LIVE_COLUMN, ParseObject(LiveRepository(null, null).className())..set(LIVE_ID_COLUMN, model.live!.id));

    return parseObject;
  }

  @override
  ChatModel toModel(ParseObject e) {
    return ChatModel(
      e.get<String>(CHAT_ID_COLUMN),
      e.get<String>(CHAT_COMENTARIO_COLUMN),
      UserRepository(null).toModel(e.get(CHAT_USER_COLUMN)),
      LiveRepository(null, null).toModel(e.get(CHAT_LIVE_COLUMN)),
    );
  }

  Future<void> sendComentario(ChatModel model) async {
    try {
      await ConnectivityUtils.hasInternet();
      validate(model);

      ParseObject parseChat = toParseObject(model);
      ParseResponse response = await parseChat.save();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject? parseResponse = (response.results)?.first;

      String? id = parseResponse?.get<String>(CHAT_ID_COLUMN);

      if (id != null) throw Exception(messageError());

      return;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  QueryBuilder<ParseObject> queryBuilder(LiveModel liveModel) {
    return QueryBuilder(ParseObject(className()))
      ..whereEqualTo(
        CHAT_LIVE_COLUMN,
        (ParseObject(LiveRepository(null, null).className())..set(CHAT_ID_COLUMN, liveModel.id)).toPointer(),
      )
      ..orderByAscending(CHAT_CREATED_COLUMN)
      ..includeObject([CHAT_USER_COLUMN, CHAT_LIVE_COLUMN]);
  }
}
