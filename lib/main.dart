import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:strapen_app/app/app_module.dart';
import 'app/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  final keyApplicationId = dotenv.env['PARSE_SERVER_APP_ID'];
  final keyParseServerUrl = dotenv.env['PARSE_SERVER_URL'];
  final keyClientKey = dotenv.env['PARSE_SERVER_CLIENT_KEY'];
  final keyLiveQueryUrl = dotenv.env['PARSE_SERVER_LIVE_QUERY_URL'];

  await Parse().initialize(
    keyApplicationId!,
    keyParseServerUrl!,
    clientKey: keyClientKey,
    debug: kDebugMode,
    liveQueryUrl: keyLiveQueryUrl,
    autoSendSessionId: true,
  );

  runApp(ModularApp(module: AppModule(), child: AppWidget()));
}
