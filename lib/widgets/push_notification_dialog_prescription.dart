import 'dart:async';

import 'package:app/global/global.dart';
import 'package:app/our_services/ci_consultation/consultation_history_details.dart';
import 'package:app/our_services/doctor_live_consultation/history_screen_details.dart';
import 'package:app/widgets/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PushNotificationDialogPrescription extends StatefulWidget {
  const PushNotificationDialogPrescription({Key? key}) : super(key: key);

  @override
  State<PushNotificationDialogPrescription> createState() => _PushNotificationDialogPrescriptionState();
}

class _PushNotificationDialogPrescriptionState extends State<PushNotificationDialogPrescription> {
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
              (selectedService == "Doctor Live Consultation") ? "Your prescription is uploaded" : "Your CI Report is uploaded",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),

            SizedBox(height: height * 0.03,),

            Text(
              (selectedService == "Doctor Live Consultation") ? 'Please press the button "Check prescription" to get redirected to the download page' : 'Please press the button "Check Report" to get redirected to the download page' ,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),
            ),

            SizedBox(height: height * 0.06,),

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
                    if(selectedService == "Doctor Live Consultation"){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreenDetails()));
                    }
                    else{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ConsultationHistoryDetails()));
                    }

                  });
                },

                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),

                icon: const Icon(Icons.newspaper),
                label: Text(
                  (selectedService == "Doctor Live Consultation") ? "Check Prescription" : "Check Report",
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
