import 'dart:async';
import 'dart:math';

import 'package:app/models/consultant_model.dart';
import 'package:app/models/consultation_model.dart';
import 'package:app/our_services/doctor_live_consultation/history_screen_details.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../common_screens/coundown_screen.dart';
import '../../common_screens/waiting_screen.dart';
import '../../global/global.dart';
import '../../models/doctor_model.dart';
import '../../widgets/progress_dialog.dart';
import '../visa_invitation/video_call.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String consultationStatus = "Upcoming";
  Timer? timer;
  String? consultantId;

  setConsultationInfoToAccepted() async {
    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(currentFirebaseUser!.uid)
        .child('patientList')
        .child(patientId!)
        .child("consultations")
        .child(consultationId!).child("consultationType").set("Accepted");

    countNumberOfChild();
  }

  void countNumberOfChild(){
    DatabaseReference reference = FirebaseDatabase.instance.ref('Doctors').child(doctorId!);
    reference.once().then((snapData) {
      DataSnapshot snapshot = snapData.snapshot;
      if(snapshot.value != null){
        int count = int.parse((snapshot.value as Map)["patientQueueLength"].toString());
        reference.child('patientQueueLength').set((count + 1).toString());

        Map info = {
          "patientId" : patientId
        };

        reference.child('patientQueue').child(consultationId!).set(info);

        if(count == 0){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CountDownScreen()));
        }

        else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => const WaitingScreen()));
        }

        //selectedDoctorInfo = DoctorModel.fromSnapshot(snapshot);
      }

      else{
        Fluttertoast.showToast(msg: "No doctor record exist with these credentials");
      }
    });
    retrieveConsultationDataFromDatabase();

  }

  retrieveConsultationDataFromDatabase() {
    FirebaseDatabase.instance.ref().child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId!)
        .child("consultations")
        .child(consultationId!).once().then((dataSnap) {
      DataSnapshot snapshot = dataSnap.snapshot;
      if (snapshot.exists) {
        selectedConsultationInfo = ConsultationModel.fromSnapshot(snapshot);
      }

      else {
        Fluttertoast.showToast(msg: "No consultation record exist");
      }
    });

    selectedService = "Doctor Live Consultation";
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //checkTiming();
  }

  @override
  void dispose() {
    //timer!.cancel();
    super.dispose();
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
          "Telemedicine History",
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
                        primary: (consultationStatus == "Upcoming") ? Colors
                            .white : Colors.grey.shade200,
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
                        primary: (consultationStatus == "Completed") ? Colors
                            .white : Colors.grey.shade200,
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
                  query: FirebaseDatabase.instance.ref().child("Users")
                      .child(currentFirebaseUser!.uid)
                      .child("patientList")
                      .child(patientId!)
                      .child("consultations"),

                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    final consultationType = (snapshot.value as Map)["consultationType"].toString();
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
                            retrieveConsultationDataFromDatabase();

                            Timer(const Duration(seconds: 1), () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreenDetails()));
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
                                            (snapshot.value as Map)["doctorName"]
                                                .toString(),
                                            style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),

                                          const SizedBox(height: 5),

                                          // Doctor Specialization
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Text(
                                                (snapshot
                                                    .value as Map)["specialization"]
                                                    .toString(),
                                                style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),

                                              // Status
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .circular(50),
                                                    color: (consultationStatus == "Upcoming")
                                                        ? Colors.blue
                                                        : Colors.grey.shade200
                                                ),

                                                height: 30,
                                                width: 30,

                                                child: Transform.rotate(
                                                  angle: 180 * pi / 180,
                                                  child: Icon(
                                                    Icons.arrow_back_ios_new,
                                                    color: (consultationStatus == "Upcoming") ? Colors.white : Colors.black,
                                                    size: 20,
                                                  ),
                                                ),


                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 5),

                                          // Workplace
                                          Text(
                                            "Workplace: " + (snapshot.value as Map)["workplace"].toString(),
                                            style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),


                                          const SizedBox(height: 15),

                                          Text(
                                            "Status: " + (snapshot
                                                .value as Map)["consultationType"]
                                                .toString(),
                                            style: GoogleFonts.montserrat(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                          ((TimeOfDay.now().hour == databaseTime.hour) &&
                                              (TimeOfDay.now().minute >= databaseTime.minute && (TimeOfDay.now().minute <= (databaseTime.minute + 5))))  ?
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                child: ElevatedButton.icon(
                                                  onPressed: ()  async {
                                                    consultationId = (snapshot.value as Map)["id"];
                                                    doctorId = (snapshot.value as Map)["doctorId"];
                                                    await setConsultationInfoToAccepted();
                                                  },

                                                  style: ElevatedButton.styleFrom(
                                                      primary: (Colors.blue),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20))),

                                                  label: Text(
                                                    "Join video call" ,
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

                                    // Button
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
                            retrieveConsultationDataFromDatabase();
                            Timer(const Duration(seconds: 1), () {
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreenDetails()));
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
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
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
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          // Doctor Name
                                          Text(
                                            (snapshot.value as Map)["doctorName"]
                                                .toString(),
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
                                                (snapshot
                                                    .value as Map)["specialization"]
                                                    .toString(),
                                                style: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),

                                              // Status
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius
                                                        .circular(50),
                                                    color: (consultationStatus == "Upcoming")
                                                        ? Colors.blue
                                                        : Colors.grey.shade200
                                                ),

                                                height: 30,
                                                width: 30,

                                                child: Transform.rotate(
                                                  angle: 180 * pi / 180,
                                                  child: Icon(
                                                    Icons.arrow_back_ios_new,
                                                    color: (consultationStatus == "Upcoming") ? Colors.white : Colors.black,
                                                    size: 20,
                                                  ),
                                                ),


                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 5),

                                          // Workplace
                                          Text(
                                            "Workplace: " + (snapshot.value as Map)["workplace"].toString(),
                                            style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),


                                          const SizedBox(height: 15),

                                          Text(
                                            "Status: " + (snapshot
                                                .value as Map)["consultationType"]
                                                .toString(),
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
