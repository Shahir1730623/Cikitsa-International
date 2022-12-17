import 'package:app/doctor_screens/doctor_dashboard.dart';
import 'package:app/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../assistants/assistant_methods.dart';
import '../global/global.dart';

class PrescriptionDialogDoctor extends StatefulWidget {
  const PrescriptionDialogDoctor({Key? key}) : super(key: key);

  @override
  State<PrescriptionDialogDoctor> createState() => _PrescriptionDialogDoctorState();
}

class _PrescriptionDialogDoctorState extends State<PrescriptionDialogDoctor> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 250),
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children: [
            SizedBox(height: height * 0.04,),

            Text(
              "Your prescription is\nbeing uploaded",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),

            SizedBox(height: height * 0.025,),

            Text(
              'Note',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),
            ),

            SizedBox(height: height * 0.005,),

            Text(
              'Patient will receive notification once your\nprescription is uploaded',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12
              ),
            ),

            SizedBox(height: height * 0.03,),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: ()  {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context){
                        return ProgressDialog(message: "Please wait...");
                      }
                  );

                  sendPrescriptionUploadNotificationToUser(){
                    FirebaseDatabase.instance.ref()
                        .child("Users")
                        .child(userId!)
                        .child("tokens").once().then((snapData){
                      DataSnapshot snapshot = snapData.snapshot;
                      if(snapshot.value != null){
                        String deviceRegistrationToken = snapshot.value.toString();
                        // send notification now
                        AssistantMethods.sendPushNotificationToPatientNow(deviceRegistrationToken,context);
                        Fluttertoast.showToast(msg: "Notification sent successfully");
                      }

                      else{
                        Fluttertoast.showToast(msg: "Error sending notifications");
                      }
                    });

                  }

                  consultationId = null;
                  patientId = null;
                  userId = null;
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DoctorDashboard()), (Route<dynamic> route) => false);
                },

                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),

                child: Text(
                  ("Return"),
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
