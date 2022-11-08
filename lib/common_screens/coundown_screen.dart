import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_fonts/google_fonts.dart';
import '../global/global.dart';
import '../models/ci_consultation_model.dart';
import '../models/consultation_model.dart';
import '../widgets/progress_dialog.dart';
import '../widgets/timer.dart';

class CountDownScreen extends GetView<TimerController>  {
  const CountDownScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    Get.put(TimerController());
    TimerController.context = context;

    retrieveConsultationDataFromDatabase() {
      DatabaseReference reference = FirebaseDatabase.instance.ref()
          .child("Users")
          .child(currentFirebaseUser!.uid)
          .child("patientList")
          .child(patientId!);

      /*if(selectedService == "CI Consultation"){
        reference.child("CIConsultations").child(consultationId!).once().then((dataSnap){
          DataSnapshot snapshot = dataSnap.snapshot;
          if (snapshot.exists) {
            selectedCIConsultationInfo = CIConsultationModel.fromSnapshot(snapshot);
          }

          else{
            Fluttertoast.showToast(msg: "No consultation record exist with this credentials");
          }

        });
      }*/



      if(selectedService != "CI Consultation"){
        reference.child("consultations").child(consultationId!).once().then((dataSnap){
          DataSnapshot snapshot = dataSnap.snapshot;
          if (snapshot.exists) {
            selectedConsultationInfo = ConsultationModel.fromSnapshot(snapshot);
          }

          else{
            Fluttertoast.showToast(msg: "No consultation record exist with this credentials");
          }

        });
      }
    }

    setConsultationInfoToCompleted(){
      FirebaseDatabase.instance.ref()
          .child("Users")
          .child(currentFirebaseUser!.uid)
          .child("patientList")
          .child(patientId!).child(selectedServiceDatabaseParentName!).child(consultationId!).child("consultationType").set("Completed");
    }

    WidgetsBinding.instance.addPostFrameCallback((_){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return ProgressDialog(message: "Please wait...");
          }
      );

      retrieveConsultationDataFromDatabase();
      setConsultationInfoToCompleted();

      Timer(const Duration(seconds: 1),()  {
        Navigator.pop(context);
      });
    });


    Future<bool> showExitPopup() async {
      return await showDialog(
        //show confirm dialogue
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit App'),
          content: Text('Do you want to exit an App?'),
          actions:[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              //return false when click on "NO"
              child:Text('No'),
            ),

            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              //return true when click on "Yes"
              child:Text('Yes'),
            ),

          ],
        ),
      )??false; //if showDialog had returned null, then return false
    }


    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Do not close this page",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.03,),
            Text(
              "You will automatically be redirected\nto video call",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.03,),
            Text(
              "Please wait",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black
              ),
            ),

            SizedBox(height: height * 0.05),
            Text(
              "Redirecting...",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.red
              ),
            ),

            SizedBox(height: height * 0.05),

            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color:  Color(0xFF53E5FF).withOpacity(0.5),
                shape: BoxShape.circle,
              ),

              child:Container(
                padding: EdgeInsets.all(40),
                decoration: const BoxDecoration(
                  color:  Color(0xFF53E5FF),
                  shape: BoxShape.circle,
                ),
                child: Obx(()=>Center(
                  child: Text(
                    controller.time.value,
                    style: const TextStyle(
                      fontSize: 30, color: Colors.white,
                    ),
                  ),
                )
                ),
              ),
            ),

            SizedBox(height: height * 0.05),
            
          ],
        ),
      ),
    );

  }
}


