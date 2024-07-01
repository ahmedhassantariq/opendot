import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../../models/userDataModel.dart';
import '../../../services/chat/signaling.dart';


class VideoCallReceive extends StatefulWidget {
  final UserCredentialsModel receiver;
  final String roomId;
  final bool isVideo;

  const VideoCallReceive({
    required this.receiver,
    required this.roomId,
    required this.isVideo,
    super.key,
  });

  @override
  _VideoCallReceiveState createState() => _VideoCallReceiveState();
}

class _VideoCallReceiveState extends State<VideoCallReceive> {
  WebRtcManager signaling = WebRtcManager();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool frontCamera = false;
  bool isMic = true;
  bool isVideo = true;
  bool isLocalScreen = true;

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });
    signaling.joinRoom(widget.roomId, _localRenderer, _remoteRenderer);

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.receiver.email.toString()),
          backgroundColor: Colors.lightGreen,
          leading: IconButton(onPressed: (){Navigator.pop(context);signaling.hangUp(_localRenderer);}, icon: const Icon(Icons.arrow_back, color: Colors.white,)),
          actions: [
            (defaultTargetPlatform == TargetPlatform.android)
                ?
            IconButton(onPressed: (){signaling?.switchCamera(); frontCamera = !frontCamera;}, icon: const Icon(Icons.switch_camera, color: Colors.white,))
                :
            const SizedBox(),
            IconButton(onPressed: (){isMic = !isMic; setState(() {signaling?.muteMic(isMic);});}, icon: isMic ? const Icon(Icons.mic, color: Colors.white,): const Icon(Icons.mic_off, color: Colors.red,)),
            IconButton(onPressed: (){isVideo = !isVideo; setState(() {
              signaling?.muteVideo(isVideo);
            });}, icon: isVideo ? const Icon(Icons.videocam_outlined, color: Colors.white,): const Icon(Icons.videocam_off_outlined, color: Colors.red,)),
            IconButton(onPressed: (){isLocalScreen = !isLocalScreen; setState(() {});}, icon: isLocalScreen ? const Icon(Icons.video_camera_front_outlined, color: Colors.white,): const Icon(Icons.videocam_off_outlined, color: Colors.red,)),

          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.red,
          child: CupertinoButton(
              onPressed: (){
                signaling.hangUp(_localRenderer);
                Navigator.pop(context);
              }, child: const Text("Hang Up", style: TextStyle(color: Colors.white),)),
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children:<Widget> [
                    Container(
                      child: RTCVideoView(
                        _remoteRenderer,
                        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      ),
                    ),
                    isLocalScreen ?  Positioned(
                      bottom: 0,
                      right: 0,
                      child: SizedBox(
                          height: 200,
                          width: 150,
                          child: isVideo ? RTCVideoView(
                            _localRenderer,
                            mirror: defaultTargetPlatform == TargetPlatform.android ? !frontCamera : true,
                            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                          ) : const Icon(Icons.videocam_off, color: Colors.white)),
                    ) : const SizedBox(),
                  ],
                ),
              ),
            ),

            SizedBox(height: 8)
          ],
        ),
      ),
    );
  }
}