import 'dart:async';
import 'dart:math';

import 'package:app/our_services/doctor_appointment/doctor_appointment_history_details.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../global/global.dart';
import '../../models/doctor_appointment_model.dart';
import '../../widgets/progress_dialog.dart';

class DoctorAppointmentHistory extends StatefulWidget {
  const DoctorAppointmentHistory({Key? key}) : super(key: key);

  @override
  State<DoctorAppointmentHistory> createState() => _DoctorAppointmentHistoryState();
}

class _DoctorAppointmentHistoryState extends State<DoctorAppointmentHistory> {
  String appointmentStatus = "Upcoming";

  retrieveAppointmentDataFromDatabase() {
    FirebaseDatabase.instance.ref().child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId!)
        .child("doctorAppointment")
        .child(appointmentId!)
        .once()
        .then((dataSnap) {
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
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

        title: Text(
          "Appointment History",
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
            SizedBox(height: height * 0.1,),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        appointmentStatus = "Upcoming";
                      });

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: (appointmentStatus == "Upcoming") ? Colors.white : Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: Colors.black,
                            )
                        )),

                    child: Text(
                      "Upcoming",
                      style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5,),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        appointmentStatus = "Completed";
                      });

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: (appointmentStatus == "Completed") ? Colors.white : Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: Colors.black,
                            )
                        )),

                    child: Text(
                      "Completed",
                      style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: height * 0.05,),

            Flexible(
              child: FirebaseAnimatedList(
                  query: FirebaseDatabase.instance.ref().child("Users")
                      .child(currentFirebaseUser!.uid)
                      .child("patientList")
                      .child(patientId!)
                      .child("doctorAppointment"),

                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    final status = (snapshot.value as Map)["status"].toString();

                    if (appointmentStatus == status) {
                      return GestureDetector(
                        onTap: () async {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return ProgressDialog(message: 'message');
                              }
                          );

                          appointmentId = (snapshot.value as Map)["id"];
                          await retrieveAppointmentDataFromDatabase();

                          Timer(const Duration(seconds: 1), () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorAppointmentHistoryDetails()));
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
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                              ),

                              SizedBox(height: height * 0.015),

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
                                        radius: 30,
                                        backgroundColor: Colors.grey[100],
                                        foregroundImage: NetworkImage(
                                          (snapshot.value as Map)["doctorImageUrl"],
                                        ),
                                      ),

                                    ],
                                  ),

                                  const SizedBox(width: 10,),

                                  // Right Column
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Doctor Name
                                        Text(
                                          (snapshot.value as Map)["doctorName"].toString(),
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),

                                        const SizedBox(height: 5),

                                        // Doctor Specialization
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              (snapshot.value as Map)["specialization"],
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),

                                            // Status
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                  color: (status == "Waiting")
                                                      ? Colors.grey.shade200
                                                      : Colors.blue
                                              ),

                                              height: 30,
                                              width: 30,

                                              child: Transform.rotate(
                                                angle: 180 * pi / 180,
                                                child: Icon(
                                                  Icons.arrow_back_ios_new,
                                                  color: (status == "Waiting") ? Colors.black : Colors.white,
                                                  size: 20,
                                                ),
                                              ),


                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 5),

                                        // Workplace
                                        Text(
                                          (snapshot.value as Map)["workplace"],
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),


                                        const SizedBox(height: 10),

                                        Text(
                                          "Status: ${(snapshot.value as Map)["status"]}",
                                          style: GoogleFonts.montserrat(
                                              fontSize: 13,
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
                      return Container();
                    }
                  }
              ),
            )

          ],
        ),
      ),
    );

  }
}
