import 'dart:async';
import 'dart:math';

import 'package:age_calculator/age_calculator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';
import '../models/doctor_appointment_model.dart';
import '../widgets/progress_dialog.dart';
import 'doctor_physical_appointments_details.dart';

class DoctorPhysicalAppointments extends StatefulWidget {
  const DoctorPhysicalAppointments({Key? key}) : super(key: key);

  @override
  State<DoctorPhysicalAppointments> createState() => _DoctorPhysicalAppointmentsState();
}

class _DoctorPhysicalAppointmentsState extends State<DoctorPhysicalAppointments> {
  String appointmentStatus = "Upcoming";

  retrieveConsultationDataFromDatabase(String appointmentId){
    FirebaseDatabase.instance.ref().child("Doctors")
        .child(currentFirebaseUser!.uid).child('appointments').child(appointmentId).once().then((dataSnap) {
      DataSnapshot snapshot = dataSnap.snapshot;
      if (snapshot.exists) {
        selectedDoctorAppointmentInfo = DoctorAppointmentModel.fromSnapshot(snapshot);
      }

      else {
        Fluttertoast.showToast(msg: "No appointment record exist");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
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

          title: Text(
            "Physical Appointments",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: height * 0.08,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Appointments",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),

                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            appointmentStatus = "Upcoming";
                          });
                        },
                        child:
                        Text(
                          "Upcoming",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: (appointmentStatus == "Upcoming") ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                     ),
                      const SizedBox(width: 5),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            appointmentStatus = "Completed";
                          });
                        },
                        child:
                        Text(
                          "Previous",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: (appointmentStatus == "Completed") ? Colors.black : Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )

                ],
              ),

              SizedBox(height: height * 0.02,),

              Flexible(
                child: FirebaseAnimatedList(
                    query:  FirebaseDatabase.instance.ref().child("Doctors").child(currentFirebaseUser!.uid).child('appointments'),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                      final consultationType = (snapshot.value as Map)["status"].toString();

                      if(consultationType == appointmentStatus){
                        if (consultationType == "Upcoming") {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return ProgressDialog(message: 'message');
                                  }
                              );

                              appointmentId = (snapshot.value as Map)["id"];
                              retrieveConsultationDataFromDatabase(appointmentId!);

                              Timer(const Duration(seconds: 2), () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorPhysicalAppointmentDetails()));
                              });
                            },

                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blueAccent),
                                color: Colors.white,
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5,),

                                  Text(
                                    "Appointment Date",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        color: Colors.blue
                                    ),
                                  ),

                                  SizedBox(height: height * 0.01),

                                  // Specialization Name
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/appointment_date.png",
                                      ),

                                      const SizedBox(width: 10),

                                      Text(
                                        (snapshot.value as Map)["date"].toString(),
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),

                                      Text(
                                        " - ",
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),

                                      Text(
                                        (snapshot.value as Map)["time"],
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 5,),

                                  const Divider(
                                    thickness: 1,
                                  ),

                                  const SizedBox(height: 5,),

                                  Row(
                                    children: [
                                      // Left Column
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Doc image
                                          CircleAvatar( //or 15.0
                                            radius: height * 0.05,
                                            backgroundColor: Colors.lightBlue,
                                            foregroundImage: NetworkImage(
                                              (snapshot.value as Map)["doctorImageUrl"],
                                            ),
                                          ),

                                        ],
                                      ),

                                      const SizedBox(width: 20,),

                                      // Right Column
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Doctor Name
                                            Text(
                                              "${(snapshot.value as Map)["patientGivenName"]} ${(snapshot.value as Map)["patientSurname"]}",
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),

                                            const SizedBox(height: 10),

                                            // Doctor Specialization
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Sickness: " + (snapshot.value as Map)["visitationReason"],
                                                    style: GoogleFonts.montserrat(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),

                                                // Status
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(50),
                                                      color: Colors.grey.shade200
                                                  ),

                                                  height: 30,
                                                  width: 30,

                                                  child: Transform.rotate(
                                                    angle: 180 * pi / 180,
                                                    child: const Icon(
                                                      Icons.arrow_back_ios_new,
                                                      color: Colors.black,
                                                      size: 20,
                                                    ),
                                                  ),


                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 10),

                                            Row(
                                              children: [
                                                Text((snapshot.value as Map)["gender"].toString(),
                                                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 14)),

                                                const Text(" - "),
                                                Text("${(snapshot.value as Map)["patientWeight"]} kg",
                                                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 14)),
                                                const Text(" - "),

                                                Text("${(snapshot.value as Map)["patientHeight"]} feet",
                                                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 14)),
                                              ],
                                            ),

                                            const SizedBox(height: 10),


                                            Text(
                                              "Status: ${(snapshot.value as Map)["status"]}",
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),

                                    ],
                                  ),

                                ],
                              ),
                            ),
                          );
                        }

                        else {
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return ProgressDialog(message: 'message');
                                  }
                              );

                              appointmentId = (snapshot.value as Map)["id"];
                              retrieveConsultationDataFromDatabase(appointmentId!);

                              Timer(const Duration(seconds: 5), () {
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorPhysicalAppointmentDetails()));
                              });
                            },

                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blueAccent),
                                color: Colors.white,
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 5,),

                                  Text(
                                    "Appointment Date",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        color: Colors.blue
                                    ),
                                  ),

                                  SizedBox(height: height * 0.01),

                                  // Specialization Name
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/appointment_date.png",
                                      ),

                                      const SizedBox(width: 10),

                                      Text(
                                        (snapshot.value as Map)["date"].toString(),
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),

                                      Text(
                                        " - ",
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),

                                      Text(
                                        (snapshot.value as Map)["time"],
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 5,),

                                  const Divider(
                                    thickness: 1,
                                  ),

                                  const SizedBox(height: 5,),

                                  Row(
                                    children: [
                                      // Left Column
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Doc image
                                          CircleAvatar( //or 15.0
                                            radius: height * 0.05,
                                            backgroundColor: Colors.lightBlue,
                                            foregroundImage: NetworkImage(
                                              (snapshot.value as Map)["doctorImageUrl"],
                                            ),
                                          ),

                                        ],
                                      ),

                                      const SizedBox(width: 20,),

                                      // Right Column
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Doctor Name
                                            Text(
                                              "${(snapshot.value as Map)["patientGivenName"]} ${(snapshot.value as Map)["patientSurname"]}",
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),

                                            const SizedBox(height: 10),

                                            // Doctor Specialization
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Sickness: " + (snapshot.value as Map)["visitationReason"],
                                                    style: GoogleFonts.montserrat(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),

                                                // Status
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(50),
                                                      color: Colors.grey.shade200
                                                  ),

                                                  height: 30,
                                                  width: 30,

                                                  child: Transform.rotate(
                                                    angle: 180 * pi / 180,
                                                    child: const Icon(
                                                      Icons.arrow_back_ios_new,
                                                      color: Colors.black,
                                                      size: 20,
                                                    ),
                                                  ),


                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 10),

                                            Row(
                                              children: [
                                                Text((snapshot.value as Map)["gender"].toString(),
                                                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 14)),

                                                const Text(" - "),
                                                Text("${(snapshot.value as Map)["patientWeight"]} kg",
                                                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 14)),
                                                const Text(" - "),

                                                Text("${(snapshot.value as Map)["patientHeight"]} feet",
                                                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 14)),
                                              ],
                                            ),

                                            const SizedBox(height: 10),


                                            Text(
                                              "Status: ${(snapshot.value as Map)["status"]}",
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),

                                    ],
                                  ),

                                ],
                              ),
                            ),
                          );
                        }
                      }

                      else {
                        return Container();
                      }
                    }
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

