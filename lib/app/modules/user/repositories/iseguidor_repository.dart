import 'package:strapen_app/app/modules/user/models/seguidor_model.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/shared/interfaces/repository_interface.dart';

abstract class ISeguidorRepository implements IRepository<SeguidorModel> {
  Future<bool> seguir(UserModel user, UserModel seguirUser);
  Future<bool> deixarSeguir(UserModel user, UserModel seguirUser);
  Future<bool> isSeguindo(UserModel user, UserModel seguirUser);
  Future<int> getCountSeguidores(String idUser);
  Future<int> getCountSeguindo(String idUser);
  ///Retorna apenas os ids dos usuários
  Future<List<String>> getAllSeguindo(String idUser);
}