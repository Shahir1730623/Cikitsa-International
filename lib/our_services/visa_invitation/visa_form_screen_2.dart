import 'dart:async';
import 'dart:io';
import 'package:app/models/visa_form_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../global/global.dart';
import '../../widgets/progress_dialog.dart';
import '../ci_consultation/mrz_testing.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'medical_documents_form.dart';

class VisaFormScreen2 extends StatefulWidget {
  VisaFormScreen2({Key? key}) : super(key: key);

  @override
  State<VisaFormScreen2> createState() => _VisaFormScreen2State();
}

class _VisaFormScreen2State extends State<VisaFormScreen2> {
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

  XFile? imageFile;
  List<File> imageList = [];
  final _formKey = GlobalKey<FormState>();
  bool flag = false;

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
        flag = true;
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
    attendantDocumentTypeTextEditingController.addListener(() => setState(() {}));
    attendantCountryCodeTextEditingController.addListener(() => setState(() {}));
    attendantPassportNumberTextEditingController.addListener(() => setState(() {}));
    attendantSurnameTextEditingController.addListener(() => setState(() {}));
    attendantGivenNameTextEditingController.addListener(() => setState(() {}));
    attendantNationalityTextEditingController.addListener(() => setState(() {}));
    attendantPersonalNumberTextEditingController.addListener(() => setState(() {}));
    attendantDateOfBirthTextEditingController.addListener(() => setState(() {}));
    attendantGenderTextEditingController.addListener(() => setState(() {}));
    attendantExpiryTextEditingController.addListener(() => setState(() {}));
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/visaInvitationImages/Visa_Image-2.jpg",
                    ),

                    const SizedBox(height: 15,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Visa Form for Attendant",
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
                          "Attach attendant's\nPassport",
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

                    // Image Scanner
                    GestureDetector(
                      onTap: () async {
                        final data = await Navigator.push(context, MaterialPageRoute(builder: (context) => CameraPage()));
                        var snackBar = const SnackBar(content: Text("Scanned Successfully"));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        setState(() {
                          attendantDocumentTypeTextEditingController.text = (data)['type'];
                          attendantCountryCodeTextEditingController.text = (data)['country_Code'];
                          attendantPassportNumberTextEditingController.text = (data)['document_Number'];
                          attendantSurnameTextEditingController.text = (data)['surname'];
                          attendantGivenNameTextEditingController.text = (data)['given_Name'];
                          attendantNationalityTextEditingController.text = (data)['nationality'];
                          attendantPersonalNumberTextEditingController.text = (data)['personal_Number'];
                          attendantDateOfBirthTextEditingController.text =  (data)['birth_Date'];
                          attendantGenderTextEditingController.text = (data)['gender'];
                          attendantExpiryTextEditingController.text = (data)['expiry_Date'];
                        });

                        mapData2 = data;

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
                                    "Scan passport second page",
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

                    TextFormField(
                      controller: attendantDocumentTypeTextEditingController,
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
                        suffixIcon: attendantDocumentTypeTextEditingController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () =>
                              attendantDocumentTypeTextEditingController.clear(),
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
                      controller: attendantCountryCodeTextEditingController,
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
                        suffixIcon: attendantCountryCodeTextEditingController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () =>
                              attendantCountryCodeTextEditingController.clear(),
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
                      "Attendant's Passport No",
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

                    SizedBox(
                      height: height * 0.01,
                    ),

                    // Given Name
                    Text(
                      "Attendant's Given Name",
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

                    SizedBox(
                      height: height * 0.01,
                    ),

                    // Surname
                    Text(
                      "Attendant's Surname",
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

                    SizedBox(
                      height: height * 0.01,
                    ),

                    // Nationality
                    Text(
                      "Attendant's Nationality",
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

                    SizedBox(
                      height: height * 0.01,
                    ),

                    // Personal No
                    Text(
                      "Passport Personal No",
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

                    SizedBox(
                      height: height * 0.01,
                    ),

                    // Date of Birth
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

                    TextFormField(
                      controller: attendantDateOfBirthTextEditingController,
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

                    SizedBox(
                      height: height * 0.01,
                    ),

                    // Gender
                    Text(
                      "Attendant's Gender",
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
                        suffixIcon: attendantGenderTextEditingController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                          icon: const Icon(Icons.close),
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
                      controller: attendantExpiryTextEditingController,
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
                        suffixIcon: attendantExpiryTextEditingController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                          icon: const Icon(Icons.close),
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

                    const SizedBox(
                      height: 10,
                    ),

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
                        if(flag){
                          var snackBar = const SnackBar(content: Text("Uploaded successfully"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        else{
                          var snackBar = const SnackBar(content: Text("No photo selected"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
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
                                    "Upload both passport pages",
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
                          if (_formKey.currentState!.validate() && flag){
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalDocumentsForm()));
                            });
                          }

                          else{
                            if(flag == false){
                              var snackBar = const SnackBar(content: Text('Please upload passport photos'));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                            else{
                              var snackBar = const SnackBar(content: Text('Fill up the form correctly'));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }

                          }

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
      ),
    );
  }
}
