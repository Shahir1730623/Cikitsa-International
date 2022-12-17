import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app/global/global.dart';
import 'package:app/our_services/visa_invitation/medical_documents_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/progress_dialog.dart';

class VisaFormScreen extends StatefulWidget {
  const VisaFormScreen({Key? key}) : super(key: key);

  @override
  State<VisaFormScreen> createState() => _VisaFormScreenState();
}

class _VisaFormScreenState extends State<VisaFormScreen> {

  TextEditingController firstNameTextEditingController = TextEditingController();
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
  TextEditingController dateOfBirthTextEditingController = TextEditingController();
  TextEditingController idNoTextEditingController = TextEditingController();

  TextEditingController attendantNameTextEditingController = TextEditingController();
  TextEditingController attendantDateOfBirthTextEditingController = TextEditingController();
  TextEditingController attendantIdNoTextEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstNameTextEditingController.addListener(() => setState(() {}));
    lastNameTextEditingController.addListener(() => setState(() {}));
    fatherNameTextEditingController.addListener(() => setState(() {}));
    motherNameTextEditingController.addListener(() => setState(() {}));
    spouseNameTextEditingController.addListener(() => setState(() {}));
    permanentAddressTextEditingController.addListener(() => setState(() {}));
    emergencyContactNameTextEditingController.addListener(() => setState(() {}));
    relationshipTextEditingController.addListener(() => setState(() {}));
    emergencyContactAddressTextEditingController.addListener(() => setState(() {}));
    telephoneNumberTextEditingController.addListener(() => setState(() {}));

    nameTextEditingController.addListener(() => setState(() {}));
    dateOfBirthTextEditingController.addListener(() => setState(() {}));
    idNoTextEditingController.addListener(() => setState(() {}));

    attendantNameTextEditingController.addListener(() => setState(() {}));
    attendantDateOfBirthTextEditingController.addListener(() => setState(() {}));
    attendantIdNoTextEditingController.addListener(() => setState(() {}));

  }

  String scannedText = '';
  String scannedText2 = '';
  XFile? imageFile;
  XFile? imageFile2;
  bool textScanning = false;
  bool textScanning2 = false;

  // PickImage for patient
  Future pickImageForPatient(ImageSource source) async {
    try{
      final pickedImage = await ImagePicker().pickImage(source: source);
      if(pickedImage!=null){
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    }

    catch(e){
      print(e);
      textScanning = false;
      imageFile = null;
      scannedText = "Error occurred while scanning image";
      setState(() {});
    }
  }

  // PickImage for attendant
  Future pickImageForAttendant(ImageSource source) async {
    try{
      final pickedImage = await ImagePicker().pickImage(source: source);
      if(pickedImage!=null){
        textScanning2 = true;
        imageFile2 = pickedImage;
        setState(() {});
        getRecognisedTextForAttendant(pickedImage);
      }
    }

    catch(e){
      print(e);
      textScanning2 = false;
      imageFile2 = null;
      scannedText2 = "Error occurred while scanning image";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
    scannedText = "";
    List<String> list;
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text;
        list = ((line.text).split(':'));
        if(list[0] == "Name"){
          setState(() {
            nameTextEditingController.text = list[1].trim();
          });
        }

        else if(list[0] == "Date of Birth"){
          setState(() {
            dateOfBirthTextEditingController.text = list[1].trim();
          });
        }

        else if(list[0] == "ID NO"){
          setState(() {
            String id = list[1].replaceAll(' ','').trim();
            idNoTextEditingController.text = id;
          });
        }

        else{
        }
      }
      scannedText = scannedText + '\n';
    }
    textScanning = false;
    setState(() {});
  }

  void getRecognisedTextForAttendant(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
    scannedText2 = "";
    List<String> list;
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText2 = scannedText2 + line.text;
        list = ((line.text).split(':'));
        if(list[0] == "Name"){
          setState(() {
            attendantNameTextEditingController.text = list[1].trim();
          });
        }

        else if(list[0] == "Date of Birth"){
          setState(() {
            attendantDateOfBirthTextEditingController.text = list[1].trim();
          });
        }

        else if(list[0] == "ID NO"){
          setState(() {
            String id = list[1].replaceAll(' ','').trim();
            attendantIdNoTextEditingController.text = id;
          });
        }

        else{
        }
      }
      scannedText = scannedText + '\n';
    }

    textScanning2 = false;
    setState(() {});
  }

  saveVisaInvitationInfo(){
    patientName = nameTextEditingController.text.trim();
    patientDateOfBirth = dateOfBirthTextEditingController.text.trim();
    patientIDNo = idNoTextEditingController.text.trim();

    attendantName = attendantNameTextEditingController.text.trim();
    attendantDateOfBirth = attendantDateOfBirthTextEditingController.text.trim();
    attendantIDNo = attendantIdNoTextEditingController.text.trim();
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/visaInvitationImages/Visa_Image-1.jpg",
                ),

                const SizedBox(height: 15,),
                
                Text(
                  "Visa Form",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.black
                  ),
                ),

                const SizedBox(height: 10,),

                Image.asset(
                  "assets/visaInvitationImages/passport.png",
                  width: 80,
                ),

                const SizedBox(height: 30,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Attach your NID",
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
                      "Please attach image of your front\npage of NID",
                      style: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: Colors.grey
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10,),

                // Uploaded Image Container
                Container(
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (textScanning) const CircularProgressIndicator(),
                        if (!textScanning && imageFile == null)
                          Container(
                            width: 250,
                            height: 250,
                            color: Colors.grey[200]!,
                          ),
                        if (imageFile != null) Image.file(File(imageFile!.path)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Colors.blue,
                                    shadowColor: Colors.grey[200],
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0)),
                                  ),
                                  onPressed: () {
                                    pickImageForPatient(ImageSource.gallery);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.image,
                                          size: 30,
                                        ),
                                        Text(
                                          "Gallery",
                                          style: TextStyle(
                                              fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )),

                            Container(
                                margin: const EdgeInsets.symmetric(horizontal: 5),
                                padding: const EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary: Colors.blue,
                                    shadowColor: Colors.grey[200],
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0)),
                                  ),
                                  onPressed: () {
                                    pickImageForPatient(ImageSource.camera);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.camera_alt,
                                          size: 30,
                                        ),
                                        Text(
                                          "Camera",
                                          style: TextStyle(
                                              fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),

                        Text(
                          scannedText,
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    )),

                // Form
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      "Name",
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

                          // Full Name TextField
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              maxLines: null,
                              controller: nameTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Name",
                                hintText: "Name",
                                suffixIcon: nameTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      nameTextEditingController.clear(),
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

                          // Date of Birth TextField
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
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

                    // ID No
                    Text(
                      "ID No",
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
                              controller: idNoTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "ID No",
                                hintText: "ID No",
                                suffixIcon: idNoTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      idNoTextEditingController.clear(),
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
                      height: height * 0.05,
                    ),

                    //Attendants
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Attach Attendants NID",
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
                          "Please attach image of front page\nof attendant's NID",
                          style: GoogleFonts.montserrat(
                              fontSize: 15,
                              color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),

                    Container(
                        margin: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (textScanning2) const CircularProgressIndicator(),
                            if (!textScanning2 && imageFile2 == null)
                              Container(
                                width: 250,
                                height: 250,
                                color: Colors.grey[200]!,
                              ),
                            if (imageFile2 != null) Image.file(File(imageFile2!.path)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 5),
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        onPrimary: Colors.blue,
                                        shadowColor: Colors.grey[200],
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0)),
                                      ),
                                      onPressed: () {
                                        pickImageForAttendant(ImageSource.gallery);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(
                                              Icons.image,
                                              size: 30,
                                            ),
                                            Text(
                                              "Gallery",
                                              style: TextStyle(
                                                  fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),

                                Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 5),
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        onPrimary: Colors.blue,
                                        shadowColor: Colors.grey[200],
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0)),
                                      ),
                                      onPressed: () {
                                        pickImageForAttendant(ImageSource.camera);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(
                                              Icons.camera_alt,
                                              size: 30,
                                            ),
                                            Text(
                                              "Camera",
                                              style: TextStyle(
                                                  fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            Text(
                              scannedText2,
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        )),

                    const SizedBox(height: 20,),

                    // Attendant's Name
                    Text(
                      "Attendant's Name",
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

                          // Full Name TextField
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              maxLines: null,
                              controller: attendantNameTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Name",
                                hintText: "Name",
                                suffixIcon: attendantNameTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      attendantNameTextEditingController.clear(),
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

                    // Attendant's Date of Birth
                    Text(
                      "Attendant's Date of Birth",
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

                          // Date of Birth TextField
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              maxLines: null,
                              controller: attendantDateOfBirthTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Date of Birth",
                                hintText: "Date of Birth",
                                suffixIcon: attendantDateOfBirthTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      attendantDateOfBirthTextEditingController.clear(),
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

                    // Attendant's ID No
                    Text(
                      "Attendant's ID No",
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
                              controller: attendantIdNoTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "ID No",
                                hintText: "ID No",
                                suffixIcon: attendantIdNoTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      attendantIdNoTextEditingController.clear(),
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
                      height: height * 0.05,
                    ),

                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: ()  {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context){
                                return ProgressDialog(message: "");
                              }
                          );

                          saveVisaInvitationInfo();

                          Timer(const Duration(seconds: 3),()  {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicalDocumentsForm()));

                          });
                        },
                        style: ElevatedButton.styleFrom(
                            primary: (Colors.lightBlue),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20))),

                        child: Text(
                          "Continue",
                          style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: height * 0.02
                    ),

                  ],
                )

                /*Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First Name Container
                    Text(
                      "First Name",
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
                          Icon(Icons.person,size: 25,),

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

                          // Full Name TextField
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              maxLines: null,
                              controller: firstNameTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "First Name",
                                hintText: "First Name",
                                suffixIcon: firstNameTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      firstNameTextEditingController.clear(),
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

                    // Last Name Container
                    Text(
                      "Last Name",
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
                          Icon(Icons.person,size: 25,),

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

                          // Full Name TextField
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              maxLines: null,
                              controller: lastNameTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Last Name",
                                hintText: "Last Name",
                                suffixIcon: lastNameTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      lastNameTextEditingController.clear(),
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

                    // Father's Name Container
                    Text(
                      "Father's Name",
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
                          Icon(Icons.person_add,size: 25,),

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

                          // Full Name TextField
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              maxLines: null,
                              controller: fatherNameTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Father's Name",
                                hintText: "Father's Name",
                                suffixIcon: fatherNameTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      fatherNameTextEditingController.clear(),
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

                    // Mother's Name Container
                    Text(
                      "Mother's Name",
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
                          Icon(Icons.person_add,size: 25,),

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

                          // Full Name TextField
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              maxLines: null,
                              controller: motherNameTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Mother's Name",
                                hintText: "Mother's Name",
                                suffixIcon: motherNameTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      motherNameTextEditingController.clear(),
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

                    // Spouse's Name Container
                    Text(
                      "Spouse's Name",
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
                          Icon(Icons.person,size: 25,),

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

                          // Passport Name TextField
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              maxLines: null,
                              controller: spouseNameTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Spouse's Name",
                                hintText: "Spouse's Name",
                                suffixIcon: spouseNameTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      spouseNameTextEditingController.clear(),
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


                    // Permanent Address
                    Text(
                      "Permanent Address",
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
                          Icon(Icons.person_add,size: 25,),

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

                          // Full Name TextField
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              maxLines: null,
                              controller: permanentAddressTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Permanent Address",
                                hintText: "Permanent Address",
                                suffixIcon: permanentAddressTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      permanentAddressTextEditingController.clear(),
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

                    // Emergency Contact Name
                    Text(
                      "Emergency Contact Name",
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
                          Icon(Icons.person_add,size: 25,),

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

                          // Full Name TextField
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              maxLines: null,
                              controller: emergencyContactNameTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Emergency Contact Name",
                                hintText: "Emergency Contact Name",
                                suffixIcon: emergencyContactNameTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      emergencyContactNameTextEditingController.clear(),
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

                    // Relationship
                    Text(
                      "Relationship",
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
                          Icon(Icons.person,size: 25,),

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

                          // Full Name TextField
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              maxLines: null,
                              controller: relationshipTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Relationship",
                                hintText: "Relationship",
                                suffixIcon: relationshipTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      relationshipTextEditingController.clear(),
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

                    // Emergency Contact Address
                    Text(
                      "Emergency Contact Address",
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
                          Icon(Icons.person,size: 25,),

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

                          // Full Name TextField
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              maxLines: null,
                              controller: emergencyContactAddressTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Emergency Contact Address",
                                hintText: "Emergency Contact Address",
                                suffixIcon: emergencyContactAddressTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      emergencyContactAddressTextEditingController.clear(),
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

                    // Telephone No.
                    Text(
                      "Telephone Number",
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
                          Icon(Icons.person,size: 25,),

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

                          // Full Name TextField
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              maxLines: null,
                              controller: telephoneNumberTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Telephone Number",
                                hintText: "Telephone Number",
                                suffixIcon: telephoneNumberTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      telephoneNumberTextEditingController.clear(),
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
                )*/




              ],
            ),
          ),
        ),
      ),
    );
  }
}
