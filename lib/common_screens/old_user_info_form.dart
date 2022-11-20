import 'dart:async';
import 'dart:math';
import 'package:app/common_screens/choose_user.dart';
import 'package:app/common_screens/new_user_info_form.dart';
import 'package:app/common_screens/select_schedule_form.dart';
import 'package:app/common_screens/talk_to_doctor_now.dart';
import 'package:app/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../global/global.dart';


class OldUserForm extends StatefulWidget {
  const OldUserForm({Key? key}) : super(key: key);

  @override
  State<OldUserForm> createState() => _OldUserFormState();
}

class _OldUserFormState extends State<OldUserForm> {
  TextEditingController nameTextEditingController = TextEditingController(text: "");
  TextEditingController ageTextEditingController = TextEditingController(text: "");
  TextEditingController phoneTextEditingController = TextEditingController(text: "");
  TextEditingController weightTextEditingController = TextEditingController(text: "");
  TextEditingController heightTextEditingController = TextEditingController(text: "");
  TextEditingController relationTextEditingController = TextEditingController(text: "");
  TextEditingController genderTextEditingController = TextEditingController(text: "");

  List<String> reasonOfVisitTypesList = [
    "Cancer",
    "Heart Problem",
    "Skin problem",
    "Liver problem",
    "Broken bones"
  ];
  String? selectedReasonOfVisit;

  final _formKey = GlobalKey<FormState>();

  String idGenerator() {
    Random random =  Random();
    int randomNumber = random.nextInt(20000) + 10000;
    int randomNumber2 = random.nextInt(10000);
    return (randomNumber + randomNumber2).toString();
  }

  void retrievePatientDataFromDatabase() {
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("Users");
    reference
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId!)
        .once()
        .then((dataSnap){
      final DataSnapshot snapshot = dataSnap.snapshot;
      if (snapshot.exists) {
        nameTextEditingController.text = (snapshot.value as Map)["firstName"] + " " +  (snapshot.value as Map)["lastName"];
        ageTextEditingController.text = (snapshot.value as Map)["age"];
        phoneTextEditingController.text = (snapshot.value as Map)["phone"];
        genderTextEditingController.text = (snapshot.value as Map)["gender"];
        relationTextEditingController.text = (snapshot.value as Map)["relation"];
        weightTextEditingController.text = (snapshot.value as Map)["weight"];
        heightTextEditingController.text = (snapshot.value as Map)["height"];
      }

      else {
        Fluttertoast.showToast(msg: "No Patient record exist with this credentials");
      }
    });

  }


  @override
  void initState() {
    // TODO: implement initState
    retrievePatientDataFromDatabase();
    super.initState();
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
                    "Name",
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
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "Name",
                      prefixIcon: IconButton(
                        icon: Image.asset(
                          "assets/user.png",
                          height: 18,
                        ),
                        onPressed: () {},
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

                  ),

                  SizedBox(
                    height: height * 0.03,
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
                    readOnly: true,
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
                  ),

                  SizedBox(
                    height: height * 0.03,
                  ),

                  // Phone Number Field
                  Text(
                    "Phone Number",
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  TextFormField(
                    controller: phoneTextEditingController,
                    readOnly: true,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      hintText: "Phone Number",
                      prefixIcon: IconButton(
                        icon: Image.asset(
                          "assets/user.png",
                          height: 18,
                        ),
                        onPressed: () {},
                      ),
                      suffixIcon: phoneTextEditingController.text.isEmpty
                          ? Container(width: 0)
                          : IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () =>
                            phoneTextEditingController.clear(),
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

                  // Gender,Relation
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
                              readOnly: true,
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
                              "Relation",
                              style: GoogleFonts.montserrat(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: height * 0.01,
                            ),
                            TextFormField(
                              readOnly: true,
                              controller: relationTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Relation",
                                hintText: "Relation",
                                prefixIcon: IconButton(
                                  icon: Image.asset(
                                    "assets/relations.png",
                                    height: 18,
                                  ),
                                  onPressed: () {},
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
                    height: height * 0.03,
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
                              readOnly: true,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Weight (in kg)",
                                hintText: "Weight",
                                prefixIcon: IconButton(
                                  icon: Image.asset(
                                    "assets/weight.png",
                                    height: 18,
                                  ),
                                  onPressed: () {},
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
                              readOnly: true,
                              controller: heightTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "Height (in feet)",
                                hintText: "Height",
                                prefixIcon: IconButton(
                                  icon: Image.asset(
                                    "assets/height.png",
                                    height: 18,
                                  ),
                                  onPressed: () {},
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
                    height: height * 0.05,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewUserForm()));
                            },
                            child: Text(
                              "New Patient?\nClick here ",
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
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context){
                                      return ProgressDialog(message: "message");
                                    }
                                );

                                Timer(const Duration(seconds: 2),()  {
                                  Navigator.pop(context);
                                  if(selectedDoctorInfo == null){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectSchedule()));
                                  }

                                  else if(selectedDoctorInfo!.status == "Online"){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TalkToDoctorNowInformation()));
                                  }

                                  else{
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectSchedule()));
                                  }

                                });


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
