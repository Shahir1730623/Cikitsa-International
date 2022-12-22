import 'dart:async';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../assistants/assistant_methods.dart';
import '../global/global.dart';
import '../models/ci_consultation_model.dart';
import '../models/consultation_payload_model.dart';
import '../models/push_notification_screen.dart';
import '../service_file/local_notification_service.dart';
import '../widgets/progress_dialog.dart';

class CIConsultationDetailsConsultant extends StatefulWidget {
  const CIConsultationDetailsConsultant({Key? key}) : super(key: key);

  @override
  State<CIConsultationDetailsConsultant> createState() => _CIConsultationDetailsConsultantState();
}

class _CIConsultationDetailsConsultantState extends State<CIConsultationDetailsConsultant> {
  late final LocalNotificationService service;
  TextEditingController patientIdTextEditingController = TextEditingController(text: "");
  TextEditingController patientNameTextEditingController = TextEditingController(text: "");
  TextEditingController patientAgeTextEditingController = TextEditingController(text: "");
  TextEditingController patientCountryTextEditingController = TextEditingController(text: "");
  TextEditingController genderTextEditingController = TextEditingController(text: "");

  void retrievePatientDataFromDatabase() {
    FirebaseDatabase.instance.ref()
        .child("CIConsultationRequests")
        .child(consultationId!)
        .once()
        .then((dataSnap){
      final DataSnapshot snapshot = dataSnap.snapshot;
      if (snapshot.exists) {
        selectedCIConsultationInfo = CIConsultationModel.fromSnapshot(snapshot);
        patientIdTextEditingController.text = (snapshot.value as Map)["patientId"];
        patientNameTextEditingController.text = (snapshot.value as Map)["patientName"];
        patientAgeTextEditingController.text = (snapshot.value as Map)["patientAge"];
        patientCountryTextEditingController.text = (snapshot.value as Map)["country"];
        genderTextEditingController.text = (snapshot.value as Map)["gender"];
      }

      else {
        Fluttertoast.showToast(msg: "No Patient record exist with this credentials");
      }
    });
  }

  setCIConsultationInfoToUpcoming() async {
    Map consultantCIConsultationInfoMap = {
      "id" : consultationId,
      "userId" : selectedCIConsultationInfo!.userId!,
      "date" : selectedCIConsultationInfo!.date,
      "time" : selectedCIConsultationInfo!.time!,
      "patientId" : selectedCIConsultationInfo!.patientId!,
      "patientName" : selectedCIConsultationInfo!.patientName!,
      "patientAge" : selectedCIConsultationInfo!.patientAge!,
      "gender" : selectedCIConsultationInfo!.gender!,
      "height" : selectedCIConsultationInfo!.height!,
      "weight" : selectedCIConsultationInfo!.weight!,
      "country" : selectedCIConsultationInfo!.selectedCountry,
      "consultantId" : currentConsultantInfo!.id!,
      "consultantName" : currentConsultantInfo!.name!,
      "consultantFee" : "500",
      "consultationStatus" : "Upcoming",
      "visitationReason": selectedCIConsultationInfo!.visitationReason,
      "problem": selectedCIConsultationInfo!.problem!,
      "payment" : "Paid",
    };

    FirebaseDatabase.instance.ref()
        .child("Consultant")
        .child(currentFirebaseUser!.uid)
        .child("CIConsultations")
        .child(consultationId!)
        .set(consultantCIConsultationInfoMap);

    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(selectedCIConsultationInfo!.userId!)
        .child("patientList")
        .child(selectedCIConsultationInfo!.patientId!)
        .child("CIConsultations")
        .child(consultationId!).child("consultationStatus").set("Upcoming");

    FirebaseDatabase.instance.ref()
        .child("CIConsultationRequests")
        .child(consultationId!)
        .remove();

    getRegistrationTokenForUserAndNotify();
  }

  void getRegistrationTokenForUserAndNotify(){
    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(userId!)
        .child("tokens").once().then((snapData) async {
      DataSnapshot snapshot = snapData.snapshot;
      if(snapshot.value != null){
        String deviceRegistrationToken = snapshot.value.toString();
        // send notification now
        await AssistantMethods.sendCIConsultationPushNotificationToPatientNow(deviceRegistrationToken, selectedCIConsultationInfo!.patientId!, selectedService, context);
        Fluttertoast.showToast(msg: "Notification sent to patient successfully");
        generateLocalNotification();
      }

      else{
        Fluttertoast.showToast(msg: "Error sending notifications");
      }
    });
  }

  Future<void> generateLocalNotification() async{
    var df = DateFormat.jm().parse(selectedCIConsultationInfo!.time!);
    DateTime date = DateFormat("dd-MM-yyyy").parse(selectedCIConsultationInfo!.date!);
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    String formattedTime = DateFormat('HH:mm').format(df);
    dateTime =  formattedDate + " " + formattedTime;
    Fluttertoast.showToast(msg: dateTime!);

    ConsultationPayloadModel consultationPayloadModel = ConsultationPayloadModel(currentUserId: currentFirebaseUser!.uid, patientId: selectedCIConsultationInfo!.patientId!, selectedServiceName: "CI Consultation", consultationId: consultationId!);
    String payloadJsonString = consultationPayloadModel.toJsonString();
    await service.showScheduledNotification(id: 0, title: "Appointment reminder", body: "You have CI Appointment Now. Click here to join", seconds: 1, payload: payloadJsonString, dateTime: dateTime!);
  }

  void listenToNotification(){
    service.onNotificationClick.stream.listen(onNotificationListener);
  }

  void onNotificationListener(String? payload){
    if(payload!=null && payload.isNotEmpty){
      //ConsultationPayloadModel? p = ConsultationPayloadModel.fromJsonString(payload);
      //print(p.patientId + " " + p.selectedServiceName + " " + p.consultationId);
      Navigator.push(context, MaterialPageRoute(builder: (context) => PushNotificationScreen(payload:payload)));
    }
    else{
      Fluttertoast.showToast(msg: 'payload empty');
    }
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
      retrievePatientDataFromDatabase();
    });

    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
                )
            ),

            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
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

                              SizedBox(width: height * 0.040),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "History Details",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: height * 0.05,),

                          // Patient Name
                          Text(
                            "Patient Name",
                            style: GoogleFonts.montserrat(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          TextFormField(
                            controller: patientNameTextEditingController,
                            readOnly: true,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: "Name",
                              hintText: "Name",
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.person),
                                onPressed: () {},
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(color: Colors.black, fontSize: 15),
                            ),

                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),

                          // Patient Id
                          Text(
                            "Patient ID",
                            style: GoogleFonts.montserrat(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                                color: Colors.blue
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          TextFormField(
                            controller: patientIdTextEditingController,
                            readOnly: true,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: "ID",
                              hintText: "ID",
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.numbers),
                                onPressed: () {},
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(color: Colors.black, fontSize: 15),
                            ),

                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),

                          // Patient Age
                          Text(
                            "Patient Age",
                            style: GoogleFonts.montserrat(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                                color: Colors.blue
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          TextFormField(
                            controller: patientAgeTextEditingController,
                            readOnly: true,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: "Age",
                              hintText: "Age",
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.calendar_month),
                                onPressed: () {},
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(color: Colors.black, fontSize: 15),
                            ),

                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),

                          // Patient Country
                          Text(
                            "Country",
                            style: GoogleFonts.montserrat(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                                color: Colors.blue
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          TextFormField(
                            controller: patientCountryTextEditingController,
                            readOnly: true,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: "Country",
                              hintText: "Country",
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.add_location_alt),
                                onPressed: () {},
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(color: Colors.black, fontSize: 15),
                            ),

                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),

                          // Patient Gender
                          Text(
                            "Gender",
                            style: GoogleFonts.montserrat(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                                color: Colors.blue
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          TextFormField(
                            controller: genderTextEditingController,
                            readOnly: true,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: "Gender",
                              hintText: "Gender",
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.people_alt),
                                onPressed: () {},
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(color: Colors.black, fontSize: 15),
                            ),

                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),

                          Text(
                            "Consultation Information",
                            style: GoogleFonts.montserrat(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),
                          ),

                          SizedBox(height: height * 0.02,),

                          DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            color: Colors.blue,
                            dashPattern: [10,5],
                            strokeWidth: 1,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Consultation ID
                                      Text(
                                        "Consultation ID",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Text(
                                        selectedCIConsultationInfo!.id!,
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),

                                      // Consultant Name
                                      Text(
                                        "Consultant Name",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Text(
                                        selectedCIConsultationInfo!.consultantName!,
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),

                                      // Consultant Fee
                                      Text(
                                        "Consultant Fee",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Text(
                                        "৳" + selectedCIConsultationInfo!.consultantFee!,
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),

                                      // Visitation Reason
                                      Text(
                                        "Visitation Reason",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Text(
                                        selectedCIConsultationInfo!.visitationReason!,
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),

                                      // Sickness (in details)
                                      Text(
                                        "Sickness (in details)",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.01,
                                      ),
                                      Text(
                                        selectedCIConsultationInfo!.problem!,
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),
                                    ],
                                  ),
                                ],


                              ),
                            ),
                          ),

                          SizedBox(height: height * 0.03,),

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

                                      setCIConsultationInfoToUpcoming();

                                      Timer(const Duration(seconds: 5),()  {
                                        Navigator.pop(context);
                                        var snackBar = const SnackBar(content: Text("Consultation request sent successfully"));
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

                                      //setConsultationInfoToUpcoming();

                                      Timer(const Duration(seconds: 5),()  {
                                        Navigator.pop(context);
                                        var snackBar = const SnackBar(content: Text("Consultation request sent successfully"));
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      });

                                    },

                                    style: ElevatedButton.styleFrom(
                                        primary: (Colors.blue),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20))),

                                    child: Text(
                                      "Reschedule",
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
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
