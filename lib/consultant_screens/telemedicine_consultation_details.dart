import 'dart:async';

import 'package:app/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../assistants/assistant_methods.dart';
import '../widgets/progress_dialog.dart';

class TelemedicineConsultationDetails extends StatefulWidget {
  const TelemedicineConsultationDetails({Key? key}) : super(key: key);

  @override
  State<TelemedicineConsultationDetails> createState() => _TelemedicineConsultationDetailsState();
}

class _TelemedicineConsultationDetailsState extends State<TelemedicineConsultationDetails> {
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  String? formattedDate,formattedTime;
  int dateCounter = 0;
  int timeCounter = 0;
  bool flag = false;

  pickDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), //get today's date
        firstDate:DateTime.now(), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2030)
    );

    if(pickedDate != null ){
      setState(() {
        date = pickedDate;
        formattedDate = DateFormat('dd-MM-yyyy').format(date);
        dateCounter++;
        flag = true;
      });
    }

    else{
      print("Date is not selected");
    }

  }

  pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), //get today's date
    );

    if(pickedTime != null ){
      setState(() {
        time = pickedTime;
        formattedTime = time.format(context);
        timeCounter++;
      });
    }
  }

  setConsultationInfoToUpcoming() async {
    Map doctorLiveConsultationForDoctor = {
      "id" : consultationId,
      "userId" : selectedConsultationInfoForDocAndConsultant!.userId,
      "date" : formattedDate,
      "time" : formattedTime,
      "consultantFee" : "500",
      "patientId" : selectedConsultationInfoForDocAndConsultant!.patientId,
      "patientName" : selectedConsultationInfoForDocAndConsultant!.patientName!,
      "patientAge" : selectedConsultationInfoForDocAndConsultant!.patientAge!,
      "gender": selectedConsultationInfoForDocAndConsultant!.gender!,
      "height" : selectedConsultationInfoForDocAndConsultant!.height!,
      "weight" : selectedConsultationInfoForDocAndConsultant!.weight!,
      "doctorId" : selectedConsultationInfoForDocAndConsultant!.doctorId,
      "doctorName" : selectedConsultationInfoForDocAndConsultant!.doctorName!,
      "specialization" : selectedConsultationInfoForDocAndConsultant!.specialization,
      "consultationType" : "Upcoming",
      "visitationReason": selectedConsultationInfoForDocAndConsultant!.visitationReason,
      "problem": selectedConsultationInfoForDocAndConsultant!.problem,
      "payment" : "Paid"
    };

    FirebaseDatabase.instance.ref()
        .child("Doctors")
        .child(selectedConsultationInfoForDocAndConsultant!.doctorId!)
        .child("consultations")
        .child(consultationId!).set(doctorLiveConsultationForDoctor);

    DatabaseReference reference = FirebaseDatabase.instance.ref()
        .child("Users")
        .child(selectedConsultationInfoForDocAndConsultant!.userId!)
        .child("patientList")
        .child(selectedConsultationInfoForDocAndConsultant!.patientId!)
        .child("consultations")
        .child(consultationId!);

    reference.child("date").set(formattedDate);
    reference.child("time").set(formattedTime);
    reference.child("consultationType").set("Upcoming");

    FirebaseDatabase.instance.ref()
        .child("offlineTelemedicineRequests")
        .child(consultationId!)
        .remove();

    getRegistrationTokenForUserAndNotify();
  }

  void getRegistrationTokenForUserAndNotify(){
    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(selectedConsultationInfoForDocAndConsultant!.userId!)
        .child("tokens").once().then((snapData) async {
      DataSnapshot snapshot = snapData.snapshot;
      if(snapshot.value != null){
        String deviceRegistrationToken = snapshot.value.toString();
        // send notification now
        await AssistantMethods.sendConsultationPushNotificationToPatientNow(deviceRegistrationToken, selectedConsultationInfoForDocAndConsultant!.patientId!, selectedService,context);
        Fluttertoast.showToast(msg: "Notification sent to patient successfully");
      }

      else{
        Fluttertoast.showToast(msg: "Error sending notifications");
      }
    });

    getRegistrationTokenForDoctorAndNotify();
  }

  void getRegistrationTokenForDoctorAndNotify(){
    FirebaseDatabase.instance.ref()
        .child("Doctors")
        .child(selectedConsultationInfoForDocAndConsultant!.doctorId!)
        .child("tokens").once().then((snapData){
      DataSnapshot snapshot = snapData.snapshot;
      if(snapshot.value != null){
        String deviceRegistrationToken = snapshot.value.toString();
        // send notification now
        AssistantMethods.sendConsultationPushNotificationToDoctorNow(deviceRegistrationToken,context);
        Fluttertoast.showToast(msg: "Notification sent to Doctor successfully");
      }

      else{
        Fluttertoast.showToast(msg: "Error sending notifications");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.blue
                ),
                child: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top:19.0),
              child: Text(
                selectedConsultationInfoForDocAndConsultant!.consultationType!,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                ),
              ),
            ),

            Padding(
                padding: const EdgeInsets.only(right: 10.0,left: 2),
                child: Icon(
                    Icons.circle,
                    color: ((selectedConsultationInfoForDocAndConsultant!.consultationType!.toString() == "Waiting") ? Colors.grey.shade400 : CupertinoColors.systemGreen)
                ))
          ],
        ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: height * 0.3,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
                    )
                ),

                child: Image.network(
                  selectedConsultationInfoForDocAndConsultant!.imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: height * 0.02),

              Text(
                selectedConsultationInfoForDocAndConsultant!.doctorName!,
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),

              SizedBox(height: height * 0.01),

              Text(
                selectedConsultationInfoForDocAndConsultant!.specialization!,
                style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.black
                ),
              ),

              SizedBox(height: height * 0.025,),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 10),
                  Text(
                    "Consultation Information",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    height: 30,
                    thickness: 0.5,
                    color: Colors.black,
                  ),

                ],
              ),

              const Divider(
                height: 10,
                thickness: 1,
                color: Colors.blue,
              ),

              SizedBox(height: height * 0.010,),

              // Consultation ID
              Text(
                "Consultation ID",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Color(0x59090808),
                ),
              ),
              SizedBox(height: height * 0.010,),
              Text(
                "#${selectedConsultationInfoForDocAndConsultant!.id!}",
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              SizedBox(height: height * 0.020,),

              // Consultation Fee
              Text(
                "Consultation Fee",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Color(0x59090808),
                ),
              ),
              SizedBox(height: height * 0.010,),
              Text(
                "#${selectedConsultationInfoForDocAndConsultant!.consultantFee!}",
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              SizedBox(height: height * 0.020,),

              // Consultation Date
              Text(
                "Date",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Color(0x59090808),
                ),
              ),
              SizedBox(height: height * 0.010,),
              Text(
                selectedConsultationInfoForDocAndConsultant!.date!,
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              SizedBox(height: height * 0.020,),

              // Consultation Time
              Text(
                "Time",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Color(0x59090808),
                ),
              ),
              SizedBox(height: height * 0.010,),
              Text(
                selectedConsultationInfoForDocAndConsultant!.time!,
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              SizedBox(height: height * 0.020,),

              // Patient Name
              Text(
                "Patient Name",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Color(0x59090808),
                ),
              ),
              SizedBox(height: height * 0.010,),
              Text(
                selectedConsultationInfoForDocAndConsultant!.patientName!,
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              SizedBox(height: height * 0.020,),

              // Patient Age
              Text(
                "Age",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Color(0x59090808),
                ),
              ),
              SizedBox(height: height * 0.010,),
              Text(
                selectedConsultationInfoForDocAndConsultant!.patientAge!,
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              SizedBox(height: height * 0.020,),

              // Patient Gender
              Text(
                "Gender",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Color(0x59090808),
                ),
              ),
              SizedBox(height: height * 0.010,),
              Text(
                selectedConsultationInfoForDocAndConsultant!.gender!,
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              SizedBox(height: height * 0.020,),

              // Visitation Reason
              Text(
                "Patient visitation Reason",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Color(0x59090808),
                ),
              ),
              SizedBox(height: height * 0.010,),
              Text(
                selectedConsultationInfoForDocAndConsultant!.visitationReason!,
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              SizedBox(height: height * 0.020,),

              // Problem
              Text(
                "Patient Problem (In details)",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Color(0x59090808),
                ),
              ),
              SizedBox(height: height * 0.010,),
              Text(
                selectedConsultationInfoForDocAndConsultant!.problem!,
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              SizedBox(height: height * 0.040,),

              const Divider(
                height: 20,
                thickness: 1,
                color: Colors.blue,
              ),

              (selectedConsultationInfoForDocAndConsultant!.consultationType == "Waiting") ?
                Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.03,),
                  Text(
                    "Date",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                  SizedBox(height: height * 0.01,),
                  // Date Picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey.shade200,
                        child: IconButton(
                          onPressed: () {  },
                          icon: const Icon(Icons.calendar_month,color: Colors.black,size: 35,),
                        ),
                      ),

                      const SizedBox(width: 10,),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              pickDate();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: (Colors.white70),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              (dateCounter != 0) ? '$formattedDate' :  "Select date",
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: height * 0.03,),
                  // Test Time
                  Text(
                    "Time",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                  ),
                  SizedBox(height: height * 0.01,),
                  // Time Picker
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey.shade200,
                        child: IconButton(
                          onPressed: () {  },
                          icon: const Icon(Icons.watch_later_outlined,color: Colors.black,size: 35,),
                        ),
                      ),

                      const SizedBox(width: 10,),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              pickTime();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: (Colors.white70),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              (timeCounter != 0) ? '$formattedTime' :  "Select time",
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: height * 0.05,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ElevatedButton(
                            onPressed: ()  async {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context){
                                    return ProgressDialog(message: "Please wait...");
                                  }
                              );

                              setConsultationInfoToUpcoming();

                              Timer(const Duration(seconds: 5),()  {
                                Navigator.pop(context);
                                var snackBar = const SnackBar(content: Text("Consultation request sent successfully"));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                Navigator.pop(context);
                              });

                            },

                            style: ElevatedButton.styleFrom(
                                primary: (Colors.blue),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),

                            child: Text(
                              "Confirm",
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ) : Container(),

              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
