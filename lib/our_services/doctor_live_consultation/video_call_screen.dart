import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {

  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: 'dda00641d5894ee0b40aec14845f364b',
      channelName: 'App Test' ,

    ),
    enabledPermission: [Permission.camera,Permission.microphone],

    agoraChannelData: AgoraChannelData(
      videoEncoderConfiguration: VideoEncoderConfiguration(
        orientationMode: VideoOutputOrientationMode.Adaptative
      )
    )
  );



  // Initializing Agora Client
  Future<void> initAgora() async{
    await client.initialize();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAgora();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text("Live Video Consultation"),
        ),

        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: client,
                showNumberOfUsers: true,
                showAVState: true,
                disabledVideoWidget: Container(
                  decoration:  const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/Logo.png",
                        width: 200,
                      )
                    ],
                  ),
                ),
              ),
              AgoraVideoButtons(
                client: client,
                enabledButtons:  [
                  BuiltInButtons.toggleMic,
                  BuiltInButtons.callEnd,
                  BuiltInButtons.toggleCamera,
                  BuiltInButtons.switchCamera,
                ],
              )
            ],
          ),
        ),


      ),
    );
  }
}
