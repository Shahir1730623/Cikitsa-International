import 'dart:async';

import 'package:app/global/global.dart';
import 'package:app/widgets/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common_screens/coundown_screen.dart';
import '../our_services/visa_invitation/video_call.dart';

class PushNotificationDialogTalkToDoctorNow extends StatefulWidget {

  //String? consultationId;
  //PushNotificationDialogTalkToDoctorNow({this.consultationId});

  @override
  State<PushNotificationDialogTalkToDoctorNow> createState() => _PushNotificationDialogTalkToDoctorNowState();
}

class _PushNotificationDialogTalkToDoctorNowState extends State<PushNotificationDialogTalkToDoctorNow> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 240),
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children: [
            SizedBox(height: height * 0.05,),

            Text(
              "You have meeting with\na patient now",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),

            SizedBox(height: height * 0.03,),

            Text(
              'Please press the button "Talk Now" to start the video call',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),
            ),

            SizedBox(height: height * 0.05,),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: ()  {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context){
                        return ProgressDialog(message: "Please wait...");
                      }
                  );

                  Timer(const Duration(seconds: 5),()  {
                    Navigator.pop(context);
                    channelName = consultationId;
                    Fluttertoast.showToast(msg: channelName!);
                    tokenRole = 1;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AgoraScreen()));
                });
              },

                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),

                icon: const Icon(Icons.video_call),
                label: Text(
                  "Talk to Patient Now",
                  style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
