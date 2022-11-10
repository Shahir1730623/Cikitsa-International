import 'dart:async';

import 'package:app/main_screen.dart';
import 'package:app/models/ci_consultation_model.dart';
import 'package:app/our_services/doctor_live_consultation/booking_detail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';
import '../models/consultation_model.dart';
import '../widgets/progress_dialog.dart';
import 'coundown_screen.dart';

class ConfirmationPageScreen extends StatefulWidget {
  const ConfirmationPageScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmationPageScreen> createState() => _ConfirmationPageScreenState();
}

class _ConfirmationPageScreenState extends State<ConfirmationPageScreen> {

  retrieveConsultationInfo(){
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId!)
        .child(selectedServiceDatabaseParentName!)
        .child(consultationId!);

    if(selectedService == "CI Consultation"){
      // Fetching data to store in selectedCIConsultationInfo
      reference.once().then((dataSnap){
        DataSnapshot snapshot = dataSnap.snapshot;
        if (snapshot.exists) {
          selectedCIConsultationInfo = CIConsultationModel.fromSnapshot(snapshot);
        }

        else{
          Fluttertoast.showToast(msg: "No consultation record exist with this credentials");
        }

      });
    }

    else{
      // Fetching data to store in selectedConsultationInfo
      reference.once().then((dataSnap){
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3),(){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return ProgressDialog(message: "");
          }
      );

      retrieveConsultationInfo();
      Timer(const Duration(seconds: 1),()  {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingDetailsScreen()));

      });



    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/checked.png",
                  width: 150,
                ),

                const SizedBox(height: 30),

                Text(
                  "Payment Confirmed",
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
                ),

              ],
            )
        ),
      ),
    );
  }
}