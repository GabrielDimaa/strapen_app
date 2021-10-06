import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/shared/interfaces/repository_interface.dart';

abstract class IUserRepository implements IRepository<UserModel> {
  Future<UserModel> save(UserModel model);
  Future<UserModel> getById(String? id);
  Future<void> update(UserModel model);
  Future<bool> existsData(String column, String data, String messageError);
  Future<void> saveSession(UserModel model, String senha, String session);
  Future<void> updateFirstLive(String id);
  Future<void> updateSenha(UserModel model);
  Future<UserModel?> fetchSearch(String text);
  Future<void> seguirUser(UserModel text);
}