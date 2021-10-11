import 'package:strapen_app/app/modules/live/models/live_model.dart';

abstract class LiveFactory {
  static LiveModel newModel() {
    return LiveModel(
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    );
  }
}