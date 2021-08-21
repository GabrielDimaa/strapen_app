import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/shared/interfaces/repository_interface.dart';

abstract class IUserRepository implements IRepository<UserModel> {
  Future<UserModel> save(UserModel model);
}