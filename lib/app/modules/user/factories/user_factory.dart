import 'package:strapen_app/app/modules/user/stores/user_store.dart';

abstract class UserFactory {
  static UserStore novo() {
    return UserStore(
      null,
      null,
      null,
      null,
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