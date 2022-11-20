import 'dart:async';

import 'package:app/authentication/initialization_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';
import '../home/home_screen.dart';
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
    "Pathologist"
        "Radiologists",
    "Rheumatologists",
    "Orthopedics",
    "Urologist"
  ];
  List<String> doctorExperienceList = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"];

  String? selectedSpecialization;
  String? selectedExperience;


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

  void saveNameToDatabase() async {
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage
        .instance.ref('doctorImages/dummy-image.png');
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

                      (userType == "Users") ?
                      Column(
                        children: [
                          const SizedBox(height: 50,),

                          // Full name Container
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 1.5, color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(15)
                            ),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),

                                // Country Code
                                const Icon(Icons.person, size: 30,),

                                const SizedBox(
                                  width: 5,
                                ),

                                // Border
                                const Text(
                                  "|",
                                  style: TextStyle(
                                      fontSize: 40, color: Colors.black),
                                ),

                                const SizedBox(
                                  width: 10,
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
                                      labelText: "Full Name",
                                      hintText: "Full Name",
                                      suffixIcon: nameTextEditingController.text
                                          .isEmpty
                                          ? Container(width: 0)
                                          : IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () =>
                                            nameTextEditingController.clear(),
                                      ),

                                      hintStyle:
                                      const TextStyle(
                                          color: Colors.grey, fontSize: 16),
                                      labelStyle:
                                      const TextStyle(
                                          color: Colors.black, fontSize: 16),
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
                            height: height * 0.02,
                          ),

                          // Email Container
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 1.5, color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(15)
                            ),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),

                                // Country Code
                                const Icon(Icons.email, size: 30,),

                                const SizedBox(
                                  width: 5,
                                ),

                                // Border
                                const Text(
                                  "|",
                                  style: TextStyle(
                                      fontSize: 40, color: Colors.black),
                                ),

                                const SizedBox(
                                  width: 10,
                                ),

                                // Email TextField
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    maxLines: null,
                                    controller: emailTextEditingController,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Email",
                                      hintText: "Email",
                                      suffixIcon: emailTextEditingController
                                          .text.isEmpty
                                          ? Container(width: 0)
                                          : IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () =>
                                            emailTextEditingController.clear(),
                                      ),

                                      hintStyle:
                                      const TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                      labelStyle:
                                      const TextStyle(
                                          color: Colors.black, fontSize: 15),
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
                                )

                              ],
                            ),


                          ),

                          SizedBox(height: height * 0.25),

                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return ProgressDialog(message: "Please wait...");
                                      }
                                  );

                                  saveNameToDatabase();

                                  Timer(const Duration(seconds: 3), () {
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => const Initialization()));
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
                      ) :
                      Column(
                        children: [
                          const SizedBox(height: 30,),
                          // First Name Field
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Full Name",
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
                            controller: nameTextEditingController,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              labelText: "Name",
                              hintText: "Name",
                              prefixIcon: IconButton(
                                icon: Image.asset(
                                  "assets/user.png",
                                  height: 18,
                                ),
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
                              } else
                                return null;
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
                              } else
                                return null;
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

                                  saveNameToDatabase();

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
