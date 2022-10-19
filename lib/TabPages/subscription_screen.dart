import 'package:app/splash_screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../authentication/login_screen.dart';
import '../global/global.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController specializationTextEditingController = TextEditingController();
  TextEditingController experienceTextEditingController = TextEditingController();
  TextEditingController workplaceTextEditingController = TextEditingController();
  TextEditingController feeTextEditingController = TextEditingController();

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  void registerDoctor() async{

    String doctorId = idGenerator();

    Map doctorMap = {
      'id' : doctorId,
      'name' : nameTextEditingController.text.trim(),
      'specialization' : specializationTextEditingController.text.trim(),
      'degrees' : "MBBS, MPH, MS(Orthopedics),FCSPS(Orthopedics)",
      'experience' : experienceTextEditingController.text.trim(),
      'workplace' : workplaceTextEditingController.text.trim(),
      'rating' : "5",
      'totalVisits': "10",
      'fee' : feeTextEditingController.text.trim(),
      'status' : "Online",
    };

    DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('Doctors');
    databaseReference.child(doctorId).set(doctorMap);

    Fluttertoast.showToast(msg: "Account has been created");
    Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Register As a doctor",
                  style: GoogleFonts.montserrat(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),

                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(10)
                  ),

                  child:  Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: nameTextEditingController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your Name",
                          ),

                        ),
                      )
                  ),

                ),

                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(10)
                  ),

                  child:  Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: specializationTextEditingController,
                          keyboardType: TextInputType.phone,
                          decoration:const  InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your Specialization",
                          ),

                        ),
                      )
                  ),

                ),

                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(10)
                  ),

                  child: Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: experienceTextEditingController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your experience",
                          ),

                        ),
                      )
                  ),

                ),

                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(10)
                  ),

                  child: Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: workplaceTextEditingController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your workplace name",
                          ),

                        ),
                      )
                  ),

                ),

                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(10)
                  ),

                  child: Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: feeTextEditingController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your visiting fee",
                          ),

                        ),
                      )
                  ),

                ),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                      onPressed: ()  {
                        registerDoctor();
                      },

                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          )
                      ),

                      child: const Text(
                        "Register Now",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                ),







              ],
            ),
          ),
        ),
      ),
    );


}
}
