import 'dart:async';
import 'dart:math';

import 'package:app/consultant_screens/telemedicine_consultation_details.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';
import '../models/consultation_model2.dart';
import '../widgets/progress_dialog.dart';

class TelemedicineConsultations extends StatefulWidget {
  const TelemedicineConsultations({Key? key}) : super(key: key);

  @override
  State<TelemedicineConsultations> createState() => _TelemedicineConsultationsState();
}

class _TelemedicineConsultationsState extends State<TelemedicineConsultations> {
  retrieveConsultationDataFromDatabase(String consultationId){
    FirebaseDatabase.instance.ref().child("offlineTelemedicineRequests").child(consultationId).once().then((dataSnap) {
      DataSnapshot snapshot = dataSnap.snapshot;
      if (snapshot.exists) {
        selectedConsultationInfoForDocAndConsultant = ConsultationModel2.fromSnapshot(snapshot);
      }

      else {
        Fluttertoast.showToast(msg: "No consultation record exist");
      }
    });
  }


  void loadScreen(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "Fetching data...");
        }
    );

    Timer(const Duration(seconds: 2),()  {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      loadScreen();
    });

    selectedService = "Doctor Live Consultation";
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
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
            "Telemedicine\n(Offline Doctors)",
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
              const Divider(
                thickness: 3,
                height: 120,
                color: Colors.blue,
              ),

              Flexible(
                child: FirebaseAnimatedList(
                    query: FirebaseDatabase.instance.ref().child("offlineTelemedicineRequests"),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                      final consultationType = (snapshot.value as Map)["consultationType"].toString();

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

                            consultationId = (snapshot.value as Map)["id"];
                            retrieveConsultationDataFromDatabase(consultationId!);

                            Timer(const Duration(seconds: 5), () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const TelemedicineConsultationDetails()));
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
                                          radius: 30,
                                          backgroundColor: Colors.lightBlue,
                                          child: Text(
                                            (snapshot.value as Map)["patientName"][0],
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 30
                                            ),
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
                                            (snapshot.value as Map)["patientName"].toString(),
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
                                                "Age: " + (snapshot.value as Map)["patientAge"].toString(),
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
                                              Text("${(snapshot.value as Map)["weight"]} kg",
                                                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 14)),
                                              const Text(" - "),

                                              Text("${(snapshot.value as Map)["height"]} feet",
                                                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 14)),
                                            ],
                                          ),

                                          const SizedBox(height: 10),


                                          Text(
                                            "Status: ${(snapshot.value as Map)["consultationType"]}",
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
                    "You have no waiting Telemedicine consultations",
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
