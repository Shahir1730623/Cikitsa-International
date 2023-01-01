import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:path_provider/path_provider.dart';import '../../global/global.dart';
import '../../widgets/progress_dialog.dart';class VisaInvitationDetails extends StatefulWidget {
  const VisaInvitationDetails({Key? key}) : super(key: key);

  @override
  State<VisaInvitationDetails> createState() => _VisaInvitationDetailsState();
}

class _VisaInvitationDetailsState extends State<VisaInvitationDetails> {
  String imageUrl = "";
  bool flag = false;
  late Future<ListResult> futureFiles;

  Future<void> checkPrescriptionStatus() async {
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('invitationImages/'+ invitationId! + "/documents/Invitation_Letter.png" );
    try{
      imageUrl = await reference.getDownloadURL();
    }

    catch(e){
      print(e);
    }

    if(imageUrl.isNotEmpty){
      setState(() {
        flag = true;
      });

    }
    else{
      setState(() {
        flag = false;
      });
    }
  }

  Future downloadFiles(Reference reference) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "");
        }
    );

    final url = await reference.getDownloadURL();

    // Not visible to user, only app can access this file
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/${reference.name}';
    await Dio().download(url, path); // Download file

    //await reference.writeToFile(path); // Save downloaded file locally
    try{
      await GallerySaver.saveImage(path,toDcim: true);
    }

    catch(e){
      print(e);
    }

    Navigator.pop(context);
    var snackBar = SnackBar(content: Text("Downloaded ${reference.name}"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPrescriptionStatus();
    futureFiles = firebase_storage.FirebaseStorage.instance.ref('invitationImages/'+ invitationId! + "/documents").listAll();
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Text(
          "Invitation details",
          style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
        ),

        leading: GestureDetector(
          onTap: () {
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

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
                  )
              ),
              child: Image.network(
                selectedVisaInvitationInfo!.doctorImageUrl!,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: height * 0.02),

            Text(
              "Dr. " + selectedVisaInvitationInfo!.doctorName!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),

            SizedBox(height: height * 0.025,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                Text(
                  "Invitation Information",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(
                  height: 30,
                  thickness: 0.5,
                  color: Colors.black,
                ),

              ],
            ),

            const Divider(
              height: 10,
              thickness: 1,
              color: Colors.blue,
            ),

            SizedBox(height: height * 0.010,),

            // Visa Invitation ID
            Text(
              "Visa Invitation ID",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),
            SizedBox(height: height * 0.010,),
            Text(
              "#${selectedVisaInvitationInfo!.id!}",
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.020,),

            // Patient Name
            Text(
              "Patient Name",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),
            SizedBox(height: height * 0.010,),
            Text(
              selectedVisaInvitationInfo!.patientGivenName! + " " + selectedVisaInvitationInfo!.patientSurname!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.020,),

            // Passport Number
            Text(
              "Passport Number",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),
            SizedBox(height: height * 0.010,),
            Text(
              selectedVisaInvitationInfo!.passportNumber!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.020,),

            // Patient Date of Birth
            Text(
              "Date of Birth",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),
            SizedBox(height: height * 0.010,),
            Text(
              selectedVisaInvitationInfo!.dateOfBirth!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.020,),

            // Nationality
            Text(
              "Nationality",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),
            SizedBox(height: height * 0.010,),
            Text(
              selectedVisaInvitationInfo!.nationality!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.020,),

            // Nationality
            Text(
              "Gender",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),
            SizedBox(height: height * 0.010,),
            Text(
              selectedVisaInvitationInfo!.gender!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.020,),

            // Patient Height
            Text(
              "Height",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),
            SizedBox(height: height * 0.010,),
            Text(
              selectedVisaInvitationInfo!.patientHeight! + " feet",
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.020,),

            // Patient Weight
            Text(
              "Weight",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),
            SizedBox(height: height * 0.010,),
            Text(
              selectedVisaInvitationInfo!.patientWeight! + " kg",
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.020,),

            // Attendant Name
            Text(
              "Attendant Name",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),
            SizedBox(height: height * 0.010,),
            Text(
              selectedVisaInvitationInfo!.attendantGivenName! + " " +selectedVisaInvitationInfo!.patientSurname!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.020,),

            // Attendant DOB
            Text(
              "Attendant Passport Number",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),
            SizedBox(height: height * 0.010,),
            Text(
              selectedVisaInvitationInfo!.attendantPassportNumber!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.020,),

            // Attendant Id No
            Text(
              "Attendant Nationality",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),
            SizedBox(height: height * 0.010,),
            Text(
              selectedVisaInvitationInfo!.attendantNationality!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.020,),

            // Attendant Id No
            Text(
              "Attendant Date of Birth",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),
            SizedBox(height: height * 0.010,),
            Text(
              selectedVisaInvitationInfo!.attendantDateOfBirth!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.020,),

            // Attendant Id No
            Text(
              "Attendant Gender",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),
            SizedBox(height: height * 0.010,),
            Text(
              selectedVisaInvitationInfo!.attendantGender!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.020,),

            // visitation reason
            Text(
              "Patient visitation reason",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),
            SizedBox(height: height * 0.010,),
            Text(
              selectedVisaInvitationInfo!.visitationReason!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.020,),

            // Problem
            Text(
              "Patient Sickness (In details)",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),
            SizedBox(height: height * 0.010,),
            Text(
              selectedVisaInvitationInfo!.problem!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.020,),

            // Visa center
            Text(
              "Visa Center",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),
            SizedBox(height: height * 0.010,),
            Text(
              selectedVisaInvitationInfo!.selectedVisaCenter!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.020,),


            Text(
              "Invitation Status",
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: const Color(0x59090808)
              ),
            ),
            SizedBox(height: height * 0.010,),

            Text(
              selectedVisaInvitationInfo!.status!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(left: 15,right: 15),
              child: Divider(
                height: 50,
                thickness: 1,
                color: Colors.blue,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15,top: 5, bottom: 0),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: ()  async {
                    if(flag == true){
                      firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('invitationImages/'+ invitationId! + "/documents/Invitation_Letter.png" );
                      downloadFiles(reference);
                    }

                    else{
                      var snackBar = const SnackBar(content: Text("Prescription still not uploaded..."));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }

                  },

                  style: ElevatedButton.styleFrom(
                      backgroundColor: (flag) ? Colors.blue : Colors.grey[300],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),

                  icon: const Icon(Icons.contact_page),
                  label: Text(
                    "Download Invitation Letter",
                    style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
