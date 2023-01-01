import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app/global/global.dart';
import 'package:app/our_services/visa_invitation/medical_documents_form.dart';
import 'package:app/our_services/visa_invitation/visa_form_screen_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/progress_dialog.dart';
import '../ci_consultation/mrz_testing.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class VisaFormScreen extends StatefulWidget {
  const VisaFormScreen({Key? key}) : super(key: key);

  @override
  State<VisaFormScreen> createState() => _VisaFormScreenState();
}

class _VisaFormScreenState extends State<VisaFormScreen> {
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

  XFile? imageFile;
  List<File> imageList = [];

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  Future pickImages() async {
    try{
      final pickedImages = await ImagePicker().pickMultiImage();
      if(pickedImages != null){
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
    }

    catch(e){
      imageFile = null;
      setState(() {});
    }
  }

  Future<void> uploadFile(File file) async {
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('invitationImages/'+ invitationId! + "/documents/"+ idGenerator() + ".png" );

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    invitationId = idGenerator();
    documentTypeTextEditingController.addListener(() => setState(() {}));
    countryCodeTextEditingController.addListener(() => setState(() {}));
    passportNumberTextEditingController.addListener(() => setState(() {}));
    surnameTextEditingController.addListener(() => setState(() {}));
    givenNameTextEditingController.addListener(() => setState(() {}));
    nationalityTextEditingController.addListener(() => setState(() {}));
    personalNumberTextEditingController.addListener(() => setState(() {}));
    dateOfBirthTextEditingController.addListener(() => setState(() {}));
    genderTextEditingController.addListener(() => setState(() {}));
    expiryTextEditingController.addListener(() => setState(() {}));
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
                  Image.asset(
                    "assets/visaInvitationImages/Visa_Image-1.jpg",
                  ),

                  const SizedBox(height: 15,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Visa Form",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/visaInvitationImages/passport.png",
                        width: 80,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Attach your Passport",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Please scan second page of\nPassport",
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            color: Colors.grey
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  // Image Picker
                  GestureDetector(
                    onTap: () async {
                      final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
                      var snackBar = const SnackBar(content: Text("Scanned Successfully"));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      setState(() {
                        documentTypeTextEditingController.text = (data)['type'];
                        countryCodeTextEditingController.text = (data)['country_Code'];
                        passportNumberTextEditingController.text = (data)['document_Number'];
                        surnameTextEditingController.text = (data)['surname'];
                        givenNameTextEditingController.text = (data)['given_Name'];
                        nationalityTextEditingController.text = (data)['nationality'];
                        personalNumberTextEditingController.text = (data)['personal_Number'];
                        dateOfBirthTextEditingController.text =  (data)['birth_Date'];
                        genderTextEditingController.text = (data)['gender'];
                        expiryTextEditingController.text = (data)['expiry_Date'];
                      });

                      mapData = data;

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
                                  "Scan MRZ of second page",
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

                  const SizedBox(height: 10,),

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
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1.5, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(15)
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),

                        // Country Code
                        const Icon(Icons.person,size: 22,),

                        const SizedBox(
                          width: 5,
                        ),

                        // Border
                        const Text(
                          "|",
                          style: TextStyle(fontSize: 25, color: Colors.black),
                        ),

                        const SizedBox(
                          width: 5,
                        ),

                        // Type TextField
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            maxLines: null,
                            controller: documentTypeTextEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Type",
                              hintText: "Type",
                              suffixIcon: documentTypeTextEditingController.text.isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () =>
                                    documentTypeTextEditingController.clear(),
                              ),

                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is empty";
                              }

                              else {
                                return null;
                              }
                            },
                          ),
                        ),

                      ],
                    ),
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
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1.5, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(15)
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),

                        // Country Code
                        const Icon(Icons.date_range,size: 22,),

                        const SizedBox(
                          width: 5,
                        ),

                        // Border
                        const Text(
                          "|",
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),

                        const SizedBox(
                          width: 5,
                        ),

                        // Country Code TextField
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            maxLines: null,
                            controller: countryCodeTextEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Country Code",
                              hintText: "Country Code",
                              suffixIcon: countryCodeTextEditingController.text.isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () =>
                                    countryCodeTextEditingController.clear(),
                              ),

                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is empty";
                              }

                              else {
                                return null;
                              }
                            },
                          ),
                        ),

                      ],
                    ),
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
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1.5, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(15)
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),

                        // Country Code
                        const Icon(Icons.numbers,size: 22,),

                        const SizedBox(
                          width: 5,
                        ),

                        // Border
                        const Text(
                          "|",
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        // Date of Birth TextField
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            maxLines: null,
                            controller: passportNumberTextEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Passport No",
                              hintText: "Passport No",
                              suffixIcon: passportNumberTextEditingController.text.isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () =>
                                    passportNumberTextEditingController.clear(),
                              ),

                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is empty";
                              }

                              else {
                                return null;
                              }
                            },
                          ),
                        ),

                      ],
                    ),
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
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1.5, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(15)
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),

                        // Country Code
                        const Icon(Icons.numbers,size: 22,),

                        const SizedBox(
                          width: 5,
                        ),

                        // Border
                        const Text(
                          "|",
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        // Surname
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            maxLines: null,
                            controller: givenNameTextEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Given Name",
                              hintText: "Given Name",
                              suffixIcon: givenNameTextEditingController.text.isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () =>
                                    givenNameTextEditingController.clear(),
                              ),

                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is empty";
                              }

                              else {
                                return null;
                              }
                            },
                          ),
                        ),

                      ],
                    ),
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
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1.5, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(15)
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),

                        // Country Code
                        const Icon(Icons.numbers,size: 22,),

                        const SizedBox(
                          width: 5,
                        ),

                        // Border
                        const Text(
                          "|",
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        // Given Name
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            maxLines: null,
                            controller: surnameTextEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Surname",
                              hintText: "Surname",
                              suffixIcon: surnameTextEditingController.text.isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () =>
                                    surnameTextEditingController.clear(),
                              ),

                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is empty";
                              }

                              else {
                                return null;
                              }
                            },
                          ),
                        ),

                      ],
                    ),
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
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1.5, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(15)
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),

                        // Country Code
                        const Icon(Icons.numbers,size: 22,),

                        const SizedBox(
                          width: 5,
                        ),

                        // Border
                        const Text(
                          "|",
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        // Given Name
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            maxLines: null,
                            controller: nationalityTextEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Nationality",
                              hintText: "Nationality",
                              suffixIcon: nationalityTextEditingController.text.isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () =>
                                    nationalityTextEditingController.clear(),
                              ),

                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is empty";
                              }

                              else {
                                return null;
                              }
                            },
                          ),
                        ),

                      ],
                    ),
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
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1.5, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(15)
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),

                        // Country Code
                        const Icon(Icons.numbers,size: 22,),

                        const SizedBox(
                          width: 5,
                        ),

                        // Border
                        const Text(
                          "|",
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        // Personal No
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            maxLines: null,
                            controller: personalNumberTextEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Personal No",
                              hintText: "Personal No",
                              suffixIcon: personalNumberTextEditingController.text.isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () =>
                                    personalNumberTextEditingController.clear(),
                              ),

                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is empty";
                              }

                              else {
                                return null;
                              }
                            },
                          ),
                        ),

                      ],
                    ),
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
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1.5, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(15)
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),

                        // Country Code
                        const Icon(Icons.numbers,size: 22,),

                        const SizedBox(
                          width: 5,
                        ),

                        // Border
                        const Text(
                          "|",
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        // Date of Birth
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            controller: dateOfBirthTextEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Date of Birth",
                              hintText: "Date of Birth",
                              suffixIcon: dateOfBirthTextEditingController.text.isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () =>
                                    dateOfBirthTextEditingController.clear(),
                              ),

                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is empty";
                              }

                              else {
                                return null;
                              }
                            },
                          ),
                        ),

                      ],
                    ),
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
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1.5, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(15)
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),

                        // Country Code
                        const Icon(Icons.numbers,size: 22,),

                        const SizedBox(
                          width: 5,
                        ),

                        // Border
                        const Text(
                          "|",
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        // Gender
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            controller: genderTextEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Gender",
                              hintText: "Gender",
                              suffixIcon: genderTextEditingController.text.isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () =>
                                    genderTextEditingController.clear(),
                              ),

                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is empty";
                              }

                              else {
                                return null;
                              }
                            },
                          ),
                        ),

                      ],
                    ),
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
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1.5, color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(15)
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),

                        // Country Code
                        const Icon(Icons.numbers,size: 22,),

                        const SizedBox(
                          width: 5,
                        ),

                        // Border
                        const Text(
                          "|",
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        // Gender
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            controller: expiryTextEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: "Date of Expiry",
                              hintText: "Date of Expiry",
                              suffixIcon: expiryTextEditingController.text.isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () =>
                                    expiryTextEditingController.clear(),
                              ),

                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is empty";
                              }

                              else {
                                return null;
                              }
                            },
                          ),
                        ),

                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.04,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Attach passport pages",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Please attach both pages\nof your passport",
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            color: Colors.grey
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),

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

                  SizedBox(
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

                  SizedBox(height: height * 0.05,),

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
                        }

                        Timer(const Duration(seconds: 5),()  {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => VisaFormScreen2(mapData: mapData,)));
                        });


                      },

                      style: ElevatedButton.styleFrom(
                          primary: (Colors.blue),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),

                      child: Text(
                        "Continue" ,
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.03,),


                ],
              )

          ),
        ),
      ),
    );
  }
}
