import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import '../../global/global.dart';
import '../../main_screen.dart';
import '../../navigation_service.dart';
import '../../widgets/progress_dialog.dart';

class DoctorAppointmentHistoryDetails extends StatefulWidget {
  const DoctorAppointmentHistoryDetails({Key? key}) : super(key: key);

  @override
  State<DoctorAppointmentHistoryDetails> createState() => _DoctorAppointmentHistoryDetailsState();
}

class _DoctorAppointmentHistoryDetailsState extends State<DoctorAppointmentHistoryDetails> {
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

  String imageUrl = "";
  bool flag = false;

  Future<void> checkPrescriptionStatus() async {
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('doctorAppointmentImages/'+ selectedDoctorAppointmentInfo!.id! + "/documents/doctorPrescription.png" );
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

  Future downloadFile() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "");
        }
    );

    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('doctorAppointmentImages/'+ selectedDoctorAppointmentInfo!.id! + "/documents/doctorPrescription.png" );
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
    Fluttertoast.showToast(msg: "Photo Saved to gallery",toastLength: Toast.LENGTH_LONG);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPrescriptionStatus();
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
                selectedDoctorAppointmentInfo!.doctorImageUrl!,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: height * 0.02),

            Text(
              selectedDoctorAppointmentInfo!.doctorName!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),

            SizedBox(height: height * 0.01),

            Text(
              selectedDoctorAppointmentInfo!.specialization!,
              style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600
              ),
            ),

            SizedBox(height: height * 0.01),

            Text(
              selectedDoctorAppointmentInfo!.workplace!,
              style: GoogleFonts.montserrat(
                  fontSize: 15,
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

                SizedBox(height: height * 0.1),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton.icon(
                    onPressed: ()  async {
                      if(flag == true){
                        await downloadFile();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainScreen()), (Route<dynamic> route) => false);
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
                      "Download Prescription",
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
