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
      tempToken: '007eJxTYOhQUZnmNqu9K8aA0S1UjJPVYz3Hyis5/E4/+6XPuXt5HVFgSElJNDAwMzFMMbWwNElNNUgyMUhMTTY0sTAxTTM2M0kyaQlLbghkZBBzesHCyACBID4Hg2NBgUJIanEJAwMAZ3AcKQ=='
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
          automaticallyImplyLeading: false,
          title: const Text("Live Video Consultation"),
        ),

        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: client,
                layoutType: Layout.floating,
                showNumberOfUsers: true,
              ),
              AgoraVideoButtons(
                client: client,
                enabledButtons: const[
                  BuiltInButtons.toggleCamera,
                  BuiltInButtons.callEnd,
                  BuiltInButtons.toggleMic,
                ],

              )
            ],
          ),
        ),


      ),
    );
  }
}
