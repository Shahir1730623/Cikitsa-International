import 'dart:convert';
import 'dart:io';
import 'package:app/global/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrz_parser/mrz_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mrz_scanner/mrz_scanner.dart';

import 'our_services/ci_consultation/mrz_testing.dart';


class MRZTester extends StatefulWidget {
  const MRZTester({Key? key}) : super(key: key);

  @override
  State<MRZTester> createState() => _MRZTesterState();
}

class _MRZTesterState extends State<MRZTester> {
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

  TextEditingController attendantDocumentTypeTextEditingController = TextEditingController();
  TextEditingController attendantCountryCodeTextEditingController = TextEditingController();
  TextEditingController attendantPassportNumberTextEditingController = TextEditingController();
  TextEditingController attendantSurnameTextEditingController = TextEditingController();
  TextEditingController attendantGivenNameTextEditingController = TextEditingController();
  TextEditingController attendantNationalityTextEditingController = TextEditingController();
  TextEditingController attendantPersonalNumberTextEditingController = TextEditingController();
  TextEditingController attendantDateOfBirthTextEditingController = TextEditingController();
  TextEditingController attendantGenderTextEditingController = TextEditingController();
  TextEditingController attendantExpiryTextEditingController = TextEditingController();


  /*TextEditingController firstNameTextEditingController = TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();
  TextEditingController fatherNameTextEditingController = TextEditingController();
  TextEditingController motherNameTextEditingController = TextEditingController();
  TextEditingController spouseNameTextEditingController = TextEditingController();
  TextEditingController permanentAddressTextEditingController = TextEditingController();
  TextEditingController emergencyContactNameTextEditingController = TextEditingController();
  TextEditingController relationshipTextEditingController = TextEditingController();
  TextEditingController emergencyContactAddressTextEditingController = TextEditingController();
  TextEditingController telephoneNumberTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController idNoTextEditingController = TextEditingController();*/


  /*String scannedText = '';
  String testText = 'Nothing';
  //XFile? imageFile;
  File? imageFile;
  CroppedFile? croppedImage;
  bool textScanning = false;
  String? fullImage;
  List<String> list = [];*/


  // PickImage for patient
  /*Future pickImageForPatient(ImageSource source) async {
    try{
      final pickedImage = await ImagePicker().pickImage(source: source);
      if(pickedImage!=null){
        textScanning = true;
        File? img = File(pickedImage.path);
        croppedImage = await ImageCropper().cropImage(sourcePath: img.path,aspectRatio: const CropAspectRatio(ratioX: 30, ratioY: 4));
        if(croppedImage == null) {
          img =  null;
        }
        else{
          img = File(croppedImage!.path);
        }
        //imageFile = pickedImage;
        imageFile = img;
        setState(() {});
        getRecognisedText(imageFile!);
      }
    }

    catch(e){
      print(e);
      textScanning = false;
      imageFile = null;
      scannedText = e.toString();
      setState(() {});
    }

  }

  Future<File?> cropImage({required File imageFile}) async {
    croppedImage = await ImageCropper().cropImage(sourcePath: imageFile.path,aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 19));
    if(croppedImage == null) {
      return null;
    }
    else{
      return File(croppedImage!.path);
    }
  }


  void getRecognisedText(File image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
    scannedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text;
        list.add(line.text);
        /*list = ((line.text).split(':'));
        if(list[0] == "Name"){
          setState(() {
            nameTextEditingController.text = list[1].trim();
          });
        }

        else{
        }*/
      }
      scannedText = scannedText + '\n\n';
    }
    textScanning = false;
    setState(() {});

  }

  void mrzScanner(){
    print(list[0]);
    final mrz = [
      "${list[0]}<<<<<<<<<<<<<<<<<<",
      list[1]
    ];

    // Alternatively use parse and catch MRZException descendants
    try {
      final result = MRZParser.parse(mrz);
      setState((){
        testText = result.surnames;
      });

    }

    on MRZException catch(e) {
      print(e);
    }
  }*/



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                        "Please attach second page\nof Passport",
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
                  SizedBox(
                    height: height * 0.01,
                  ),


                ],
              )

          ),
        ),
      ),
    );
  }
}

