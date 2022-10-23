import 'dart:math';

import 'package:app/common_screens/choose_user.dart';
import 'package:app/common_screens/select_schedule_form.dart';
import 'package:app/home/home_screen.dart';
import 'package:app/main_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';

class NewUserForm extends StatefulWidget {
  const NewUserForm({Key? key}) : super(key: key);

  @override
  State<NewUserForm> createState() => _NewUserFormState();
}

class _NewUserFormState extends State<NewUserForm> {
  TextEditingController firstNameTextEditingController = TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();
  TextEditingController ageTextEditingController = TextEditingController();
  TextEditingController weightTextEditingController = TextEditingController();
  TextEditingController heightTextEditingController = TextEditingController();
  TextEditingController genderTextEditingController = TextEditingController();
  TextEditingController relationshipTextEditingController = TextEditingController();
  TextEditingController problemTextEditingController = TextEditingController();

  List<String> genderTypesList = ["Male", "Female"];
  String? selectedGender;


  final _formKey = GlobalKey<FormState>();

  String idGenerator() {
    Random random =  Random();
    int randomNumber = random.nextInt(20000) + 10000;
    int randomNumber2 = random.nextInt(10000);
    return (randomNumber + randomNumber2).toString();
  }


  saveNewUserInfo() {
    String id = idGenerator();
    // Saving patientId to global
    patientId = id;

    Map patientInfoMap = {
      "id": id,
      "firstName": firstNameTextEditingController.text.trim(),
      "lastName": lastNameTextEditingController.text.trim(),
      "age": ageTextEditingController.text.trim(),
      "weight": weightTextEditingController.text.trim(),
      "height": heightTextEditingController.text.trim(),
      "gender": genderTextEditingController.text.trim(),
    };


    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child("Users");
    
    reference
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(id)
        .set(patientInfoMap);



  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstNameTextEditingController.addListener(() => setState(() {}));
    lastNameTextEditingController.addListener(() => setState(() {}));
    ageTextEditingController.addListener(() => setState(() {}));
    weightTextEditingController.addListener(() => setState(() {}));
    heightTextEditingController.addListener(() => setState(() {}));
    genderTextEditingController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Image.asset(
              "assets/Logo.png",
              height: 50,
              width: 50,
              alignment: Alignment.centerLeft,
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Text(
              "Patient Information",
              style: GoogleFonts.montserrat(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(
              height: height * 0.005,
            ),

            const Text(
              "Fill up the required information",
            ),
            SizedBox(height: height * 0.03),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First Name Field
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
                  TextFormField(
                    controller: firstNameTextEditingController,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
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
                              icon: Icon(Icons.close),
                              onPressed: () =>
                                  firstNameTextEditingController.clear(),
                            ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle:
                          const TextStyle(color: Colors.black, fontSize: 15),
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

                  // Last Name Field
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
                  TextFormField(
                    controller: lastNameTextEditingController,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
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
                              icon: Icon(Icons.close),
                              onPressed: () =>
                                  lastNameTextEditingController.clear(),
                            ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle:
                          const TextStyle(color: Colors.black, fontSize: 15),
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

                  // Age Field
                  Text(
                    "Age",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: ageTextEditingController,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: "Age",
                      hintText: "Age",
                      prefixIcon: IconButton(
                        icon: Image.asset(
                          "assets/age.png",
                          height: 18,
                        ),
                        onPressed: () {},
                      ),
                      suffixIcon: ageTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () =>
                                  lastNameTextEditingController.clear(),
                            ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      hintStyle:
                          const TextStyle(color: Colors.grey, fontSize: 15),
                      labelStyle:
                          const TextStyle(color: Colors.black, fontSize: 15),
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

                  // Gender fields
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Gender",
                                hintText: "Gender",
                                prefixIcon: IconButton(
                                  icon: Image.asset(
                                    "assets/gender.png",
                                    height: 18,
                                  ),
                                  onPressed: () {},
                                ),
                                suffixIcon: genderTextEditingController
                                    .text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      genderTextEditingController.clear(),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                hintStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 15),
                                labelStyle: const TextStyle(
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
                          ],
                        ),
                      ),
                    ],
                  ),


                  // Height,Weight Fields
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Weight",
                              style: GoogleFonts.montserrat(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            TextFormField(
                              controller: weightTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Weight",
                                hintText: "Weight",
                                prefixIcon: IconButton(
                                  icon: Image.asset(
                                    "assets/weight.png",
                                    height: 18,
                                  ),
                                  onPressed: () {},
                                ),
                                suffixIcon: weightTextEditingController
                                        .text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () =>
                                            weightTextEditingController.clear(),
                                      ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                hintStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 15),
                                labelStyle: const TextStyle(
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
                          ],
                        ),
                      ),
                      SizedBox(
                        width: height * 0.005,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Height",
                              style: GoogleFonts.montserrat(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            TextFormField(
                              controller: heightTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Height",
                                hintText: "Height",
                                prefixIcon: IconButton(
                                  icon: Image.asset(
                                    "assets/height.png",
                                    height: 18,
                                  ),
                                  onPressed: () {},
                                ),
                                suffixIcon: heightTextEditingController
                                        .text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () =>
                                            heightTextEditingController.clear(),
                                      ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                                hintStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 15),
                                labelStyle: const TextStyle(
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
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: height * 0.01,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SelectSchedule()));
                          },
                          child: Text(
                            "Existing Patient?\nClick here ",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue
                          ),
                        )
                        ),

                        // Button
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.lightBlue.withOpacity(0.2),
                            ),
                            height: 70,
                            width: 70,
                            padding: EdgeInsets.all(10),
                            child: ElevatedButton(
                              onPressed: () {
                                saveNewUserInfo();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                //border radius equal to or more than 50% of width
                              )),
                              child: const Icon(Icons.arrow_forward_outlined),
                            ))
                      ],
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
