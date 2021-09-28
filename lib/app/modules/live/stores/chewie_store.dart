import 'package:chewie/chewie.dart';
import 'package:mobx/mobx.dart';
import 'package:strapen_app/app/shared/apis/mux_api.dart';
import 'package:video_player/video_player.dart';

part 'chewie_store.g.dart';

class ChewieStore = _ChewieStore with _$ChewieStore;

abstract class _ChewieStore with Store {
  _ChewieStore();

  @observable
  ChewieController? chewieController;

  @observable
  VideoPlayerController? videoPlayerController;

  @action
  void setChewieController(ChewieController? value) => chewieController = value;

  @action
  void setVideoPlayerController(VideoPlayerController value) => videoPlayerController = value;

  @action
  Future<void> getInstance(String dataSource, double aspectRatio) async {
    setVideoPlayerController(VideoPlayerController.network(MuxApi.urlStream(dataSource)));
    await videoPlayerController!.initialize();

    setChewieController(ChewieController(
      videoPlayerController: videoPlayerController!,
      aspectRatio: aspectRatio,
      autoPlay: true,
      showOptions: false,
      showControls: false,
      isLive: true,
      allowFullScreen: false,
    ));
  }
}