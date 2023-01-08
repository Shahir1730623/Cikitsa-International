import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import '../assistants/assistant_methods.dart';
import '../global/global.dart';
import '../widgets/progress_dialog.dart';
import '../widgets/seperator.dart';
import '../widgets/upload_image_dialog.dart';

class DoctorLiveConsultationDetails extends StatefulWidget {
  const DoctorLiveConsultationDetails({Key? key}) : super(key: key);

  @override
  State<DoctorLiveConsultationDetails> createState() => _DoctorLiveConsultationDetailsState();
}

class _DoctorLiveConsultationDetailsState extends State<DoctorLiveConsultationDetails> {
  XFile? imageFile;
  String imageUrl = "";
  bool flag = false;
  late Future<ListResult> futureFiles;


  Future<void> checkPrescriptionStatus() async {
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('consultationImages/'+ consultationId! + "/doctorPrescription.png" );
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

  Future pickImage() async {
    try{
      // Pick an Image
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(pickedImage != null){
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return ProgressDialog(message: "");
            }
        );
        setState((){
          imageFile = pickedImage;
        });
        Navigator.pop(context);

      }
    }

    catch(e){
      imageFile = null;
      setState(() {});
    }
  }

  saveImage() async {
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('consultationImages/'+ consultationId! + "/doctorPrescription.png" );
    // Upload the image to firebase storage
    try{
      await reference.putFile(File(imageFile!.path));
      //imageUrl = await reference.getDownloadURL();
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

    Navigator.pop(context);
    var snackBar = SnackBar(content: Text("Downloaded ${reference.name}"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }

  getRegistrationTokenForUserAndSendPrescriptionNotification(){
    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(selectedConsultationInfoForDocAndConsultant!.userId!)
        .child("tokens").once().then((snapData) async {
      DataSnapshot snapshot = snapData.snapshot;
      if(snapshot.value != null){
        String deviceRegistrationToken = snapshot.value.toString();
        // send notification now
        await AssistantMethods.sendPrescriptionPushNotificationToPatientNow(deviceRegistrationToken, selectedConsultationInfoForDocAndConsultant!.patientId!, "Doctor Live Consultation", context);
        Fluttertoast.showToast(msg: "Notification sent to patient successfully");
      }

      else{
        Fluttertoast.showToast(msg: "Error sending notifications");
      }
    });
  }

  /*void retrievePatientDataFromDatabase() {
    FirebaseDatabase.instance.ref()
        .child("Doctors")
        .child(currentFirebaseUser!.uid)
        .child("consultations")
        .child(consultationId!)
        .once()
        .then((dataSnap){
      final DataSnapshot snapshot = dataSnap.snapshot;
      if (snapshot.exists) {
        patientNameTextEditingController.text = (snapshot.value as Map)['patientName'];
        patientIdTextEditingController.text = (snapshot.value as Map)['patientId'];
        patientAgeTextEditingController.text = (snapshot.value as Map)['patientAge'];
        genderTextEditingController.text = (snapshot.value as Map)['gender'];
        heightTextEditingController.text = (snapshot.value as Map)['height'];
        weightTextEditingController.text = (snapshot.value as Map)['weight'];
        visitationReasonTextEditingController.text = (snapshot.value as Map)['visitationReason'];
      }

      else {
      }
    });
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureFiles = firebase_storage.FirebaseStorage.instance.ref('consultationImages/'+ consultationId! + "/medical_documents").listAll();
    //retrievePatientDataFromDatabase();
    checkPrescriptionStatus();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: height * 0.3,
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
              selectedConsultationInfoForDocAndConsultant!.patientName!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),

            SizedBox(height: height * 0.01,),

            Text(
              selectedConsultationInfoForDocAndConsultant!.patientAge! + ' yrs',
              style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600
              ),
            ),

            SizedBox(height: height * 0.005,),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Patient',
                    style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600
                    ),
                  ),

                  const SizedBox(height: 5,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          selectedConsultationInfoForDocAndConsultant!.patientName! + " (" + selectedConsultationInfoForDocAndConsultant!.gender! + ", " + selectedConsultationInfoForDocAndConsultant!.patientAge! + " yrs, " + selectedConsultationInfoForDocAndConsultant!.weight! + " kg",
                          style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15,),

                  const MySeparator(color: Colors.grey,),

                  const SizedBox(height: 15,),

                  Text(
                    'Sickness',
                    style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600
                    ),
                  ),

                  const SizedBox(height: 5,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          selectedConsultationInfoForDocAndConsultant!.visitationReason!,
                          style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15,),

                  const MySeparator(color: Colors.grey,),

                  const SizedBox(height: 15,),

                  Text(
                    'Problem (in details)',
                    style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600
                    ),
                  ),

                  const SizedBox(height: 5,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          selectedConsultationInfoForDocAndConsultant!.problem!,
                          style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.05,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Consultation Information",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.02,),

                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Consultation ID",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0x59090808),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.010,),
                                    Text(
                                      "#${selectedConsultationInfoForDocAndConsultant!.id!}",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),

                                Column(
                                  children: [
                                    Text(
                                      "Consultation Fee",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0x59090808),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.010,),
                                    Text(
                                      "৳${selectedConsultationInfoForDocAndConsultant!.consultantFee!}",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 15,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Date",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        color: const Color(0x59090808),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height * 0.010,),
                                    Text(
                                      selectedConsultationInfoForDocAndConsultant!.date!,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),

                                Column(
                                  children: [
                                    Text(
                                      "Time",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        color: const Color(0x59090808),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height * 0.010,),
                                    Text(
                                      selectedConsultationInfoForDocAndConsultant!.time!,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 15,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Consultation Status",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Color(0x59090808),
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(height: height * 0.010,),
                                    Text(
                                      selectedConsultationInfoForDocAndConsultant!.consultationType!,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),

                                Column(
                                  children: [
                                    Text(
                                      "Payment Status",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Color(0x59090808),
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(height: height * 0.010,),
                                    Text(
                                      selectedConsultationInfoForDocAndConsultant!.payment!,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),

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
                            physics: const ScrollPhysics(),
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



                      (flag == false) ?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Uploaded Image Container
                          GestureDetector(
                            onTap: () async {
                              await pickImage();
                              var snackBar = const SnackBar(content: Text("Selected successfully"));
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
                                          "Upload prescription",
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
                            child: Center(
                              child: Container(
                                width: Get.width * 0.35,
                                height: height * 0.25,
                                child: imageFile == null
                                    ? const Center(
                                  child: Text("No Images found"),
                                ) :
                                Container(
                                    width: height * 0.1,
                                    margin: const EdgeInsets.only(right: 10),
                                    height: 100,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(2)),
                                    child: Image.file(
                                      File(imageFile!.path),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.05,),

                          SizedBox(
                              height: 45,
                              width: double.infinity,
                              child:  ElevatedButton.icon(
                                onPressed: ()  async {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context){
                                        return ProgressDialog(message: "Please wait...");
                                      }
                                  );

                                  await saveImage();
                                  getRegistrationTokenForUserAndSendPrescriptionNotification();
                                  Timer(const Duration(seconds: 5),()  {
                                    Navigator.pop(context);
                                    var snackBar = const SnackBar(content: Text("Prescription uploaded successfully"));
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    Navigator.pop(context);
                                  });

                                },

                                style: ElevatedButton.styleFrom(
                                    primary: (Colors.blue),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20))),

                                icon: const Icon(Icons.contact_page),
                                label: Text(
                                  "Upload Prescription",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                              )
                          ),
                        ],
                      ) : Container()
                    ],
                  ),
                ],
              ),
            ),





          ],
        ),
      ),
    );
  }
}
