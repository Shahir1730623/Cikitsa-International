import 'dart:async';

import 'package:app/common_screens/confirmation_page.dart';
import 'package:app/common_screens/coundown_screen.dart';
import 'package:app/models/patient_model.dart';
import 'package:app/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';
import '../main_screen.dart';

class PaymentScreen extends StatefulWidget {
  String? formattedDate;
  String? formattedTime;
  String? visitationReason;
  String? problem;
  PaymentScreen({Key? key,required this.formattedDate,required this.formattedTime,required this.visitationReason,required this.problem}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  void updatePaymentStatus(){
   DatabaseReference reference = FirebaseDatabase.instance.ref().child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId!);

   reference
       .child(selectedServiceDatabaseParentName!)
       .child(consultationId!)
       .child("payment").set("Paid");
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
        Fluttertoast.showToast(msg: "Successfully retrieved Patient Info");
        saveConsultationInfoForDoctor();
      }
      else{
        Fluttertoast.showToast(msg: "Unsuccessful to retrieve patient info");
      }
    });
  }

  void saveConsultationInfoForDoctor(){
    String consultationId = idGenerator();
    Map doctorLiveConsultationForDoctor = {
      "id" : consultationId,
      "date" : widget.formattedDate,
      "time" : widget.formattedTime,
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
      "consultationType" : "Upcoming",
      "visitationReason": widget.visitationReason,
      "problem": widget.problem,
      "payment" : "Paid"
    };

    DatabaseReference reference = FirebaseDatabase.instance.ref().child("Doctors").child(selectedDoctorInfo!.doctorId!).child("consultations").child(consultationId);
    reference.set(doctorLiveConsultationForDoctor);
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

                      // Update Payment information
                      updatePaymentStatus();
                      fetchPatientData();

                      Timer(const Duration(seconds: 3),()  {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmationPageScreen()));

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
