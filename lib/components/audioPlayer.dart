import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';


class AudioPlayer extends StatefulWidget {
  const AudioPlayer({super.key});

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}


class _AudioPlayerState extends State<AudioPlayer> {
  final assetsAudioPlayer = AssetsAudioPlayer();
  play() async {
    try {
      await assetsAudioPlayer.open(
        Audio.network("https://firebasestorage.googleapis.com/v0/b/opendot-0.appspot.com/o/images%2Fcat-meow-6226.mp3?alt=media&token=6a80a1d2-9c14-44de-8418-3d35c8cb5a2e"),
      );
    } catch (t) {
      //mp3 unreachable
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: IconButton(onPressed: (){play();},icon: const Icon(Icons.play_arrow),),);
  }
}
