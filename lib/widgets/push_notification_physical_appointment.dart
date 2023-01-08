import 'dart:async';

import 'package:app/global/global.dart';
import 'package:app/our_services/doctor_appointment/doctor_appointment_history_details.dart';
import 'package:app/widgets/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../doctor_screens/doctor_physical_appointments_details.dart';

class PushNotificationPhysicalAppointment extends StatefulWidget {
  const PushNotificationPhysicalAppointment({Key? key}) : super(key: key);

  @override
  State<PushNotificationPhysicalAppointment> createState() => _PushNotificationPhysicalAppointmentState();
}

class _PushNotificationPhysicalAppointmentState extends State<PushNotificationPhysicalAppointment> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 240),
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children: [
            SizedBox(height: height * 0.05,),

            Text(
              "Your appointment is confirmed",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),

            SizedBox(height: height * 0.03,),

            Text(
              'Please press the button "View Details" to get redirected to the appointment page',
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
                    if(loggedInUser == "Users"){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorAppointmentHistoryDetails()));
                    }
                    else{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorPhysicalAppointmentDetails()));
                    }

                  });
                },

                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),

                icon: const Icon(Icons.video_call),
                label: Text(
                  "View Details",
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
