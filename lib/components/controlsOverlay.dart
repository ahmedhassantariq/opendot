
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class ControlsOverlay extends StatelessWidget {
  ControlsOverlay({
    super.key,
    required this.controller
  });

  late VideoProgressIndicator videoProgressIndicator;
  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.5,
    0.75,
    1.0,
    1.25,
    1.5,
    2.0
  ];

  String _printDuration(Duration duration) {
    String negativeSign = duration.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    return "$negativeSign${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  final VideoPlayerController controller;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  // Using less vertical padding as the text is also longer
                  // horizontally, so it feels like it would need more spacing
                  // horizontally (matching the aspect ratio of the video).
                  vertical: 6,
                  horizontal: 4,
                ),
                child: GestureDetector(
                  onTap: (){controller.value.isPlaying ? controller.pause() : controller.play();},
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 50),
                    reverseDuration: const Duration(milliseconds: 200),
                    child: controller.value.isPlaying ?
                    const Icon(Icons.pause,color: Colors.white,)
                        : const Icon(Icons.play_arrow,color: Colors.white,),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  // Using less vertical padding as the text is also longer
                  // horizontally, so it feels like it would need more spacing
                  // horizontally (matching the aspect ratio of the video).
                  vertical: 6,
                  horizontal: 4,
                ),
                child: GestureDetector(
                  onTap: (){controller.value.volume==1?controller.setVolume(0):controller.setVolume(1);},
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 50),
                    reverseDuration: const Duration(milliseconds: 200),
                    child: controller.value.volume==1 ?
                         const Icon(Icons.volume_up,color: Colors.white,)
                        : const Icon(Icons.volume_off,color: Colors.white,),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 9,
                  horizontal: 4,
                ),
                child: Text(_printDuration(controller.value.position), style: const TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),

        Align(alignment: Alignment.bottomCenter,
          child: videoProgressIndicator = VideoProgressIndicator(
            controller,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              backgroundColor: Colors.black,
              bufferedColor: Colors.grey,
              playedColor: Colors.red,
            ),
          )),
        Align(
          alignment: Alignment.bottomRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x', style: const TextStyle(color: Colors.white),),
            ),
          ),
        ),
      ],
    );
  }
}