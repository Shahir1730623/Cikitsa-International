import 'dart:async';
import 'dart:convert';

import 'package:app/assistants/assistant_methods.dart';
import 'package:app/common_screens/confirmation_page.dart';
import 'package:app/models/patient_model.dart';
import 'package:app/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../global/global.dart';
import '../main_screen.dart';

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
      "consultationType" : "Now",
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
    sendNotificationToDoctor();
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

  sendNotificationToDoctor(){
    FirebaseDatabase.instance.ref()
        .child("Doctors")
        .child(selectedDoctorInfo!.doctorId!)
        .child("tokens").once().then((snapData){
          DataSnapshot snapshot = snapData.snapshot;
          if(snapshot!=null){
            String deviceRegistrationToken = snapshot.value.toString();
            // send notification now
            AssistantMethods.sendPushNotificationToDoctorNow(deviceRegistrationToken,context);
            Fluttertoast.showToast(msg: "Notification sent successfully");
          }

          else{
            Fluttertoast.showToast(msg: "Error sending notifications");
          }
    });

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
