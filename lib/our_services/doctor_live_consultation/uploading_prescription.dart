import 'package:app/global/global.dart';
import 'package:app/widgets/prescription_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/doctor_model.dart';

class UploadingPrescription extends StatefulWidget {
  const UploadingPrescription({Key? key}) : super(key: key);

  @override
  State<UploadingPrescription> createState() => _UploadingPrescriptionState();
}

class _UploadingPrescriptionState extends State<UploadingPrescription> {
  setConsultationInfoToCompleted(){
    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId!).child(selectedServiceDatabaseParentName!).child(consultationId!).child("consultationType").set("Completed");

    FirebaseDatabase.instance.ref()
        .child("Doctors")
        .child(selectedDoctorInfo!.doctorId!)
        .child("consultations")
        .child(consultationId!).child("consultationType").set("Completed");

    removePatientFromQueue();
  }

  removePatientFromQueue(){
    FirebaseDatabase.instance.ref('Doctors').child(doctorId!).once().then((snapData) {
      DataSnapshot snapshot = snapData.snapshot;
      if(snapshot.value != null){
        final map = snapshot.value as Map<dynamic, dynamic>;
        map.forEach((key, value) {
          selectedDoctorInfo = DoctorModel.fromSnapshot(snapshot);
        });
      }
    });

    String count = (int.parse(selectedDoctorInfo!.patientQueueLength.toString()) - 1).toString();
    FirebaseDatabase.instance.ref('Doctors').child(doctorId!).child('patientQueueLength').set(count);
    FirebaseDatabase.instance.ref('Doctors').child(doctorId!).child('patientQueue').child(count).remove();
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
      setConsultationInfoToCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
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

              SizedBox(height: height * 0.05),
              Text(
                (selectedService == "CI Consultation") ? selectedCIConsultationInfo!.consultantName!: selectedConsultationInfo!.doctorName!,
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
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
    );
  }
}
