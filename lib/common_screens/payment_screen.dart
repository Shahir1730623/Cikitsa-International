import 'dart:async';


import 'package:app/assistants/assistant_methods.dart';
import 'package:app/common_screens/confirmation_page.dart';
import 'package:app/models/patient_model.dart';
import 'package:app/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../global/global.dart';
import '../models/consultation_payload_model.dart';
import '../models/doctor_model.dart';
import '../models/push_notification_screen.dart';
import '../service_file/local_notification_service.dart';

class PaymentScreen extends StatefulWidget {
  String? formattedDate;
  String? formattedTime;
  String? visitationReason;
  String? problem;
  String? selectedCenter;
  PaymentScreen({Key? key,required this.formattedDate,required this.formattedTime,required this.visitationReason,required this.problem,required this.selectedCenter}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final LocalNotificationService service;

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  void fetchPatientData(){
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId!);
    reference.once().then((snap) {
      final snapshot = snap.snapshot;
      if (snapshot.exists) {
        selectedPatientInfo = PatientModel.fromSnapshot(snapshot);
        if(selectedService == "Doctor Live Consultation"){
          saveConsultationInfoForPatient(); // Saving consultation info for patient and doctor
        }

        else if (selectedService == "Visa Consultation"){
          saveVisaInvitationInfoForPatient();
        }

      }
      else{
        Fluttertoast.showToast(msg: "Unsuccessful to retrieve patient info");
      }
    });
  }

  void saveConsultationInfoForPatient() async {
    Map consultationInfoMap = {
      "id" : consultationId,
      "date" : DateFormat('dd-MM-yyyy').format(DateTime.now()),
      "time" : DateFormat.jm().format(DateTime.now()),
      "doctorId" : selectedDoctorInfo!.doctorId,
      "doctorName" : "Dr. " + selectedDoctorInfo!.doctorFirstName! + " " + selectedDoctorInfo!.doctorLastName!,
      "doctorImageUrl" : selectedDoctorInfo!.doctorImageUrl,
      "specialization" : selectedDoctorInfo!.specialization,
      "doctorFee" : selectedDoctorInfo!.fee,
      "workplace" : selectedDoctorInfo!.workplace,
      "consultationType" : selectedDoctorInfo!.status == "Online" ? "Now" : "Upcoming",
      "visitationReason": widget.visitationReason,
      "problem": widget.problem,
      "payment" : "Paid",
    };

    DatabaseReference reference = FirebaseDatabase.instance.ref().child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId!)
        .child("consultations")
        .child(consultationId!);

    reference.set(consultationInfoMap);

    // Calling next method
    saveConsultationInfoForDoctor();

  }

  void saveConsultationInfoForDoctor(){
    Map doctorLiveConsultationForDoctor = {
      "id" : consultationId,
      "userId" : currentFirebaseUser!.uid,
      "date" : DateFormat('dd-MM-yyyy').format(DateTime.now()),
      "time" : DateFormat.jm().format(DateTime.now()),
      "consultantFee" : "500",
      "patientId" : selectedPatientInfo!.id!,
      "patientName" : "${selectedPatientInfo!.firstName!} ${selectedPatientInfo!.lastName!}",
      "patientAge" : selectedPatientInfo!.age!,
      "gender": selectedPatientInfo!.gender!,
      "height" : selectedPatientInfo!.height!,
      "weight" : selectedPatientInfo!.weight!,
      "doctorId" : selectedDoctorInfo!.doctorId,
      "doctorName" : "Dr. " + selectedDoctorInfo!.doctorFirstName! + " " + selectedDoctorInfo!.doctorLastName!,
      "specialization" : selectedDoctorInfo!.specialization,
      "consultationType" : selectedDoctorInfo!.status == "Online" ? "Now" : "Upcoming",
      "visitationReason": widget.visitationReason,
      "problem": widget.problem,
      "payment" : "Paid"
    };

    DatabaseReference reference = FirebaseDatabase.instance.ref()
        .child("Doctors")
        .child(selectedDoctorInfo!.doctorId!)
        .child("consultations")
        .child(consultationId!);

    reference.set(doctorLiveConsultationForDoctor);

    if(selectedDoctorInfo!.status == "Online"){
    }

    else{
      generateLocalNotification();
    }

  }

  void saveVisaInvitationInfoForPatient() async {
    Map visaInvitationInfoMap = {
      "id" : invitationId,
      "date" : DateFormat('dd-MM-yyyy').format(DateTime.now()),
      "time" : DateFormat.jm().format(DateTime.now()),
      "doctorId" : selectedDoctorInfo!.doctorId,
      "doctorName" : "Dr. " + selectedDoctorInfo!.doctorFirstName! + " " + selectedDoctorInfo!.doctorLastName!,
      "doctorImageUrl" : selectedDoctorInfo!.doctorImageUrl,
      "specialization" : selectedDoctorInfo!.specialization,
      "workplace" : selectedDoctorInfo!.workplace,
      "patientId" : patientId,
      "patientName" : patientName,
      "patientDateOfBirth" : patientDateOfBirth,
      "patientIdNo" : patientIDNo,
      "patientGender" : selectedPatientInfo!.gender,
      "patientWeight" : selectedPatientInfo!.weight,
      "patientHeight" : selectedPatientInfo!.height,
      "attendantName" : attendantName,
      "attendantDateOfBirth" : attendantDateOfBirth,
      "attendantIdNo" : attendantIDNo,
      "visitationReason": widget.visitationReason,
      "problem": widget.problem,
      "selectedVisaCenter" : widget.selectedCenter,
      "payment" : "Paid",
      "status" : "Waiting"
    };

    DatabaseReference reference = FirebaseDatabase.instance.ref().child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId!)
        .child("visaInvitation")
        .child(invitationId!);

    reference.set(visaInvitationInfoMap);
    saveVisaInvitationInfoForDoctor();
  }

  void saveVisaInvitationInfoForDoctor(){
    Map visaInvitationInfoMap = {
      "id" : invitationId,
      "userId" : currentFirebaseUser!.uid,
      "date" : DateFormat('dd-MM-yyyy').format(DateTime.now()),
      "time" : DateFormat.jm().format(DateTime.now()),
      "doctorId" : selectedDoctorInfo!.doctorId,
      "doctorName" : "Dr. " + selectedDoctorInfo!.doctorFirstName! + " " + selectedDoctorInfo!.doctorLastName!,
      "doctorImageUrl" : selectedDoctorInfo!.doctorImageUrl,
      "specialization" : selectedDoctorInfo!.specialization,
      "workplace" : selectedDoctorInfo!.workplace,
      "patientId" : patientId,
      "patientName" : patientName,
      "patientDateOfBirth" : patientDateOfBirth,
      "patientIdNo" : patientIDNo,
      "patientGender" : selectedPatientInfo!.gender,
      "patientWeight" : selectedPatientInfo!.weight,
      "patientHeight" : selectedPatientInfo!.height,
      "attendantName" : attendantName,
      "attendantDateOfBirth" : attendantDateOfBirth,
      "attendantIdNo" : attendantIDNo,
      "visitationReason": widget.visitationReason,
      "problem": widget.problem,
      "selectedVisaCenter" : widget.selectedCenter,
      "payment" : "Paid",
      "status" : "Waiting"
    };

    DatabaseReference reference = FirebaseDatabase.instance.ref().child("Doctors")
        .child(selectedDoctorInfo!.doctorId!)
        .child("visaInvitation")
        .child(invitationId!);

    reference.set(visaInvitationInfoMap);
    
  }

  Future<void> generateLocalNotification() async {
    // Converting time and date to yyyy-MM-dd 24 hour format for sending the time as param to showScheduledNotification()
    String dateTime = '${widget.formattedDate!} ${widget.formattedTime!}';
    Fluttertoast.showToast(msg: dateTime);
    ConsultationPayloadModel consultationPayloadModel = ConsultationPayloadModel(currentUserId: currentFirebaseUser!.uid, patientId: patientId!, selectedServiceName: selectedService, consultationId: consultationId!);
    String payloadJsonString = consultationPayloadModel.toJsonString();
    await service.showScheduledNotification(id: 0, title: "Appointment reminder", body: "You have appointment now. Click here to join", seconds: 1, payload: payloadJsonString, dateTime: dateTime);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
  }




  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.black,
        title: Text(
          "Payment",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Payment",
                style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
              SizedBox(height: height* 0.01,),
              Text(
                "Choose any payment from below",
                style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),

              SizedBox(height: height* 0.10,),

              Row(
                children: [
                  Flexible(child: Image.asset("assets/Bkash-logo.png",width: 70,)),
                  SizedBox(width: 10,),
                  Text(
                    "Pay with Bkash",
                    style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                ],
              ),

              SizedBox(height: height* 0.03,),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              SizedBox(height: height* 0.03,),

              Row(
                children: [
                  Flexible(child: Image.asset("assets/Nagad-Logo.png",width: 70,)),
                  SizedBox(width: 10,),
                  Text(
                    "Pay with Nagad",
                    style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                ],
              ),

              SizedBox(height: height* 0.03),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              SizedBox(height: height* 0.03,),

              Row(
                children: [
                  SizedBox(width: 10,),
                  Flexible(child: Image.asset("assets/Mastercard-logo.png",width: 50,)),
                  SizedBox(width: 25,),
                  Text(
                    "Pay with Card",
                    style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                ],
              ),

              SizedBox(height: height* 0.1,),

              // Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: ()  {
                    //
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xffEFEFEF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),

                  icon: Image.asset("assets/security.png",width: 20,),

                  label: Text(
                    "Payment is 100% secured",
                    style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                ),
              ),

              SizedBox(height: height* 0.1,),

              // Payment Button
              Center(
                child: SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ()  {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context){
                            return ProgressDialog(message: "");
                          }
                      );

                      fetchPatientData();

                      Timer(const Duration(seconds: 3),()  {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfirmationPageScreen()));

                      });
                    },
                    style: ElevatedButton.styleFrom(
                        primary: (Colors.lightBlue),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),

                    child: Text(
                      "Pay Now",
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
        ),
      ),
    );
  }
}
