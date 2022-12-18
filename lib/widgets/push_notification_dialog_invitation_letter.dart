import 'dart:async';

import 'package:app/our_services/visa_invitation/visa_invitation_details.dart';
import 'package:app/widgets/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PushNotificationDialogInvitationLetter extends StatefulWidget {
  const PushNotificationDialogInvitationLetter({Key? key}) : super(key: key);

  @override
  State<PushNotificationDialogInvitationLetter> createState() => _PushNotificationDialogInvitationLetterState();
}

class _PushNotificationDialogInvitationLetterState extends State<PushNotificationDialogInvitationLetter> {
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
              "Your invitation letter is uploaded",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),

            SizedBox(height: height * 0.03,),

            Text(
              'Please press the button "Check Letter" to get redirected to the download page',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),
            ),

            SizedBox(height: height * 0.08,),

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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const VisaInvitationDetails()));
                  });
                },

                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),

                icon: const Icon(Icons.video_call),
                label: Text(
                  "Check Letter",
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
