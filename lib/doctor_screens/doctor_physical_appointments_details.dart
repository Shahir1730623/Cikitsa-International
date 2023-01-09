import 'dart:async';
import 'dart:io';

import 'package:age_calculator/age_calculator.dart';
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
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../assistants/assistant_methods.dart';
import '../global/global.dart';
import '../navigation_service.dart';
import '../widgets/progress_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../widgets/seperator.dart';

class DoctorPhysicalAppointmentDetails extends StatefulWidget {
  const DoctorPhysicalAppointmentDetails({Key? key}) : super(key: key);

  @override
  State<DoctorPhysicalAppointmentDetails> createState() => _DoctorPhysicalAppointmentDetailsState();
}

class _DoctorPhysicalAppointmentDetailsState extends State<DoctorPhysicalAppointmentDetails> {
  DateDuration? duration;
  late Future<ListResult> futureFiles;
  List<File> imageList = [];

  TextEditingController patientIdTextEditingController = TextEditingController(text: '');
  TextEditingController documentTypeTextEditingController = TextEditingController(text: '');
  TextEditingController countryCodeTextEditingController = TextEditingController(text: '');
  TextEditingController passportNumberTextEditingController = TextEditingController(text: '');
  TextEditingController surnameTextEditingController = TextEditingController(text: '');
  TextEditingController givenNameTextEditingController = TextEditingController(text: '');
  TextEditingController nationalityTextEditingController = TextEditingController(text: '');
  TextEditingController personalNumberTextEditingController = TextEditingController(text: '');
  TextEditingController dateOfBirthTextEditingController = TextEditingController(text: '');
  TextEditingController genderTextEditingController = TextEditingController(text: '');
  TextEditingController expiryTextEditingController = TextEditingController(text: '');

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
      for (var image in pickedImages) {
        imageList.add(File(image.path));
      }
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
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('doctorAppointmentImages/'+ selectedDoctorAppointmentInfo!.id! + "/documents/doctorPrescription.png" );

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

  }

  void setStatusToCompleted(){
    print("User ID: " + selectedDoctorAppointmentInfo!.userId! + " Patient Id: " + selectedDoctorAppointmentInfo!.patientId! +  " Consultation id:" + selectedDoctorAppointmentInfo!.id!);
    FirebaseDatabase.instance.ref()
        .child("Doctors")
        .child(currentFirebaseUser!.uid)
        .child('appointments')
        .child(selectedDoctorAppointmentInfo!.id!)
        .child('status').set("Completed");

    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(selectedDoctorAppointmentInfo!.userId!)
        .child('patientList')
        .child(selectedDoctorAppointmentInfo!.patientId!)
        .child('doctorAppointment')
        .child(selectedDoctorAppointmentInfo!.id!)
        .child('status').set("Completed");

    getRegistrationTokenForUserAndSendPrescriptionNotification();
  }

  getRegistrationTokenForUserAndSendPrescriptionNotification(){
    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(selectedDoctorAppointmentInfo!.userId!)
        .child("tokens").once().then((snapData) async {
      DataSnapshot snapshot = snapData.snapshot;
      if(snapshot.value != null){
        String deviceRegistrationToken = snapshot.value.toString();
        // send notification now
        await AssistantMethods.sendAppointmentPrescriptionPushNotificationToPatientNow(deviceRegistrationToken, selectedDoctorAppointmentInfo!.id!, selectedDoctorAppointmentInfo!.patientId!, context);
        Fluttertoast.showToast(msg: "Notification sent to patient successfully",toastLength: Toast.LENGTH_LONG);
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
    futureFiles = firebase_storage.FirebaseStorage.instance.ref('doctorAppointmentImages/'+ selectedDoctorAppointmentInfo!.id! + "/documents").listAll();
    patientIdTextEditingController.text = selectedDoctorAppointmentInfo!.patientId!;
    documentTypeTextEditingController.text = selectedDoctorAppointmentInfo!.documentType!;
    countryCodeTextEditingController.text = selectedDoctorAppointmentInfo!.countryCode!;
    passportNumberTextEditingController.text = selectedDoctorAppointmentInfo!.passportNumber!;
    givenNameTextEditingController.text = selectedDoctorAppointmentInfo!.patientGivenName!;
    surnameTextEditingController.text = selectedDoctorAppointmentInfo!.patientSurname!;
    nationalityTextEditingController.text = selectedDoctorAppointmentInfo!.nationality!;
    personalNumberTextEditingController.text = selectedDoctorAppointmentInfo!.passportPersonalNumber!;
    dateOfBirthTextEditingController.text = selectedDoctorAppointmentInfo!.dateOfBirth!;
    genderTextEditingController.text = selectedDoctorAppointmentInfo!.gender!;
    expiryTextEditingController.text = selectedDoctorAppointmentInfo!.expiryDate!;

    DateTime tempDate = DateFormat("dd-MM-yyyy").parse(selectedDoctorAppointmentInfo!.dateOfBirth!);
    // Find out your age as of today's date 2021-03-08
    duration = AgeCalculator.age(tempDate);

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
              "${selectedDoctorAppointmentInfo!.patientGivenName!} ${selectedDoctorAppointmentInfo!.patientSurname!}",
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),

            SizedBox(height: height * 0.01),

            Text(
              '${duration!.years + 1} yrs',
              style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Type",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: documentTypeTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Type",
                      hintText: "Type",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.add,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: documentTypeTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () =>
                            documentTypeTextEditingController.clear(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle:
                      const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    validator: (value) {
                      if (value == null ||value.isEmpty) {
                        return "The field is empty";
                      }
                      else {
                        return null;
                      }
                    },

                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),

                  // Country Code
                  Text(
                    "Country Code",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: countryCodeTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Country Code",
                      hintText: "Country Code",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.calendar_month,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: countryCodeTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () =>
                            countryCodeTextEditingController.clear(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle:
                      const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    validator: (value) {
                      if (value == null ||value.isEmpty) {
                        return "The field is empty";
                      }
                      else {
                        return null;
                      }
                    },

                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),

                  // Passport No
                  Text(
                    "Passport No",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),

                  TextFormField(
                    controller: passportNumberTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Passport No",
                      hintText: "Passport No",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.numbers,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: passportNumberTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            passportNumberTextEditingController.clear(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle:
                      const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    validator: (value) {
                      if (value == null ||value.isEmpty) {
                        return "The field is empty";
                      }
                      else {
                        return null;
                      }
                    },

                  ),

                  SizedBox(
                    height: height * 0.01,
                  ),

                  // Given Name
                  Text(
                    "Given Name",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),

                  TextFormField(
                    controller: givenNameTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Given Name",
                      hintText: "Given Name",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.person,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: givenNameTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            givenNameTextEditingController.clear(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle:
                      const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    validator: (value) {
                      if (value == null ||value.isEmpty) {
                        return "The field is empty";
                      }
                      else {
                        return null;
                      }
                    },

                  ),

                  SizedBox(
                    height: height * 0.01,
                  ),

                  // Given Name
                  Text(
                    "Surname",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),

                  TextFormField(
                    controller: surnameTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Surname",
                      hintText: "Surname",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.person,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: surnameTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            surnameTextEditingController.clear(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle:
                      const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    validator: (value) {
                      if (value == null ||value.isEmpty) {
                        return "The field is empty";
                      }
                      else {
                        return null;
                      }
                    },

                  ),

                  SizedBox(
                    height: height * 0.02,
                  ),

                  // Nationality
                  Text(
                    "Nationality",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),

                  TextFormField(
                    controller: nationalityTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Nationality",
                      hintText: "Nationality",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.flag,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: nationalityTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            nationalityTextEditingController.clear(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle:
                      const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    validator: (value) {
                      if (value == null ||value.isEmpty) {
                        return "The field is empty";
                      }
                      else {
                        return null;
                      }
                    },

                  ),

                  SizedBox(
                    height: height * 0.02,
                  ),

                  // Personal No
                  Text(
                    "Personal No",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),

                  TextFormField(
                    controller: personalNumberTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Personal No",
                      hintText: "Personal No",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.numbers,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: personalNumberTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            personalNumberTextEditingController.clear(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle:
                      const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    validator: (value) {
                      if (value == null ||value.isEmpty) {
                        return "The field is empty";
                      }
                      else {
                        return null;
                      }
                    },

                  ),

                  SizedBox(
                    height: height * 0.02,
                  ),

                  // Date of Birth
                  Text(
                    "Date of Birth",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),

                  TextFormField(
                    controller: dateOfBirthTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Date of Birth",
                      hintText: "Date of Birth",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.date_range,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: dateOfBirthTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            dateOfBirthTextEditingController.clear(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle:
                      const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    validator: (value) {
                      if (value == null ||value.isEmpty) {
                        return "The field is empty";
                      }
                      else {
                        return null;
                      }
                    },

                  ),

                  SizedBox(
                    height: height * 0.02,
                  ),

                  // Gender
                  Text(
                    "Gender",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
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
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Gender",
                      hintText: "Gender",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.person_add_alt_1,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: genderTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            genderTextEditingController.clear(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle:
                      const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    validator: (value) {
                      if (value == null ||value.isEmpty) {
                        return "The field is empty";
                      }
                      else {
                        return null;
                      }
                    },

                  ),

                  SizedBox(
                    height: height * 0.02,
                  ),

                  // Date of Expiry
                  Text(
                    "Date of Expiry",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),

                  TextFormField(
                    controller: expiryTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Date of Expiry",
                      hintText: "Date of Expiry",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today_outlined,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: expiryTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            expiryTextEditingController.clear(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade500),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle:
                      const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    validator: (value) {
                      if (value == null ||value.isEmpty) {
                        return "The field is empty";
                      }
                      else {
                        return null;
                      }
                    },

                  ),

                  SizedBox(height: height * 0.03,),

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
                        padding: EdgeInsets.all(10),
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
                                      "Appointment ID",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    SizedBox(height: height * 0.010,),
                                    Text(
                                      selectedDoctorAppointmentInfo!.id!,
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
                                      "Service Fee",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    SizedBox(height: height * 0.010,),
                                    Text(
                                      "৳700",
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
                                      "Sickness",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(height: height * 0.010,),
                                    Text(
                                      selectedDoctorAppointmentInfo!.visitationReason!,
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
                                      "Status",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(height: height * 0.010,),
                                    Text(
                                      selectedDoctorAppointmentInfo!.status!,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )

                          ],
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: height * 0.025,),

                  Text(
                    "Download Reports and Prescriptions",
                    style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),

                  SizedBox(height: height * 0.020,),

                  const MySeparator(color: Colors.blue,),

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

                  const MySeparator(color: Colors.blue,),

                  // Uploaded Image Container
                  GestureDetector(
                    onTap: () async {
                      await pickImages();
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
                    child: SizedBox(
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

                  SizedBox(
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
                        setStatusToCompleted();

                        Timer(const Duration(seconds: 5),()  {
                          Navigator.pop(context);
                          var snackBar = const SnackBar(content: Text("Prescription sent successfully"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pop(context);
                        });

                      },

                      style: ElevatedButton.styleFrom(
                          primary: (Colors.blue),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),

                      child: Text(
                        "Upload Prescription",
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
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
