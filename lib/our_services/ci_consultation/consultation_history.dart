import 'dart:async';
import 'dart:math';

import 'package:app/our_services/ci_consultation/consultation_history_details.dart';
import 'package:app/models/ci_consultation_model.dart';
import 'package:app/models/consultant_model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../common_screens/coundown_screen.dart';
import '../../common_screens/waiting_screen.dart';
import '../../global/global.dart';
import '../../widgets/progress_dialog.dart';
import '../visa_invitation/video_call.dart';

class ConsultationHistory extends StatefulWidget {
  const ConsultationHistory({Key? key}) : super(key: key);

  @override
  State<ConsultationHistory> createState() => _ConsultationHistoryState();
}

class _ConsultationHistoryState extends State<ConsultationHistory> {
  String consultationStatus = "Upcoming";
  int toggleIndex = 0;
  String? consultantId;


  setCIConsultationInfoToAccepted() async {
    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(currentFirebaseUser!.uid)
        .child('patientList')
        .child(patientId!)
        .child("CIConsultations")
        .child(consultationId!).child("consultationStatus").set("Accepted");

    countNumberOfChild();
  }

  void countNumberOfChild(){
    DatabaseReference reference = FirebaseDatabase.instance.ref('Consultant').child(consultantId!);
    reference.once().then((snapData) {
      DataSnapshot snapshot = snapData.snapshot;
      if(snapshot.value != null){
        int count = int.parse((snapshot.value as Map)["patientQueueLength"].toString());
        reference.child('patientQueueLength').set((count + 1).toString());

        Map info = {
          "patientId" : patientId
        };

        reference.child('patientQueue').child(consultationId!).set(info);
        //selectedConsultantInfo = ConsultantModel.fromSnapshot(snapshot);

        if(count == 0){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CountDownScreen()));
        }

        else{
          Navigator.push(context, MaterialPageRoute(builder: (context) => const WaitingScreen()));
        }

      }

      else{
        Fluttertoast.showToast(msg: "No consultant record exist with these credentials");
      }
    });

    retrieveConsultationDataFromDatabase();

  }

  retrieveConsultationDataFromDatabase() {
    FirebaseDatabase.instance.ref().child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId!)
        .child("CIConsultations")
        .child(consultationId!).once().then((dataSnap) {
      DataSnapshot snapshot = dataSnap.snapshot;
      if (snapshot.exists) {
        selectedCIConsultationInfo = CIConsultationModel.fromSnapshot(snapshot);
      }

      else {
        Fluttertoast.showToast(msg: "No consultation record exist");
      }
    });

    selectedService = "CI Consultation";
  }



  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final double itemHeight = (height - kToolbarHeight - 24) / 2;
    final double itemWidth = (width / 1.0);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Previous History',
            style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
        )),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
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
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  const Text(
                    'CI Appointments',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(height: 20,),

                  const Divider(thickness: 2,height: 1,color: Colors.blue,),

                  const SizedBox(height: 20,),

                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2,color: Colors.blue),
                        borderRadius: BorderRadius.circular(30)
                    ),

                    child: ToggleSwitch(
                      minWidth: 150,
                      cornerRadius: 20.0,
                      activeBgColors: [[Colors.white], [Colors.white]],
                      activeFgColor: Colors.black,
                      inactiveBgColor: Colors.blueAccent,
                      inactiveFgColor: Colors.white,
                      initialLabelIndex: toggleIndex,
                      totalSwitches: 2,
                      labels: ['Upcoming', 'Past'],
                      radiusStyle: true,
                      onToggle: (index) {
                        if(index == 1){
                          setState(() {
                            toggleIndex = 1;
                            consultationStatus = "Completed";
                          });

                        }
                        else{
                          setState(() {
                            toggleIndex = 0;
                            consultationStatus = "Upcoming";
                          });
                        }


                      },
                    ),
                  ),

                  const SizedBox(height: 20,),

                  FirebaseAnimatedList(
                      query: FirebaseDatabase.instance.ref().child("Users")
                          .child(currentFirebaseUser!.uid)
                          .child("patientList")
                          .child(patientId!)
                          .child("CIConsultations"),

                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context,DataSnapshot snapshot, Animation<double> animation,int index){
                        final consultationType = (snapshot.value as Map)["consultationStatus"].toString();
                        final databaseTimeString = (snapshot.value as Map)["time"].toString();
                        final databaseTime = TimeOfDay.fromDateTime(DateFormat.jm().parse(databaseTimeString));

                        if(consultationStatus == consultationType){
                          if(consultationType == "Upcoming"){
                            return GestureDetector(
                              onTap: (){
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ConsultationHistoryDetails()));
                                });

                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0, 0), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              const VerticalDivider(color: Colors.blueAccent, thickness: 3,),

                                              const SizedBox(width: 10,),

                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text('Appointment Date',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.black),),

                                                          const SizedBox(height: 10,),

                                                          Row(
                                                            children: [
                                                              const Icon(Icons.access_time,size: 25,),

                                                              const SizedBox(width: 10,),

                                                              Text((snapshot.value as Map)["date"].toString(),style: const TextStyle(color: Colors.grey,fontSize: 15),),

                                                              const Text(' - '),

                                                              Text((snapshot.value as Map)["time"].toString(),style: const TextStyle(color: Colors.grey,fontSize: 15),),

                                                            ],
                                                          ),
                                                        ],
                                                      ),

                                                      SizedBox(width: MediaQuery.of(context).size.width-310,),

                                                    ],
                                                  ),

                                                  const SizedBox(height: 10,),

                                                  // Divider
                                                  Container(color: Colors.grey, height: 1, width: MediaQuery.of(context).size.width-80,),

                                                  const SizedBox(height: 15,),

                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor: Colors.grey[200],
                                                          foregroundImage: const AssetImage(
                                                              "assets/doctorImages/doctor-1.png"
                                                          )
                                                      ),

                                                      const SizedBox(width: 10,),

                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            (snapshot.value as Map)["consultantName"].toString(),
                                                            style: GoogleFonts.montserrat(
                                                                fontSize: 20,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black),
                                                          ),

                                                          const SizedBox(height: 10,),

                                                          Text(
                                                            'Consultant',
                                                            style: GoogleFonts.montserrat(
                                                                color: Colors.grey.shade800,
                                                                fontSize: 15
                                                            ),
                                                          ),

                                                          const SizedBox(height: 10,),

                                                          Text(
                                                            "Status: " + (snapshot.value as Map)["consultationStatus"].toString(),
                                                            style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold
                                                            ),
                                                          ),

                                                          const SizedBox(height: 10,),

                                                          ((TimeOfDay.now().hour == databaseTime.hour) &&
                                                              (TimeOfDay.now().minute >= databaseTime.minute && (TimeOfDay.now().minute <= (databaseTime.minute + 5))))  ?
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                child: ElevatedButton.icon(
                                                                  onPressed: ()  async {
                                                                    consultationId = (snapshot.value as Map)["id"];
                                                                    patientId = (snapshot.value as Map)["patientId"];
                                                                    consultantId = (snapshot.value as Map)["consultantId"];
                                                                    await setCIConsultationInfoToAccepted();
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

                                                      const SizedBox(width: 10,),

                                                      Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius
                                                                .circular(50),
                                                            color: Colors.blue
                                                        ),

                                                        height: 30,
                                                        width: 30,

                                                        child: Transform.rotate(
                                                          angle: 180 * pi / 180,
                                                          child: const Icon(
                                                            Icons.arrow_back_ios_new,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                        ),


                                                      ),

                                                    ],
                                                  ),

                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                ],
                              ),
                            );
                          }

                          else{
                            return GestureDetector(
                              onTap: (){
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ConsultationHistoryDetails()));
                                });
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0, 0), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        IntrinsicHeight(
                                          child: Row(
                                            children: [
                                              const VerticalDivider(color: Colors.blueAccent, thickness: 3,),

                                              const SizedBox(width: 10,),

                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text('Appointment Date',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.black),),

                                                          const SizedBox(height: 10,),

                                                          Row(
                                                            children: [
                                                              const Icon(Icons.access_time,size: 25,),

                                                              const SizedBox(width: 10,),

                                                              Text((snapshot.value as Map)["date"].toString(),style: const TextStyle(color: Colors.grey,fontSize: 15),),

                                                              const Text(' - '),

                                                              Text((snapshot.value as Map)["time"].toString(),style: const TextStyle(color: Colors.grey,fontSize: 15),),

                                                            ],
                                                          ),
                                                        ],
                                                      ),

                                                      SizedBox(width: MediaQuery.of(context).size.width-310,),

                                                    ],
                                                  ),

                                                  const SizedBox(height: 10,),

                                                  // Divider
                                                  Container(color: Colors.grey, height: 1, width: MediaQuery.of(context).size.width-80,),

                                                  const SizedBox(height: 15,),

                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                          radius: 30,
                                                          backgroundColor: Colors.grey[200],
                                                          foregroundImage: const AssetImage(
                                                              "assets/doctorImages/doctor-1.png"
                                                          )
                                                      ),

                                                      const SizedBox(width: 15,),

                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            (snapshot.value as Map)["consultantName"].toString(),
                                                            style: GoogleFonts.montserrat(
                                                                fontSize: 20,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black),
                                                          ),

                                                          SizedBox(height: height * 0.02,),

                                                          Text(
                                                            'Consultant',
                                                            style: GoogleFonts.montserrat(
                                                                color: Colors.grey.shade800,
                                                                fontSize: 15
                                                            ),
                                                          ),

                                                          SizedBox(height: height * 0.02,),

                                                          Text(
                                                            "Status: " + (snapshot.value as Map)["consultationStatus"].toString(),
                                                            style: GoogleFonts.montserrat(
                                                                fontWeight: FontWeight.bold
                                                            ),
                                                          ),

                                                          const SizedBox(height: 10,),

                                                          ((TimeOfDay.now().hour == databaseTime.hour) &&
                                                              (TimeOfDay.now().minute >= databaseTime.minute && (TimeOfDay.now().minute <= (databaseTime.minute + 5))))  ?
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                child: ElevatedButton.icon(
                                                                  onPressed: ()  async {
                                                                    consultationId = (snapshot.value as Map)["id"];
                                                                    patientId = (snapshot.value as Map)["patientId"];
                                                                    consultantId = (snapshot.value as Map)["consultantId"];
                                                                    await setCIConsultationInfoToAccepted();
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

                                                      const SizedBox(width: 15,),

                                                      Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius
                                                                .circular(50),
                                                            color: Colors.blue
                                                        ),

                                                        height: 30,
                                                        width: 30,

                                                        child: Transform.rotate(
                                                          angle: 180 * pi / 180,
                                                          child: const Icon(
                                                            Icons.arrow_back_ios_new,
                                                            color: Colors.white,
                                                            size: 20,
                                                          ),
                                                        ),


                                                      ),

                                                    ],
                                                  ),

                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                ],
                              ),
                            );
                          }

                        }

                        else{
                          return Container();
                        }
                      }
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
