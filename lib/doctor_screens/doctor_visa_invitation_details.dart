import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../assistants/assistant_methods.dart';
import '../global/global.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../navigation_service.dart';
import '../widgets/progress_dialog.dart';

class DoctorVisaInvitationDetails extends StatefulWidget {
  const DoctorVisaInvitationDetails({Key? key}) : super(key: key);

  @override
  State<DoctorVisaInvitationDetails> createState() => _DoctorVisaInvitationDetailsState();
}

class _DoctorVisaInvitationDetailsState extends State<DoctorVisaInvitationDetails> {
  String imageUrl = "";
  bool flag = false;
  late Future<ListResult> futureFiles;
  List<File> imageList = [];


  Future pickImages() async {
    try{
      final pickedImages = await ImagePicker().pickMultiImage();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ProgressDialog(message: "");
          }
      );
      //var file = await ImageCropper().cropImage(sourcePath: pickedImage.path,aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
      pickedImages.forEach((image) {
        imageList.add(File(image.path));
      });
      setState(() {});
      Navigator.pop(context);
    }

    catch(e){
      print(e);
    }
  }

  Future downloadFile(Reference reference) async {
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

    Navigator.pop(NavigationService.navigatorKey.currentContext!);
    var snackBar = SnackBar(content: Text("Downloaded ${reference.name}"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  Future<void> uploadFile(File file) async {
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('invitationImages/'+ selectedVisaInvitationInfo!.id! + "/documents/Invitation_Letter.png" );

    // Upload the image to firebase storage
    try{
      await reference.putFile(File(file.path));
      //imageUrl = await reference.getDownloadURL();
    }

    catch(e){
      print(e);
    }

    //String url = await reference.getDownloadURL();
    //return url;

    setStatusToCompleted();

  }


  void setStatusToCompleted(){
    FirebaseDatabase.instance.ref()
        .child("Doctors")
        .child(currentFirebaseUser!.uid)
        .child('visaInvitation')
        .child(selectedVisaInvitationInfo!.id!)
        .child('status').set("Accepted");

    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(selectedVisaInvitationInfo!.userId!)
        .child('patientList')
        .child(selectedVisaInvitationInfo!.patientId!)
        .child('visaInvitation')
        .child(selectedVisaInvitationInfo!.id!)
        .child('status').set("Accepted");

    sendNotificationToUser();

  }

  void sendNotificationToUser(){
    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(selectedVisaInvitationInfo!.userId!)
        .child("tokens").once().then((snapData){
      DataSnapshot snapshot = snapData.snapshot;
      if(snapshot.value != null){
        String deviceRegistrationToken = snapshot.value.toString();
        // send notification now
        AssistantMethods.sendInvitationPushNotificationToPatientNow(deviceRegistrationToken, selectedVisaInvitationInfo!.id!,selectedVisaInvitationInfo!.patientId!, context);
        Fluttertoast.showToast(msg: "Notification sent successfully");
      }

      else{
        Fluttertoast.showToast(msg: "Error sending notifications");
      }
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureFiles = firebase_storage.FirebaseStorage.instance.ref('invitationImages/'+ selectedVisaInvitationInfo!.id! + "/documents").listAll();
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
                currentDoctorInfo!.doctorImageUrl!,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: height * 0.02),

            Text(
              "Dr. ${currentDoctorInfo!.doctorFirstName!} ${currentDoctorInfo!
                  .doctorLastName!}",
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


            // Patient Name
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

            // Patient Date of Birth
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

            // Patient Id No
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

            const Divider(
              height: 50,
              thickness: 1,
              color: Colors.blue,
            ),

            Text(
              "Download Reports and Prescriptions",
              style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
            SizedBox(height: height * 0.020,),

            FutureBuilder<ListResult>(
              future: futureFiles,
              builder: (context, snapshot) {
                final List<Reference> files;
                if(snapshot.hasData){
                  files = snapshot.data!.items;
                }
                else if(snapshot.hasError){
                  return const Center(child: Text('Error Occurred'));
                }

                else{
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: files.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final file = files[index];

                    return ListTile(
                      title: Text(file.name),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.download,
                          color: Colors.black,
                        ),

                        onPressed: () {
                          downloadFile(file);
                        },
                      ),
                    );
                  },
                );
              },
            ),

            const Divider(
              height: 30,
              thickness: 1,
              color: Colors.blue,
            ),

            // Uploaded Image Container
            GestureDetector(
              onTap: () async {
                await pickImages();
                var snackBar = const SnackBar(content: Text("Uploaded successfully"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black,
                    width: 0.5,
                    style: BorderStyle.solid,
                  ),
                ) ,
                child: Row(
                    children: [
                      Image.asset("assets/add-image.png",width: 40,),

                      const SizedBox(width: 10,),

                      Expanded(
                        child: Text(
                            "Upload report and previous prescriptions",
                            style: GoogleFonts.montserrat(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            )
                        ),
                      ),
                    ]
                ),
              ),
            ),

            // Display Image Container
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                width: Get.width,
                height: 150,
                child: imageList.isEmpty
                    ? const Center(
                  child: Text("No Images found"),
                )
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, i) {
                    return Container(
                        width: 100,
                        margin: EdgeInsets.only(right: 10),
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(2)),
                        child: Image.file(
                          imageList[i],
                          fit: BoxFit.cover,
                        ));
                  },

                  itemCount: imageList.length,
                ),
              ),
            ),

            SizedBox(height: height * 0.02,),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: ()  async {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context){
                          return ProgressDialog(message: "Please wait...");
                        }
                    );

                    for (int i = 0; i < imageList.length; i++) {
                      await uploadFile(imageList[i]);
                      //downloadUrls.add(url);
                    }

                    Timer(const Duration(seconds: 5),()  {
                      Navigator.pop(context);
                      var snackBar = const SnackBar(content: Text("Invitation sent successfully"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pop(context);
                    });

                  },

                  style: ElevatedButton.styleFrom(
                      primary: (Colors.blue),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),

                  child: Text(
                    "Upload Invitation",
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