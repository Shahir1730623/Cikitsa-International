import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../assistants/assistant_methods.dart';
import '../global/global.dart';
import '../widgets/progress_dialog.dart';

class PhysicalAppointmentDetails extends StatefulWidget {
  const PhysicalAppointmentDetails({Key? key}) : super(key: key);

  @override
  State<PhysicalAppointmentDetails> createState() => _PhysicalAppointmentDetailsState();
}

class _PhysicalAppointmentDetailsState extends State<PhysicalAppointmentDetails> {
  TextEditingController patientIdTextEditingController = TextEditingController(text: "");
  TextEditingController documentTypeTextEditingController = TextEditingController();
  TextEditingController countryCodeTextEditingController = TextEditingController();
  TextEditingController passportNumberTextEditingController = TextEditingController();
  TextEditingController surnameTextEditingController = TextEditingController();
  TextEditingController givenNameTextEditingController = TextEditingController();
  TextEditingController nationalityTextEditingController = TextEditingController();
  TextEditingController personalNumberTextEditingController = TextEditingController();
  TextEditingController dateOfBirthTextEditingController = TextEditingController();
  TextEditingController genderTextEditingController = TextEditingController();
  TextEditingController expiryTextEditingController = TextEditingController();

  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  String? formattedDate,formattedTime;
  int dateCounter = 0;
  int timeCounter = 0;
  bool flag = false;

  pickDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), //get today's date
        firstDate:DateTime.now(), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2030)
    );

    if(pickedDate != null ){
      setState(() {
        date = pickedDate;
        formattedDate = DateFormat('dd-MM-yyyy').format(date);
        dateCounter++;
        flag = true;
      });
    }

    else{
      print("Date is not selected");
    }

  }

  pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), //get today's date
    );

    if(pickedTime != null ){
      setState(() {
        time = pickedTime;
        formattedTime = time.format(context);
        timeCounter++;
      });
    }
  }

  setAppointmentInfoToUpcoming() async {
    Map appointmentInfoMap = {
      "id" : appointmentId,
      "userId" : currentFirebaseUser!.uid,
      "date" : formattedDate,
      "time" : formattedTime,
      "doctorId" : selectedDoctorAppointmentInfo!.doctorId,
      "doctorName" : "Dr. " + selectedDoctorAppointmentInfo!.doctorName!,
      "doctorImageUrl" : selectedDoctorAppointmentInfo!.doctorImageUrl,
      "specialization" : selectedDoctorAppointmentInfo!.specialization,
      "workplace" : selectedDoctorAppointmentInfo!.workplace,
      "patientId" : selectedDoctorAppointmentInfo!.patientId,
      "documentType" : selectedDoctorAppointmentInfo!.documentType,
      "countryCode" : selectedDoctorAppointmentInfo!.countryCode,
      "passportNumber" : selectedDoctorAppointmentInfo!.passportNumber,
      "patientSurname" : selectedDoctorAppointmentInfo!.patientSurname,
      "patientGivenName" : selectedDoctorAppointmentInfo!.patientGivenName,
      "nationality" : selectedDoctorAppointmentInfo!.nationality!,
      "passportPersonalNumber" : selectedDoctorAppointmentInfo!.passportPersonalNumber!,
      "dateOfBirth" : selectedDoctorAppointmentInfo!.dateOfBirth,
      "gender" : selectedDoctorAppointmentInfo!.gender,
      "expiryDate" : selectedDoctorAppointmentInfo!.expiryDate,
      "patientWeight" : selectedDoctorAppointmentInfo!.patientWeight,
      "patientHeight" : selectedDoctorAppointmentInfo!.patientHeight,
      "visitationReason": selectedDoctorAppointmentInfo!.visitationReason,
      "problem":selectedDoctorAppointmentInfo!.problem,
      "payment" : "Paid",
      "status" : "Upcoming"
    };

    FirebaseDatabase.instance.ref().child("Users")
        .child(currentFirebaseUser!.uid)
        .child('patientList')
        .child(selectedDoctorAppointmentInfo!.patientId!)
        .child("doctorAppointment")
        .child(appointmentId!)
        .set(appointmentInfoMap);

    FirebaseDatabase.instance.ref()
        .child("Doctors")
        .child(selectedDoctorAppointmentInfo!.doctorId!)
        .child("appointments")
        .child(appointmentId!)
        .set(appointmentInfoMap);

    FirebaseDatabase.instance.ref()
        .child("doctorAppointmentRequests")
        .child(appointmentId!)
        .remove();

    getRegistrationTokenForUserAndNotify();
  }

  void getRegistrationTokenForUserAndNotify(){
    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(selectedDoctorAppointmentInfo!.userId!)
        .child("tokens").once().then((snapData) async {
      DataSnapshot snapshot = snapData.snapshot;
      if(snapshot.value != null){
        String deviceRegistrationToken = snapshot.value.toString();
        // send notification now
        await AssistantMethods.sendAppointmentPushNotificationToPatientNow(deviceRegistrationToken, appointmentId!, selectedDoctorAppointmentInfo!.patientId!, context);
        Fluttertoast.showToast(msg: "Notification sent to patient successfully");
      }

      else{
        Fluttertoast.showToast(msg: "Error sending notifications");
      }
    });

    getRegistrationTokenForDoctorAndNotify();
  }

  void getRegistrationTokenForDoctorAndNotify(){
    FirebaseDatabase.instance.ref()
        .child("Doctors")
        .child(selectedDoctorAppointmentInfo!.doctorId!)
        .child("tokens").once().then((snapData){
      DataSnapshot snapshot = snapData.snapshot;
      if(snapshot.value != null){
        String deviceRegistrationToken = snapshot.value.toString();
        // send notification now
        AssistantMethods.sendAppointmentPushNotificationToDoctorNow(deviceRegistrationToken, appointmentId!, selectedDoctorAppointmentInfo!.patientId!,context);
        Fluttertoast.showToast(msg: "Notification sent to Doctor successfully");
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
  }



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type
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
                    height: height * 0.01,
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
                    height: height * 0.01,
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
                    height: height * 0.01,
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
                    height: height * 0.01,
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
                    height: height * 0.01,
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
                    height: height * 0.01,
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
                    height: height * 0.01,
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
                    height: height * 0.01,
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

                  SizedBox(height: height * 0.04,),

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
                                "Appointment ID",
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
                                selectedDoctorAppointmentInfo!.id!,
                                style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),

                              // Consultant Name
                              Text(
                                "Doctor Name",
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
                                selectedDoctorAppointmentInfo!.doctorName!,
                                style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),

                              // Consultant Fee
                              Text(
                                "Service Fee",
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
                                "৳700",
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
                                selectedDoctorAppointmentInfo!.visitationReason!,
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
                                selectedDoctorAppointmentInfo!.problem!,
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

                  (selectedDoctorAppointmentInfo!.status == "Waiting") ?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.03,),
                      Text(
                        "Date",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      ),
                      SizedBox(height: height * 0.01,),
                      // Date Picker
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey.shade200,
                            child: IconButton(
                              onPressed: () {  },
                              icon: const Icon(Icons.calendar_month,color: Colors.black,size: 35,),
                            ),
                          ),

                          const SizedBox(width: 10,),
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  pickDate();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: (Colors.white70),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text(
                                  (dateCounter != 0) ? '$formattedDate' :  "Select date",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: height * 0.03,),
                      // Test Time
                      Text(
                        "Time",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      ),
                      SizedBox(height: height * 0.01,),
                      // Time Picker
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey.shade200,
                            child: IconButton(
                              onPressed: () {  },
                              icon: const Icon(Icons.watch_later_outlined,color: Colors.black,size: 35,),
                            ),
                          ),

                          const SizedBox(width: 10,),
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  pickTime();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: (Colors.white70),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text(
                                  (timeCounter != 0) ? '$formattedTime' :  "Select time",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: height * 0.05,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                onPressed: ()  async {
                                  if(dateCounter!=0 && timeCounter!=0){
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context){
                                          return ProgressDialog(message: "Please wait...");
                                        }
                                    );

                                    setAppointmentInfoToUpcoming();

                                    Timer(const Duration(seconds: 5),()  {
                                      Navigator.pop(context);
                                      var snackBar = const SnackBar(content: Text("Appointment request sent successfully"));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      Navigator.pop(context);
                                    });
                                  }

                                  else{
                                    if(dateCounter == 0){
                                      var snackBar = const SnackBar(content: Text("Select date"));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }

                                    else{
                                      var snackBar = const SnackBar(content: Text("Select time"));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }

                                  }

                                },

                                style: ElevatedButton.styleFrom(
                                    primary: (Colors.blue),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20))),

                                child: Text(
                                  "Confirm",
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
                    ],
                  ) : Container(),

                  SizedBox(
                    height: height * 0.03,
                  ),



                ],
              )

          ),
        ),
      ),
    );
  }
}
