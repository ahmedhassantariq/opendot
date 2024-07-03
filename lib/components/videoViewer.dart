import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
class VideoViewer extends StatefulWidget {
  final String url;
  const VideoViewer({
    super.key,
    required this.url});

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late VideoPlayerController _videoController;
  late ChewieController _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url))..initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      looping: true,
    );


  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ObjectKey(_chewieController),
      onVisibilityChanged: (info) {
        if (info.visibleFraction < 5 && mounted) {
          _chewieController.pause();
        }
        if(info.visibleFraction == 1 && mounted){
          _chewieController.play();
        }
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(8.0)),

          child: Chewie(controller: _chewieController)
      ),
    );
  }
}
