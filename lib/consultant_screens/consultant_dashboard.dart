import 'dart:async';
import 'dart:math';

import 'package:app/consultant_screens/ci_consultations.dart';
import 'package:app/consultant_screens/telemedicine_consultation_details.dart';
import 'package:app/consultant_screens/telemedicine_consultations.dart';
import 'package:app/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/ci_consultation_model.dart';
import '../splash_screen/splash_screen.dart';
import '../widgets/progress_dialog.dart';
import 'ci_consultation_details.dart';

class ConsultantDashboard extends StatefulWidget {
  const ConsultantDashboard({Key? key}) : super(key: key);

  @override
  State<ConsultantDashboard> createState() => _ConsultantDashboardState();
}

class _ConsultantDashboardState extends State<ConsultantDashboard> {
  void retrievePatientDataFromDatabase() {
    FirebaseDatabase.instance.ref()
        .child("CIConsultationRequests")
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            Stack(
              children: [
                Container(
                  height: 350,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
                      )
                  ),
                ),

                Positioned(
                  top: 20,
                  left: 20,
                  child: GestureDetector(
                      onTap: (){
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorProfileEdit()));
                      },
                      child: (currentConsultantInfo!.imageUrl != null) ?
                      CircleAvatar(
                        radius: 25,
                        foregroundImage: NetworkImage(currentConsultantInfo!.imageUrl!),
                      ) : CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 30,
                        child: Text(
                          currentConsultantInfo!.name![0],
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      )
                  ),
                ),

                Positioned(
                    top: 120,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome!',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.montserrat(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        Text(
                          "Back",
                          style: GoogleFonts.montserrat(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),


                        Text(
                          'Have a nice day',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                          ),
                        ),

                        const SizedBox(height: 10,),


                      ],
                    )
                ),

                Positioned(
                  top: 280,
                  left: 20,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        onPrimary: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: const Size(100, 40),
                      ),
                      onPressed: () {
                        currentConsultantInfo = null;
                        loggedInUser = "";
                        firebaseAuth.signOut();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SplashScreen()));
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.logout),

                          SizedBox(width: 10,),

                          Text(
                            'Log out',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ],
            ),

            SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CI Services',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CIConsultations()));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 1,color: Colors.grey.shade400),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Image.asset(
                                        "assets/leader.png"
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10,),

                              Text(
                                'CI Consultation',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600
                                ),
                              )

                            ],
                          ),

                          Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TelemedicineConsultations()));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 1,color: Colors.grey.shade400),
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Image.asset(
                                        "assets/doctor (1).png"
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10,),

                              Text(
                                'Consultation',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600
                                ),
                              )

                            ],
                          ),

                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 1,color: Colors.grey.shade400),
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Image.asset(
                                      "assets/authenticationImages/stethoscope-2.png"
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10,),

                              Text(
                                'Physical\nAppointments',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600
                                ),
                              )

                            ],
                          ),

                        ],
                      ),

                      const SizedBox(height: 20,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Upcoming CI Consultations',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700
                            ),
                          ),

                          const Text('CI Waiting history', style: TextStyle(color: Colors.blue,),)
                        ],
                      ),

                      const SizedBox(height: 20,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FirebaseAnimatedList(
                            query:  FirebaseDatabase.instance.ref().child("CIConsultationRequests"),
                            scrollDirection: Axis.vertical,
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                              final consultationStatus = (snapshot.value as Map)["consultationStatus"].toString();
                              if(consultationStatus == "Waiting"){
                                return GestureDetector(
                                  onTap: () async {
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
                                    Timer(const Duration(seconds: 3), () {
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
                                                            color: (consultationStatus == "Waiting")
                                                                ? Colors.blue
                                                                : Colors.grey.shade200
                                                        ),

                                                        height: 30,
                                                        width: 30,

                                                        child: Transform.rotate(
                                                          angle: 180 * pi / 180,
                                                          child: Icon(
                                                            Icons.arrow_back_ios_new,
                                                            color: (consultationStatus == "Waiting") ? Colors
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
                              else{
                                return Container();
                              }

                            },
                          ),
                          SizedBox(height: height * 0.07,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No waiting CI consultations",
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
                    ],
                  ),
                ),
              ),
            )


          ],
        ),
      ),
    );
  }
}
