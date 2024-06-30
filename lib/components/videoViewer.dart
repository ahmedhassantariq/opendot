import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'controlsOverlay.dart';

class VideoViewer extends StatefulWidget {
  final String url;
  const VideoViewer({
    super.key,
    required this.url});

  @override
  State<VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<VideoViewer> {
  late VideoPlayerController _controller;
  late VideoProgressIndicator videoProgressIndicator;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(
            widget.url))
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(true);
          _controller.addListener(() {setState(() {});});
        });
      });
    videoProgressIndicator = VideoProgressIndicator(
      _controller,
      allowScrubbing: true,
      colors: const VideoProgressColors(
        backgroundColor: Colors.black,
        bufferedColor: Colors.grey,
        playedColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if(_controller.value.isInitialized) {
      _controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(

      key: ObjectKey(_controller),
      onVisibilityChanged: (info) {
        if (info.visibleFraction < 5 && mounted) {
          _controller.pause();
        }
        if(info.visibleFraction == 1 && mounted){
          _controller.play();
        }
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(8.0)),
        // color: Colors.black,
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .width * 9.0 / 16.0,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : Container(),
              ControlsOverlay(controller: _controller),
              videoProgressIndicator
            ],
          )
      ),
    );;
  }
}
