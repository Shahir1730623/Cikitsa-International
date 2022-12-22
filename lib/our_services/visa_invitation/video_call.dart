import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:app/doctor_screens/doctor_upload_prescription.dart';
import 'package:app/main_screen.dart';
import 'package:app/our_services/doctor_live_consultation/uploading_prescription.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../../global/global.dart';

const appId = "dda00641d5894ee0b40aec14845f364b";
//const token = "007eJxTYCjZ331FJM9yAnvIg94grsz+g/PytjC5fJZLWbp6+12N2bkKDCkpiQYGZiaGKaYWliapqQZJJgaJqcmGJhYmpmnGZiZJbBJlyQ2BjAxflHgZGKEQxGdhKEktLmFgAAAErx3G";
//const channel = "test";

class AgoraScreen extends StatefulWidget {
  const AgoraScreen({Key? key}) : super(key: key);

  @override
  State<AgoraScreen> createState() => _AgoraScreenState();
}

class _AgoraScreenState extends State<AgoraScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine agoraEngine;
  bool muted = false;// uid of the local user

  //int tokenRole = 1; // use 1 for Host/Broadcaster, 2 for Subscriber/Audience
  String serverUrl = "https://agora-token-service-production-0ad7.up.railway.app"; // The base URL to your token server, for example "https://agora-token-service-production-92ff.up.railway.app"
  int tokenExpireTime = 300; // Expire time in Seconds.
  bool isTokenExpiring = false; // Set to true when the token is about to expire

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext( //Initialize Agora Engine with the appID
      appId: appId,
    ));

    Random random = Random();
    int uid = random.nextInt(100);

    // Register the event handler to receive Agora Engine callbacks
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          Fluttertoast.showToast(msg: "local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },

        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          Fluttertoast.showToast(msg: "remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },

        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          Fluttertoast.showToast(msg: "remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },


        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          Fluttertoast.showToast(msg: 'Token expiring');
          isTokenExpiring = true;
          setState(() {
            // fetch a new token when the current token is about to expire
            fetchToken(uid, channelName!, tokenRole!);
          });
        },
      ),
    );

    //Enabling the video module
    await agoraEngine.setClientRole(role: ClientRoleType.clientRoleBroadcaster); // Set Client Role
    await agoraEngine.enableVideo();
    // Start local preview
    await agoraEngine.startPreview();


    /*await agoraEngine.joinChannel(
      token: token,
      channelId: channel,
      uid: uid,
      options: const ChannelMediaOptions(),
    );*/

    if (channelName!.isEmpty) {
      Fluttertoast.showToast(msg: "Channel name is empty");
      return;
    }

    else {
      Fluttertoast.showToast(msg: "Fetching a token ...");
    }

    await fetchToken(uid, channelName!, tokenRole!);
    //join();
  }

  /*void join() async {
    await agoraEngine.startPreview();
  }*/

  Future<void> fetchToken(int uid, String channelName, int tokenRole) async {
    //Fluttertoast.showToast(msg: "Server Url: ${serverUrl}channelName: ${channelName}uid: ${uid}Expiry: $tokenExpireTime");
    String url = "$serverUrl/rtc/$channelName/${tokenRole.toString()}/uid/${uid.toString()}?expiry=${tokenExpireTime.toString()}";

    // Send the request
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      Map<String,dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      Fluttertoast.showToast(msg: 'Token Received: $newToken');
      // Use the token to join a channel or renew an expiring token
      setToken(newToken,uid);
    }
    else {
      Fluttertoast.showToast(msg: 'Failed to fetch a token. Make sure that your server URL is valid');
    }
  }

  void setToken(String newToken,int uid) async {
    String token = newToken;
    if (isTokenExpiring) {
      // Renew the token
      agoraEngine.renewToken(token);
      isTokenExpiring = false;
      Fluttertoast.showToast(msg: "Token renewed");
    }

    else {
      // Join a channel.
      Fluttertoast.showToast(msg: "Joining a channel...");

      // Set channel options including the client role and channel profile
      /*ChannelMediaOptions options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      );*/

      await agoraEngine.joinChannel(
        token: token,
        channelId: channelName!,
        uid: uid,
        options: const ChannelMediaOptions(),
      );

    }
  }



  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    agoraEngine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    agoraEngine.switchCamera();
  }

  /*void leave() {
    setState(() {
      _localUserJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
  }*/

  // Clean up the resources when you leave
  @override
  void dispose() async {
    agoraEngine.release();
    super.dispose();
  }


  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [

          Center(
            child: _remoteVideo(),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                  child: _localPreview()
              ),
            ),
          ),

          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: _onToggleMute,
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: muted ? Colors.blueAccent : Colors.white,
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    muted ? Icons.mic_off : Icons.mic,
                    color: muted ? Colors.white : Colors.blueAccent,
                    size: 20.0,
                  ),
                ),

                RawMaterialButton(
                  onPressed: () {
                    //leave();
                    Timer(const Duration(seconds: 1),()  {
                      if(loggedInUser == "Patient"){
                        if(selectedService == "Doctor Live Consultation"){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const UploadingPrescription()), (Route<dynamic> route) => false);
                        }

                        else if(selectedService == "CI Consultation"){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (Route<dynamic> route) => false);
                        }

                        else{
                          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const UploadingPrescription()), (Route<dynamic> route) => false);
                        }

                      }


                      else {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DoctorUploadPrescription()), (Route<dynamic> route) => false);
                      }

                    });

                  },
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.redAccent,
                  padding: const EdgeInsets.all(15.0),
                  child: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 35.0,
                  ),
                ),

                RawMaterialButton(
                  onPressed: _onSwitchCamera,
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.white,
                  padding: const EdgeInsets.all(12.0),
                  child: const Icon(
                    Icons.switch_camera,
                    color: Colors.blueAccent,
                    size: 20.0,
                  ),
                ),

              ],
            ),
          )

        ],
      ),
    );
  }

  // Display local video preview
  Widget _localPreview() {
    if (_localUserJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    }

    else {
      return const CircularProgressIndicator();
    }
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: channelName),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}