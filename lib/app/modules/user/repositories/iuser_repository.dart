import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/shared/interfaces/repository_interface.dart';

abstract class IUserRepository implements IRepository<UserModel> {
  Future<UserModel> save(UserModel model);
  Future<bool> existsData(String column, String data, String messageError);
  Future<void> saveSession(UserModel model, String senha, String session);
}