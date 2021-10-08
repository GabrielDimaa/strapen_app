import 'package:strapen_app/app/modules/live/models/live_model.dart';

class LiveDemonstracaoModel {
  //Live de usuários que o mesmo seguem
  List<LiveModel>? livesSeguindo;
  //Live de usuários aleatórios no app
  List<LiveModel>? livesOutros;

  LiveDemonstracaoModel(this.livesSeguindo, this.livesOutros);
}