import 'package:app/common_screens/payment_screen.dart';
import 'package:app/common_screens/reschedule_date.dart';
import 'package:app/global/global.dart';
import 'package:app/models/ci_consultation_model.dart';
import 'package:app/models/consultant_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../assistants/assistant_methods.dart';
import '../common_screens/coundown_screen.dart';
import '../common_screens/waiting_screen.dart';
import '../models/doctor_model.dart';

class PushNotificationDialogSelectSchedule extends StatefulWidget {

  String? consultationId;
  String? patientName;

  PushNotificationDialogSelectSchedule({this.consultationId,this.patientName});

  @override
  State<PushNotificationDialogSelectSchedule> createState() => _PushNotificationDialogSelectScheduleState();
}

class _PushNotificationDialogSelectScheduleState extends State<PushNotificationDialogSelectSchedule> {
  String patientLength = "0";

  void countNumberOfChild(String selectedService){
    if(selectedService == "Doctor Live Consultation"){
      FirebaseDatabase.instance.ref('Doctors').child(selectedConsultationInfo!.doctorId!).once().then((snapData) {
        DataSnapshot snapshot = snapData.snapshot;
        if(snapshot.value != null){
          selectedDoctorInfo = DoctorModel.fromSnapshot(snapshot);
          patientLength = selectedDoctorInfo!.patientQueueLength!;
        }

        else{
          Fluttertoast.showToast(msg: "No doctor record exist with this credentials");
        }
      });

      Map info = {
        "patientId" : patientId!
      };

      String count = (int.parse(selectedDoctorInfo!.patientQueueLength.toString()) + 1).toString();
      FirebaseDatabase.instance.ref('Doctors').child(doctorId!).child('patientQueueLength').set(count);
      FirebaseDatabase.instance.ref('Doctors').child(doctorId!).child('patientQueue').child(consultationId!).set(info);
    }

    else{
      FirebaseDatabase.instance.ref('Consultant').child(selectedCIConsultationInfo!.consultantId!).once().then((snapData) {
        DataSnapshot snapshot = snapData.snapshot;
        if(snapshot.value != null){
          setState(() {
            patientLength = (snapshot.value as Map)['patientQueueLength'];
          });

          Fluttertoast.showToast(msg: "patient length:" + patientLength);

          Map info = {
            "patientId" : selectedCIConsultationInfo!.patientId!
          };

          String count = (int.parse(patientLength) + 1).toString();
          FirebaseDatabase.instance.ref('Consultant').child(selectedCIConsultationInfo!.consultantId!).child('patientQueueLength').set(count);
          FirebaseDatabase.instance.ref('Consultant').child(selectedCIConsultationInfo!.consultantId!).child('patientQueue').child(consultationId!).set(info);
        }

        else{
          Fluttertoast.showToast(msg: "No consultant record exist with this credentials");
        }
      });

    }

  }

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
              'Please press the button "Talk Now" to start the video call',
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
                onPressed: () async {
                  countNumberOfChild(selectedService);
                  if(selectedService == "Doctor Live Consultation"){
                    if(int.parse(selectedDoctorInfo!.patientQueueLength!) == 0){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CountDownScreen()));
                    }

                    else{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const WaitingScreen()));
                    }
                  }

                  else{
                    if(int.parse(patientLength) == 0){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CountDownScreen()));
                    }

                    else{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const WaitingScreen()));
                    }
                  }
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
