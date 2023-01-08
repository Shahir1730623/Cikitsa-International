import 'dart:async';
import 'dart:io';

import 'package:age_calculator/age_calculator.dart';
import 'package:app/widgets/seperator.dart';
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
  DateDuration? duration;

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

  TextEditingController attendantDocumentTypeTextEditingController = TextEditingController(text: '');
  TextEditingController attendantCountryCodeTextEditingController = TextEditingController(text: '');
  TextEditingController attendantPassportNumberTextEditingController = TextEditingController(text: '');
  TextEditingController attendantSurnameTextEditingController = TextEditingController(text: '');
  TextEditingController attendantGivenNameTextEditingController = TextEditingController(text: '');
  TextEditingController attendantNationalityTextEditingController = TextEditingController(text: '');
  TextEditingController attendantPersonalNumberTextEditingController = TextEditingController(text: '');
  TextEditingController attendantDateOfBirthTextEditingController = TextEditingController(text: '');
  TextEditingController attendantGenderTextEditingController = TextEditingController(text: '');
  TextEditingController attendantExpiryTextEditingController = TextEditingController(text: '');


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
    futureFiles = firebase_storage.FirebaseStorage.instance.ref('invitationImages/'+ invitationId! + "/documents").listAll();
    patientIdTextEditingController.text = selectedVisaInvitationInfo!.patientId!;
    documentTypeTextEditingController.text = selectedVisaInvitationInfo!.documentType!;
    countryCodeTextEditingController.text = selectedVisaInvitationInfo!.countryCode!;
    passportNumberTextEditingController.text = selectedVisaInvitationInfo!.passportNumber!;
    givenNameTextEditingController.text = selectedVisaInvitationInfo!.patientGivenName!;
    surnameTextEditingController.text = selectedVisaInvitationInfo!.patientSurname!;
    nationalityTextEditingController.text = selectedVisaInvitationInfo!.nationality!;
    personalNumberTextEditingController.text = selectedVisaInvitationInfo!.passportPersonalNumber!;
    dateOfBirthTextEditingController.text = selectedVisaInvitationInfo!.dateOfBirth!;
    genderTextEditingController.text = selectedVisaInvitationInfo!.gender!;
    expiryTextEditingController.text = selectedVisaInvitationInfo!.expiryDate!;


    attendantDocumentTypeTextEditingController.text = selectedVisaInvitationInfo!.attendantDocumentType!;
    attendantCountryCodeTextEditingController.text = selectedVisaInvitationInfo!.attendantCountryCode!;
    attendantPassportNumberTextEditingController.text = selectedVisaInvitationInfo!.attendantPassportNumber!;
    attendantGivenNameTextEditingController.text = selectedVisaInvitationInfo!.attendantGivenName!;
    attendantSurnameTextEditingController.text = selectedVisaInvitationInfo!.attendantSurname!;
    attendantNationalityTextEditingController.text = selectedVisaInvitationInfo!.attendantNationality!;
    attendantPersonalNumberTextEditingController.text = selectedVisaInvitationInfo!.attendantPassportPersonalNumber!;
    attendantDateOfBirthTextEditingController.text = selectedVisaInvitationInfo!.attendantDateOfBirth!;
    attendantGenderTextEditingController.text = selectedVisaInvitationInfo!.attendantGender!;
    attendantExpiryTextEditingController.text = selectedVisaInvitationInfo!.attendantExpiryDate!;


    DateTime tempDate = DateFormat("dd-MM-yyyy").parse(selectedVisaInvitationInfo!.dateOfBirth!);
    // Find out your age as of today's date 2021-03-08
    duration = AgeCalculator.age(tempDate);
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
              selectedVisaInvitationInfo!.patientGivenName! + " " + selectedVisaInvitationInfo!.patientSurname!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),

            SizedBox(height: height * 0.01),

            Text(
              (duration!.years + 1).toString() + ' yrs',
              style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600
              ),
            ),


            SizedBox(height: height * 0.025,),

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

                  // Attendant Document type
                  Text(
                    "Attendant document type",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: attendantDocumentTypeTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Attendant document type",
                      hintText: "Attendant document type",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.add,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: attendantDocumentTypeTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            attendantDocumentTypeTextEditingController.clear(),
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

                  // Attendant Country type
                  Text(
                    "Attendant country code",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: attendantCountryCodeTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Attendant country code",
                      hintText: "Attendant country code",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.code,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: attendantCountryCodeTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            attendantCountryCodeTextEditingController.clear(),
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

                  // Attendant Passport Number
                  Text(
                    "Attendant Passport Number",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: attendantPassportNumberTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Attendant Passport Number",
                      hintText: "Attendant Passport Number",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.numbers,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: attendantPassportNumberTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            attendantPassportNumberTextEditingController.clear(),
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

                  // Attendant Given Name
                  Text(
                    "Attendant Given Name",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: attendantGivenNameTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Attendant Given Name",
                      hintText: "Attendant Given Name",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.person,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: attendantGivenNameTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            attendantGivenNameTextEditingController.clear(),
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

                  // Attendant Surname
                  Text(
                    "Attendant Surname",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: attendantSurnameTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Attendant surname",
                      hintText: "Attendant surname",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.person_add_alt_rounded,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: attendantSurnameTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            attendantSurnameTextEditingController.clear(),
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

                  // Attendant Nationality
                  Text(
                    "Attendant Nationality",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: attendantNationalityTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Attendant nationality",
                      hintText: "Attendant nationality",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.flag,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: attendantNationalityTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            attendantNationalityTextEditingController.clear(),
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

                  // Attendant Personal Number
                  Text(
                    "Attendant Personal Number",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: attendantPersonalNumberTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Attendant Personal Number",
                      hintText: "Attendant Personal Number",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.numbers,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: attendantPersonalNumberTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            attendantPersonalNumberTextEditingController.clear(),
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

                  // Attendant date of birth
                  Text(
                    "Attendant Date of Birth",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: attendantDateOfBirthTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Attendant date of birth",
                      hintText: "Attendant date of birth",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.date_range,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: attendantDateOfBirthTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            attendantDateOfBirthTextEditingController.clear(),
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

                  // Attendant gender
                  Text(
                    "Attendant Gender",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: attendantGenderTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Attendant gender",
                      hintText: "Attendant gender",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today_outlined,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: attendantGenderTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.person_add_alt_rounded),
                        onPressed: () =>
                            attendantGenderTextEditingController.clear(),
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

                  // Attendant expiry date
                  Text(
                    "Attendant Expiry Date",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: attendantExpiryTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Attendant expiry date",
                      hintText: "Attendant expiry date",
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today_outlined,color: Colors.black,),
                        onPressed: () {},
                      ),
                      suffixIcon: attendantExpiryTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: const Icon(Icons.calendar_today_outlined),
                        onPressed: () =>
                            attendantExpiryTextEditingController.clear(),
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
                        padding: const EdgeInsets.all(10),
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

                ],
              ),
            ),

            const SizedBox(height: 10,),

            const MySeparator(color: Colors.blue,),

            const SizedBox(height: 10,),

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

            const MySeparator(color: Colors.blue,),

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