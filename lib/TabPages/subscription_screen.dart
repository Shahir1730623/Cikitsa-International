import 'package:app/splash_screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/doctor_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController specializationTextEditingController = TextEditingController();
  TextEditingController experienceTextEditingController = TextEditingController();
  TextEditingController workplaceTextEditingController = TextEditingController();
  TextEditingController feeTextEditingController = TextEditingController();

  static List<DoctorModel> doctorList = [
    //DoctorModel("1", "Dr. Ventakesh Rajkumar", "Orthopedics", "MBBS, MPH, MS(Orthopedics),FCSPS(Orthopedics)", "10", "Evercare Hospital", "5", "10", "500","Online"),
    //DoctorModel("2", "Dr. Narendar Dasaraju", "Orthopedics", "MBBS, MPH, MS(Orthopedics),FCSPS(Orthopedics)", "15", "Square Hospital", "5", "10", "500","Online"),
    //DoctorModel("3", "Dr. Rajesh Krishnamoorhty", "Orthopedics", "MBBS, MPH, MS(Orthopedics),FCSPS(Orthopedics)", "15", "United Hospital", "5", "10", "500","Offline"),
  ];

  void saveExistingUserConsultationInfo() async {
    for(int index=0; index < doctorList.length; index++){
      firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('doctorImages/doctor-' + (index+1).toString() +'.png');
      var imageUrl = await reference.getDownloadURL();
      Map doctorInfoMap = {
        "id" : doctorList[index].doctorId,
        //"name" : doctorList[index].doctorName,
        "specialization" : doctorList[index].specialization,
        "degrees" : doctorList[index].degrees,
        "experience" : doctorList[index].experience,
        "workplace" : doctorList[index].workplace,
        "rating" : doctorList[index].rating,
        "totalVisits" : doctorList[index].totalVisits,
        "fee" :  doctorList[index].fee,
        "status" :  doctorList[index].status,
        "imageUrl" : imageUrl
      };

      FirebaseDatabase.instance.ref().child("Doctors")
          .child(doctorList[index].doctorId.toString())
          .set(doctorInfoMap);

      Fluttertoast.showToast(msg: "Doctor " + (index + 1).toString() + " has been saved in database");

    }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveExistingUserConsultationInfo();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Register As a doctor",
                  style: GoogleFonts.montserrat(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),

              ],
            ),
          ),
        ),
      );


}
}
