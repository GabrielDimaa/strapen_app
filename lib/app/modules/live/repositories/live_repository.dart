import 'package:parse_server_sdk/parse_server_sdk.dart';
import 'package:strapen_app/app/modules/live/constants/columns.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/modules/live/repositories/ilive_repository.dart';
import 'package:strapen_app/app/modules/user/constants/columns.dart';
import 'package:strapen_app/app/modules/user/factories/user_factory.dart';
import 'package:strapen_app/app/shared/extensions/string_extension.dart';
import 'package:strapen_app/app/shared/utils/parse_errors_utils.dart';

class LiveRepository implements ILiveRepository {
  @override
  String className() => "Live";

  @override
  void validate(LiveModel model) {
    String messageError = "Houve um erro ao criar sua Live.\nSe o erro persistir reinicie o aplicativo.";
    if (model.streamKey.isNullOrEmpty()) throw Exception(messageError);
    if (model.liveId.isNullOrEmpty()) throw Exception(messageError);
    if (model.playBackId.isNullOrEmpty()) throw Exception(messageError);
  }

  @override
  ParseObject toParseObject(LiveModel model) {
    ParseObject parseObject = ParseObject(className())
      ..set<String?>(LIVE_ID_COLUMN, model.id)
      ..set<String>(LIVE_ID_LIVE_COLUMN, model.liveId!)
      ..set<String>(LIVE_STREAM_KEY_COLUMN, model.streamKey!)
      ..set<String>(LIVE_PLAYBACK_ID_COLUMN, model.playBackId!)
      ..set<ParseUser>(
        LIVE_USER_COLUMN,
        ParseUser(null, null, null)..set(USER_ID_COLUMN, model.user!.id!),
      );

    return parseObject;
  }

  @override
  LiveModel toModel(ParseObject e) {
    return LiveModel(
      e.get<String>(LIVE_ID_COLUMN),
      e.get<String>(LIVE_ID_LIVE_COLUMN),
      e.get<String>(LIVE_STREAM_KEY_COLUMN),
      e.get<String>(LIVE_PLAYBACK_ID_COLUMN),
      UserFactory.newModel()..id = e.get(LIVE_USER_COLUMN).get<String>(USER_ID_COLUMN),
    );
  }

  @override
  Future<LiveModel> save(LiveModel model) async {
    try {
      validate(model);

      ParseObject parseLive = toParseObject(model);
      ParseResponse response = await parseLive.save();

      if (!response.success) throw Exception(ParseErrorsUtils.get(response.statusCode));
      ParseObject parseResponse = (response.results as List<dynamic>).first;

      return toModel(parseResponse);
    } catch (e) {
      throw Exception(e);
    }
  }
}