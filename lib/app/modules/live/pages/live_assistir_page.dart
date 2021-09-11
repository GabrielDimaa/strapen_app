import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LiveAssistirPage extends StatefulWidget {
  const LiveAssistirPage({Key? key}) : super(key: key);

  @override
  _LiveAssistirPageState createState() => _LiveAssistirPageState();
}

class _LiveAssistirPageState extends State<LiveAssistirPage> {
  final videoPlayerController = VideoPlayerController.network('https://stream.mux.com/sDFj027otNOlswGiRxWMNgfQG02NNG1TqJ4C8VGtMOe018.m3u8');
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User"),
      ),
      body: Container(
        child: Chewie(controller: chewieController!),
      ),
    );
  }
}
