import 'package:app/authentication/initialization_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';
import '../home/home_screen.dart';
import '../widgets/progress_dialog.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  saveNameToDatabase(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "Saving Information...");
        }
    );

    DatabaseReference reference = FirebaseDatabase.instance.ref().child("Users");
    reference.child(currentFirebaseUser!.uid).once().then((userKey) {
      final snapshot = userKey.snapshot;
      if (snapshot.exists) {
        reference.child(currentFirebaseUser!.uid).child("name").set(userName);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Initialization()));
      }

      });


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
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Profile Info",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          fontSize: 35,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 50,),

                  Image.asset(
                    "assets/id-card.png",
                    height: height * 0.15,
                  ),

                  const SizedBox(height: 20,),

                  const Text(
                    "Provide your Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  SizedBox(height: 10,),

                  const Text(
                    "Please input your full name in the given field",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 50,),

                  // Name Field
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.5, color: Colors.black),
                        borderRadius: BorderRadius.circular(10)
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),

                        // Phone TextField
                        Expanded(
                            child: TextField(
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Name",
                              ),

                              onChanged:(value) {
                                userName = value;
                              },
                            )
                        )
                      ],
                    ),

                  ),

                  const SizedBox(height: 250),

                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                        onPressed: ()  {
                          saveNameToDatabase();
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
              ),
            ),
          ),

        ),
      ),
    );
  }
}
