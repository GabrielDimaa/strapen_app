import 'dart:typed_data';

import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';

part 'catalogo_store.g.dart';

class CatalogoStore = _CatalogoStore with _$CatalogoStore;

abstract class _CatalogoStore with Store {
  int? id;

  @observable
  String? titulo;

  @observable
  String? descricao;

  @observable
  Uint8List? foto;

  @observable
  DateTime? dataCriado;

  @observable
  UserModel? user;

  @action
  void setTitulo(String? value) => titulo = value;

  @action
  void setDescricao(String? value) => descricao = value;

  @action
  void setFoto(Uint8List? value) => foto = value;

  @action
  void setDataCriado(DateTime? value) => dataCriado = value;

  @action
  void setUser(UserModel? value) => user = value;

  _CatalogoStore(
    this.id,
    this.titulo,
    this.descricao,
    this.foto,
    this.dataCriado,
    this.user,
  );
}
