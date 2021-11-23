import 'package:strapen_app/app/modules/auth/models/auth_model.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/shared/interfaces/repository_interface.dart';

abstract class IAuthRepository implements IRepository<AuthModel> {
  Future<UserModel?> login(AuthModel model);
  Future<bool> logout({AuthModel? model, bool deleteSession});
  Future<bool> checkSession(AuthModel model);
}