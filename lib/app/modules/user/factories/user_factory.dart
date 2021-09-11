import 'package:strapen_app/app/modules/user/models/user_model.dart';
import 'package:strapen_app/app/modules/user/stores/user_store.dart';

abstract class UserFactory {
  static UserStore newStore() {
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
      null,
    );
  }

  static UserModel newModel() {
    return UserModel(
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
      null,
    );
  }

  static UserStore fromModel(UserModel model) {
    return UserStore(
      model.id,
      model.nome,
      model.descricao,
      model.dataNascimento,
      model.cpfCnpj,
      model.foto,
      model.username,
      model.email,
      model.telefone,
      model.cep,
      model.cidade,
      model.senha,
      model.firstLive,
    );
  }
}