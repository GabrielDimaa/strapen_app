import 'package:strapen_app/app/modules/catalogo/models/catalogo_model.dart';
import 'package:strapen_app/app/modules/user/models/user_model.dart';

class LiveModel {
  String? id;

  String? streamKey;
  String? liveId;
  String? playBackId;
  bool? finalizada;

  List<CatalogoModel>? catalogos;

  UserModel? user;

  LiveModel(
    this.id,
    this.liveId,
    this.streamKey,
    this.playBackId,
    this.finalizada,
    this.catalogos,
    this.user,
  );
}
