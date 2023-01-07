import 'dart:async';

import 'package:app/authentication/initialization_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';
import '../widgets/progress_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CreateProfile extends StatefulWidget {
  String? id;
  String? phone;

  CreateProfile({Key? key, required this.id, required this.phone});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController firstNameTextEditingController = TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController feeTextEditingController = TextEditingController();
  TextEditingController degreesTextEditingController = TextEditingController();
  TextEditingController workplaceTextEditingController = TextEditingController();
  List<String> doctorSpecializationList = [
    "Allergists/Immunologists",
    "Internal Medicine",
    "Cardiologists",
    "Dermatologists",
    "Ophthalmologists",
    "Gynecologists",
    "Cardiologists",
    "Endocrinologists",
    "Gastroenterologists",
    "Neurologists",
    "Urologists",
    "Psychiatrists",
    "Pathologist",
    "Radiologists",
    "Rheumatologists",
    "Orthopedics",
    "Urologist"
  ];
  List<String> doctorExperienceList = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"];
  String? selectedSpecialization;
  String? selectedExperience;
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameTextEditingController.addListener(() => setState(() {}));
    firstNameTextEditingController.addListener(() => setState(() {}));
    lastNameTextEditingController.addListener(() => setState(() {}));
    emailTextEditingController.addListener(() => setState(() {}));
    feeTextEditingController.addListener(() => setState(() {}));
    degreesTextEditingController.addListener(() => setState(() {}));
    workplaceTextEditingController.addListener(() => setState(() {}));
  }

  void saveInformationToDatabase() async {
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('doctorImages/dummy-image.png');
    var imageUrl = await reference.getDownloadURL();

    if (userType == "Users") {
      DatabaseReference reference = FirebaseDatabase.instance.ref().child(userType!);
      Map userModel = {
        "id": widget.id,
        "name": nameTextEditingController.text,
        "email": emailTextEditingController.text,
        "phone": widget.phone,
        "imageUrl": imageUrl
      };

      reference.child(currentFirebaseUser!.uid).set(userModel);
      Fluttertoast.showToast(msg: "User Profile Created");
    }

    else if(userType == "Consultant"){
      DatabaseReference reference = FirebaseDatabase.instance.ref().child(userType!);
      Map consultantModel = {
        "id": widget.id,
        "name": nameTextEditingController.text,
        "email": emailTextEditingController.text,
        "phone": widget.phone,
        "imageUrl": imageUrl
      };

      reference.child(currentFirebaseUser!.uid).set(consultantModel);
      Fluttertoast.showToast(msg: "Consultant Profile Created");
    }

    else {
      DatabaseReference reference2 = FirebaseDatabase.instance.ref().child(userType!);
      Map doctorModel = {
        "id": widget.id,
        "firstName": firstNameTextEditingController.text.trim(),
        "lastName": lastNameTextEditingController.text.trim(),
        "email": emailTextEditingController.text,
        "phone": widget.phone,
        "imageUrl": imageUrl,
        "specialization": selectedSpecialization,
        "fee": feeTextEditingController.text,
        "degrees": degreesTextEditingController.text,
        "status": "Online",
        "totalVisits": "0",
        "experience": selectedExperience,
        "rating": "0",
        "workplace": workplaceTextEditingController.text
      };

      reference2.child(currentFirebaseUser!.uid).set(doctorModel);
      Fluttertoast.showToast(msg: "Doctor Profile Created");
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
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

              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Profile Info",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),

                      Image.asset(
                        "assets/id-card.png",
                        height: height * 0.15,
                      ),

                      const SizedBox(height: 10,),

                      const Text(
                        "Provide your information",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),

                      const SizedBox(height: 10,),

                      const Text(
                        "Please input your details in the given field",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),

                      (userType == "Users" || userType == "Consultant") ?
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50,),

                            // Full Name
                            Text(
                              "Full Name",
                              style: GoogleFonts.montserrat(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            TextFormField(
                              controller: nameTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Full Name",
                                hintText: "Full Name",
                                prefixIcon: IconButton(
                                  icon: const Icon(Icons.person,color: Colors.black,),
                                  onPressed: () {},
                                ),
                                suffixIcon: nameTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () =>
                                      nameTextEditingController.clear(),
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

                            // Email Container
                            Text(
                              "Email",
                              style: GoogleFonts.montserrat(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            TextFormField(
                              controller: emailTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Email",
                                hintText: "Email",
                                prefixIcon: IconButton(
                                  icon: const Icon(Icons.email,color: Colors.black,),
                                  onPressed: () {},
                                ),
                                suffixIcon: emailTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () =>
                                      emailTextEditingController.clear(),
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
                                if (value!.isEmpty) {
                                  return "The field is empty";
                                }

                                else if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                                  return null;
                                }

                                else {
                                  return "Wrong email format!";
                                }
                              },

                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),

                            SizedBox(height: height * 0.3),

                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()){
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return ProgressDialog(message: "Please wait...");
                                          }
                                      );

                                      saveInformationToDatabase();
                                      Timer(const Duration(seconds: 3), () {
                                        Navigator.pop(context);
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => const Initialization()));
                                      });
                                    }

                                    else{
                                      var snackBar = const SnackBar(content: Text('Fill up the form correctly'));
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }

                                  },

                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.lightBlue,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)
                                      )
                                  ),

                                  child: const Text(
                                    "Continue",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),
                                  )
                              ),
                            ),

                            SizedBox(height: height * 0.1),
                          ],
                        ),
                      ) :

                      Column(
                        children: [
                          const SizedBox(height: 30,),
                          // First Name Field
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "First Name",
                                style: GoogleFonts.montserrat(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          TextFormField(
                            controller: firstNameTextEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              labelText: "First Name",
                              hintText: "First Name",
                              prefixIcon: IconButton(
                                icon: Image.asset(
                                  "assets/user.png",
                                  height: 18,
                                ),
                                onPressed: () {},
                              ),
                              suffixIcon: firstNameTextEditingController.text.isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () =>
                                    firstNameTextEditingController.clear(),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(
                                  color: Colors.black, fontSize: 15),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is empty";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),

                          // Last Name Field
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Last Name",
                                style: GoogleFonts.montserrat(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          TextFormField(
                            controller: lastNameTextEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              labelText: "Last Name",
                              hintText: "Last Name",
                              prefixIcon: IconButton(
                                icon: Image.asset(
                                  "assets/user.png",
                                  height: 18,
                                ),
                                onPressed: () {},
                              ),
                              suffixIcon: lastNameTextEditingController.text.isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () =>
                                    lastNameTextEditingController.clear(),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(
                                  color: Colors.black, fontSize: 15),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is empty";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),

                          // Email Text Field
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Email",
                                style: GoogleFonts.montserrat(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          TextFormField(
                            controller: emailTextEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Email",
                              hintText: "Email",
                              prefixIcon: IconButton(
                                icon: Image.asset(
                                  "assets/authenticationImages/email.png",
                                  height: 18,
                                ),
                                onPressed: () {},
                              ),
                              suffixIcon: emailTextEditingController.text
                                  .isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () =>
                                    emailTextEditingController.clear(),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(
                                  color: Colors.black, fontSize: 15),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is empty";
                              }

                              else if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                                return null;
                              }

                              else {
                                return "Wrong email format!";
                              }
                            },
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),

                          // Specialization Text Field
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Specialization",
                                style: GoogleFonts.montserrat(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: Image.asset(
                                  "assets/authenticationImages/stethoscope.png",
                                  height: 18,
                                ),
                              ),
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            isExpanded: true,
                            iconSize: 30,
                            dropdownColor: Colors.white,
                            hint: const Text(
                              "Specify specialization",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                            value: selectedSpecialization,
                            onChanged: (newValue) {
                              setState(() {
                                selectedSpecialization = newValue.toString();
                              });
                            },
                            items: doctorSpecializationList.map((reason) {
                              return DropdownMenuItem(
                                value: reason,
                                child: Text(
                                  reason,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            validator: (value){
                              if (value!.isEmpty) {
                                return "Specify specialization";
                              }

                              else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),

                          // Fee Text Field
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Consultation Fee",
                                style: GoogleFonts.montserrat(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          TextFormField(
                            controller: feeTextEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Fee",
                              hintText: "Fee",
                              prefixIcon: IconButton(
                                icon: Image.asset(
                                  "assets/authenticationImages/money.png",
                                  height: 18,
                                ),
                                onPressed: () {},
                              ),
                              suffixIcon: feeTextEditingController.text.isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () =>
                                    feeTextEditingController.clear(),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(
                                  color: Colors.black, fontSize: 15),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is empty";
                              } else
                                return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),

                          // Degrees Text Field
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Degrees",
                                style: GoogleFonts.montserrat(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          TextFormField(
                            controller: degreesTextEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Degree",
                              hintText: "Degree",
                              prefixIcon: IconButton(
                                icon: Image.asset(
                                  "assets/authenticationImages/degree.png",
                                  height: 18,
                                ),
                                onPressed: () {},
                              ),
                              suffixIcon: degreesTextEditingController.text
                                  .isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () =>
                                    degreesTextEditingController.clear(),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(
                                  color: Colors.black, fontSize: 15),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is empty";
                              } else
                                return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),

                          // Experience
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Experience",
                                style: GoogleFonts.montserrat(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: IconButton(
                                onPressed: () {},
                                icon: Image.asset(
                                  "assets/authenticationImages/experience.png",
                                  height: 18,
                                ),
                              ),
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            isExpanded: true,
                            iconSize: 30,
                            dropdownColor: Colors.white,
                            hint: const Text(
                              "Select Experience",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                            value: selectedExperience,
                            onChanged: (newValue) {
                              setState(() {
                                selectedExperience = newValue.toString();
                              });
                            },
                            items: doctorExperienceList.map((reason) {
                              return DropdownMenuItem(
                                value: reason,
                                child: Text(
                                  reason,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),

                          // Workplace
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Workplace",
                                style: GoogleFonts.montserrat(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          TextFormField(
                            controller: workplaceTextEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Workplace",
                              hintText: "Workplace",
                              prefixIcon: IconButton(
                                icon: Image.asset(
                                  "assets/authenticationImages/workplace.png",
                                  height: 18,
                                ),
                                onPressed: () {},
                              ),
                              suffixIcon: workplaceTextEditingController.text
                                  .isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () =>
                                    workplaceTextEditingController.clear(),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 15),
                              labelStyle:
                              const TextStyle(
                                  color: Colors.black, fontSize: 15),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is empty";
                              } else
                                return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),

                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context){
                                        return ProgressDialog(message: "Please wait...");
                                      }
                                  );

                                  saveInformationToDatabase();

                                  Timer(const Duration(seconds: 3), () {
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Initialization()));
                                  });

                                  },

                                style: ElevatedButton.styleFrom(
                                    primary: Colors.lightBlue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)
                                    )
                                ),

                                child: const Text(
                                  "Continue",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                            ),
                          ),
                        ],
                      )


                    ],
                  ),
                ),
              ),

            ),
          ),
        );
      }
}
