import 'dart:async';
import 'dart:math';

import 'package:app/consultant_screens/physical_appointment_details.dart';
import 'package:app/models/visa_invitation_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';
import '../models/consultation_model2.dart';
import '../models/doctor_appointment_model.dart';
import '../widgets/progress_dialog.dart';

class PhysicalAppointments extends StatefulWidget {
  const PhysicalAppointments({Key? key}) : super(key: key);

  @override
  State<PhysicalAppointments> createState() => _PhysicalAppointmentsState();
}

class _PhysicalAppointmentsState extends State<PhysicalAppointments> {

  retrieveConsultationDataFromDatabase(String appointmentId){
    FirebaseDatabase.instance.ref().child("doctorAppointmentRequests").child(appointmentId).once().then((dataSnap) {
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
                  Text(
                    "Up-coming",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.02,),

              Flexible(
                child: FirebaseAnimatedList(
                    query: FirebaseDatabase.instance.ref().child("doctorAppointmentRequests"),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                      final consultationType = (snapshot.value as Map)["status"].toString();

                      if (consultationType == "Waiting") {
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const PhysicalAppointmentDetails()));
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

                                          const SizedBox(height: 5),

                                          // Doctor Specialization
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Date of Birth: ${(snapshot.value as Map)["dateOfBirth"]}",
                                                style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
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

                                          const SizedBox(height: 5),

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
                        return Container();
                      }
                    }
                ),
              ),

              SizedBox(height: height * 0.3,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You have no waiting physical appointments",
                    style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}
