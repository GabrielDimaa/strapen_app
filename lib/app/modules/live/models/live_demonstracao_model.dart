import 'package:strapen_app/app/modules/live/models/live_model.dart';

class LiveDemonstracaoModel {
  //Live de usuários que o mesmo está seguindo
  List<LiveModel>? livesSeguindo;
  //Live de usuários aleatórios
  List<LiveModel>? livesOutros;

  LiveDemonstracaoModel(this.livesSeguindo, this.livesOutros);
}