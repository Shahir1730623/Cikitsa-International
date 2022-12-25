import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../global/global.dart';
import '../models/ci_consultation_model.dart';
import '../our_services/visa_invitation/video_call.dart';
import '../widgets/progress_dialog.dart';
import 'ci_consultation_details.dart';

class CIConsultations extends StatefulWidget {
  const CIConsultations({Key? key}) : super(key: key);

  @override
  State<CIConsultations> createState() => _CIConsultationsState();
}

class _CIConsultationsState extends State<CIConsultations> {
  String consultationStatus = "Upcoming";

  setConsultationInfoToAccepted(String consultationId){
    FirebaseDatabase.instance.ref()
        .child("Consultant")
        .child(currentFirebaseUser!.uid)
        .child("consultations")
        .child(consultationId)
        .child("consultationStatus")
        .set("Accepted");
  }

  void retrievePatientDataFromDatabase() {
    FirebaseDatabase.instance.ref()
        .child("Consultant")
        .child(currentFirebaseUser!.uid)
        .child("CIConsultations")
        .child(consultationId!)
        .once()
        .then((dataSnap){
      final DataSnapshot snapshot = dataSnap.snapshot;
      if (snapshot.exists) {
        selectedCIConsultationInfo = CIConsultationModel.fromSnapshot(snapshot);
      }

      else {
        Fluttertoast.showToast(msg: "No Patient record exist with this credentials");
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

    Timer(const Duration(seconds: 3),()  {
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

    selectedService = "CI Consultation";
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
          "CI Consultations",
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
                        consultationStatus = "Upcoming";
                      });

                    },
                    style: ElevatedButton.styleFrom(
                        primary: (consultationStatus == "Upcoming") ? Colors.white : Colors.grey.shade200,
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
                        consultationStatus = "Completed";
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        primary: (consultationStatus == "Completed") ? Colors.white : Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: Colors.black,
                            )
                        )),

                    child: Text(
                      "Past",
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
                  query: FirebaseDatabase.instance.ref()
                      .child("Consultant")
                      .child(currentFirebaseUser!.uid)
                      .child("CIConsultations"),

                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                    final consultationType = (snapshot.value as Map)["consultationStatus"].toString();
                    final databaseTimeString = (snapshot.value as Map)["time"].toString();
                    final databaseTime = TimeOfDay.fromDateTime(DateFormat.jm().parse(databaseTimeString));

                    if (consultationStatus == consultationType) {
                      if(consultationType == "Upcoming"){
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
                            userId = (snapshot.value as Map)["userId"];
                            retrievePatientDataFromDatabase();
                            Timer(const Duration(seconds: 1), () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const CIConsultationDetails()));
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
                                                "Age: ${(snapshot.value as Map)["patientAge"]}",
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
                                                    color: (consultationStatus ==
                                                        "Waiting")
                                                        ? Colors.blue
                                                        : Colors.grey.shade200
                                                ),

                                                height: 30,
                                                width: 30,

                                                child: Transform.rotate(
                                                  angle: 180 * pi / 180,
                                                  child: Icon(
                                                    Icons.arrow_back_ios_new,
                                                    color: (consultationStatus ==
                                                        "Waiting") ? Colors
                                                        .white : Colors.black,
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
                                            "Status: ${(snapshot.value as Map)["consultationStatus"]}",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                          ((TimeOfDay.now().hour == databaseTime.hour) && (TimeOfDay.now().minute >= databaseTime.minute && (TimeOfDay.now().minute <= (databaseTime.minute + 5)))) ?
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                child: ElevatedButton.icon(
                                                  onPressed: ()  {
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        builder: (BuildContext context){
                                                          return ProgressDialog(message: "Please wait...");
                                                        }
                                                    );

                                                    consultationId = (snapshot.value as Map)["id"];
                                                    setConsultationInfoToAccepted(consultationId!);
                                                    Timer(const Duration(seconds: 5),()  {
                                                      Navigator.pop(context);
                                                      channelName = consultationId;
                                                      Fluttertoast.showToast(msg: channelName!);
                                                      tokenRole = 1;
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AgoraScreen()));
                                                    });

                                                  },

                                                  style: ElevatedButton.styleFrom(
                                                      primary: (Colors.blue),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20))),

                                                  label: Text(
                                                    "Join Now" ,
                                                    style: GoogleFonts.montserrat(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white
                                                    ),
                                                  ),

                                                  icon: const Icon(
                                                      Icons.video_call_rounded
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ) : Container()

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

                      else{
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
                            userId = (snapshot.value as Map)["userId"];
                            retrievePatientDataFromDatabase();
                            Timer(const Duration(seconds: 1), () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const CIConsultationDetails()));
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
                                                "Age: ${(snapshot.value as Map)["patientAge"]}",
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
                                                    color: (consultationStatus ==
                                                        "Waiting")
                                                        ? Colors.blue
                                                        : Colors.grey.shade200
                                                ),

                                                height: 30,
                                                width: 30,

                                                child: Transform.rotate(
                                                  angle: 180 * pi / 180,
                                                  child: Icon(
                                                    Icons.arrow_back_ios_new,
                                                    color: (consultationStatus ==
                                                        "Waiting") ? Colors
                                                        .white : Colors.black,
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
                                            "Status: ${(snapshot.value as Map)["consultationStatus"]}",
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

            SizedBox(height: height * 0.03,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (consultationStatus == "Upcoming") ? "You have no more upcoming CI Consultations" : "You have no more past CI Consultations",
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
    );
  }
}
