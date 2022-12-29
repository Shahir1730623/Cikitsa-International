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

  TextEditingController patientIdTextEditingController = TextEditingController(text: "");
  TextEditingController patientNameTextEditingController = TextEditingController(text: "");
  TextEditingController patientAgeTextEditingController = TextEditingController(text: "");
  TextEditingController patientCountryTextEditingController = TextEditingController(text: "");
  TextEditingController genderTextEditingController = TextEditingController(text: "");
  TextEditingController heightTextEditingController = TextEditingController(text: "");
  TextEditingController weightTextEditingController = TextEditingController(text: "");
  TextEditingController visitationReasonTextEditingController = TextEditingController(text: "");


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

  void retrievePatientDataFromDatabase() {
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureFiles = firebase_storage.FirebaseStorage.instance.ref('consultationImages/'+ consultationId! + "/medical_documents").listAll();
    retrievePatientDataFromDatabase();
    checkPrescriptionStatus();
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
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                                    "Telemedicine Details",
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

                          // Patient Height
                          Text(
                            "Height",
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
                            controller: heightTextEditingController,
                            readOnly: true,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: "Height",
                              hintText: "Height",
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

                          // Patient Country
                          Text(
                            "Weight",
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
                            controller: weightTextEditingController,
                            readOnly: true,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: "Weight",
                              hintText: "Weight",
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

                          // Sickness
                          Text(
                            "Sickness",
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
                            controller: visitationReasonTextEditingController,
                            readOnly: true,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: "Sickness",
                              hintText: "Sickness",
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
                                        selectedConsultationInfoForDocAndConsultant!.id!,
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
                                        selectedConsultationInfoForDocAndConsultant!.visitationReason!,
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.02,
                                      ),

                                      // Date
                                      Text(
                                        "Date",
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
                                        selectedConsultationInfoForDocAndConsultant!.date!,
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
                                        "Time",
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
                                        selectedConsultationInfoForDocAndConsultant!.time!,
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
                                        selectedConsultationInfoForDocAndConsultant!.problem!,
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

                          SizedBox(height: height * 0.02,),

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
