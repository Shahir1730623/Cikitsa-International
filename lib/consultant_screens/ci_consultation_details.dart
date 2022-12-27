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
import '../models/consultation_payload_model.dart';
import '../models/push_notification_screen.dart';
import '../navigation_service.dart';
import '../service_file/local_notification_service.dart';
import '../widgets/progress_dialog.dart';

class CIConsultationDetails extends StatefulWidget {
  const CIConsultationDetails({Key? key}) : super(key: key);

  @override
  State<CIConsultationDetails> createState() => _CIConsultationDetailsState();
}

class _CIConsultationDetailsState extends State<CIConsultationDetails> {
  late final LocalNotificationService service;
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  String? formattedDate,formattedTime;
  int dateCounter = 0;
  int timeCounter = 0;
  bool flag = false;


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
        patientCountryTextEditingController.text = (snapshot.value as Map)['country'];
        genderTextEditingController.text = (snapshot.value as Map)['gender'];
        patientIdTextEditingController.text = (snapshot.value as Map)['patientId'];
        patientNameTextEditingController.text = (snapshot.value as Map)['patientName'];
        patientAgeTextEditingController.text = (snapshot.value as Map)['patientAge'];
      }

      else {
        FirebaseDatabase.instance.ref()
            .child("Consultant")
            .child(currentFirebaseUser!.uid)
            .child("CIConsultations")
            .child(consultationId!)
            .once()
            .then((dataSnap) {
          final DataSnapshot snapshot = dataSnap.snapshot;
          if (snapshot.exists) {
            patientCountryTextEditingController.text = (snapshot.value as Map)['country'];
            genderTextEditingController.text = (snapshot.value as Map)['gender'];
            patientIdTextEditingController.text = (snapshot.value as Map)['patientId'];
            patientNameTextEditingController.text = (snapshot.value as Map)['patientName'];
            patientAgeTextEditingController.text = (snapshot.value as Map)['patientAge'];
          }
        });
      }
   });

  }

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


  setCIConsultationInfoToUpcoming() async {
    Map consultantCIConsultationInfoMap = {
      "id" : consultationId,
      "userId" : selectedCIConsultationInfo!.userId!,
      "date" : formattedDate,
      "time" : formattedTime,
      "patientId" : selectedCIConsultationInfo!.patientId!,
      "patientName" : selectedCIConsultationInfo!.patientName!,
      "patientAge" : selectedCIConsultationInfo!.patientAge!,
      "gender" : selectedCIConsultationInfo!.gender!,
      "height" : selectedCIConsultationInfo!.height!,
      "weight" : selectedCIConsultationInfo!.weight!,
      "country" : selectedCIConsultationInfo!.selectedCountry,
      "consultantId" : currentConsultantInfo!.id,
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
        .child(consultationId!)
        .set(consultantCIConsultationInfoMap);

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
        await AssistantMethods.sendCIConsultationPushNotificationToPatientNow(deviceRegistrationToken, selectedCIConsultationInfo!.patientId!, "CI Consultation", context);
        Fluttertoast.showToast(msg: "Notification sent to patient successfully");
        generateLocalNotification();
      }

      else{
        Fluttertoast.showToast(msg: "Error sending notifications");
      }
    });
  }

  Future<void> generateLocalNotification() async{
    var df = DateFormat.jm().parse(formattedTime!);
    DateTime date = DateFormat("dd-MM-yyyy").parse(formattedDate!);
    String formattedD = DateFormat('yyyy-MM-dd').format(date);
    String formattedT = DateFormat('HH:mm').format(df);
    dateTime =  formattedD + " " + formattedT;
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
     Navigator.push(NavigationService.navigatorKey.currentContext!, MaterialPageRoute(builder: (context) => PushNotificationScreen(payload:payload)));
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

                          (selectedCIConsultationInfo!.consultationStatus == "Waiting")
                              ? Column(
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

                                          setCIConsultationInfoToUpcoming();

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
