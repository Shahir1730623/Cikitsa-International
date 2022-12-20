import 'package:app/common_screens/payment_screen.dart';
import 'package:app/common_screens/reschedule_date.dart';
import 'package:app/global/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../assistants/assistant_methods.dart';
import '../common_screens/coundown_screen.dart';

class PushNotificationDialogSelectSchedule extends StatefulWidget {

  String? consultationId;
  String? patientName;

  PushNotificationDialogSelectSchedule({this.consultationId,this.patientName});

  @override
  State<PushNotificationDialogSelectSchedule> createState() => _PushNotificationDialogSelectScheduleState();
}

class _PushNotificationDialogSelectScheduleState extends State<PushNotificationDialogSelectSchedule> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children: [
            SizedBox(height: height * 0.07,),

            Text(
              selectedService == ("CI Consultation") ? ("You have meeting with\nconsultant now") : ("You have meeting with\ndoctor now"),
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),

            SizedBox(height: height * 0.025,),

            Text(
              'Please press "Talk Now" or\n"Reschedule Later"',
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
                onPressed: ()  async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CountDownScreen()));
                },

                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),

                icon: const Icon(Icons.video_call),
                label: Text(
                  selectedService == ("CI Consultation") ? ("Talk to Consultant Now") : ("Talk to Doctor Now"),
                  style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
              ),
            ),

            SizedBox(height: height * 0.02,),

            /*SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: ()  {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RescheduleDate()));
                },

                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),

                icon: Icon(Icons.calendar_month),
                label: Text(
                  ("Reschedule Later"),
                  style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
              ),
            ),*/


          ],
        ),
      ),
    );
  }
}
