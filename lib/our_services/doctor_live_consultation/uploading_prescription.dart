import 'package:app/global/global.dart';
import 'package:app/widgets/prescription_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/doctor_model.dart';

class UploadingPrescription extends StatefulWidget {
  const UploadingPrescription({Key? key}) : super(key: key);

  @override
  State<UploadingPrescription> createState() => _UploadingPrescriptionState();
}

class _UploadingPrescriptionState extends State<UploadingPrescription> {
  //String patientLength = "0";

  setConsultationInfoToCompleted(){
    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId!)
        .child("consultations")
        .child(consultationId!)
        .child("consultationType")
        .set("Completed");

    removePatientFromQueue();
  }

  removePatientFromQueue(){
    DatabaseReference reference = FirebaseDatabase.instance.ref('Doctors').child(selectedConsultationInfo!.doctorId!);
    reference.once().then((snapData) {
      DataSnapshot snapshot = snapData.snapshot;
      if(snapshot.value != null){
        int count = int.parse((snapshot.value as Map)["patientQueueLength"].toString());
        reference.child('patientQueueLength').set((count - 1).toString());
      }

    });

    FirebaseDatabase.instance.ref('Doctors').child(selectedConsultationInfo!.doctorId!).child('patientQueue').child(consultationId!).remove();

  }

  setCIConsultationInfoToCompleted(){
    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId!)
        .child("CIConsultations")
        .child(consultationId!)
        .child("consultationStatus")
        .set("Completed");

    removePatientFromQueueForConsultant();
  }

  removePatientFromQueueForConsultant(){
    DatabaseReference reference = FirebaseDatabase.instance.ref('Consultant').child(selectedCIConsultationInfo!.consultantId!);
    reference.once().then((snapData) {
      DataSnapshot snapshot = snapData.snapshot;
      if(snapshot.value != null){
        int count = int.parse((snapshot.value as Map)["patientQueueLength"].toString());
        reference.child('patientQueueLength').set((count - 1).toString());
      }

    });

    FirebaseDatabase.instance.ref('Consultant').child(selectedCIConsultationInfo!.consultantId!).child('patientQueue').child(consultationId!).remove();
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you want to exit the App?'),
        actions:[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child:Text('No'),
          ),

          ElevatedButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            //return true when click on "Yes"
            child:Text('Yes'),
          ),

        ],
      ),
    )??false; //if showDialog had returned null, then return false
  }

  void loadScreen() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return const PrescriptionDialog();
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      loadScreen();
    });

    if(selectedService == "Doctor Live Consultation"){
      setConsultationInfoToCompleted();
    }

    else{
      setCIConsultationInfoToCompleted();
    }

  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: showExitPopup,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: (selectedService == "CI Consultation") ?
                  CircleAvatar(
                    //or 15.0
                    radius: 60,
                    backgroundColor: Colors.grey[100],
                    foregroundImage: const AssetImage(
                      "assets/doctor_new.png",
                    ),
                  ) :
                  CircleAvatar(
                    //or 15.0
                    radius: 60,
                    backgroundColor: Colors.grey[100],
                    foregroundImage: NetworkImage(
                      selectedConsultationInfo!.doctorImageUrl!,
                    ),
                  )
                ),

                SizedBox(height: height * 0.03),
                Text(
                  (selectedService == "CI Consultation") ? selectedCIConsultationInfo!.consultantName!: selectedConsultationInfo!.doctorName!,
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),

                SizedBox(height: height * 0.02),

                Text(
                  (selectedService == "CI Consultation") ? "Consultant": selectedConsultationInfo!.specialization!,
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 20),
                ),

                SizedBox(height: height * 0.5),
                Text(
                  "This may take several minutes",
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
