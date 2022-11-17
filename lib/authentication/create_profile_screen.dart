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
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameTextEditingController.addListener(() => setState(() {}));
    emailTextEditingController.addListener(() => setState(() {}));
  }

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
        reference.child(currentFirebaseUser!.uid).child("name").set(nameTextEditingController.text);
        reference.child(currentFirebaseUser!.uid).child("email").set(emailTextEditingController.text);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Initialization()));
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

                  SizedBox(height: 30,),

                  Image.asset(
                    "assets/id-card.png",
                    height: height * 0.15,
                  ),

                  const SizedBox(height: 30,),

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

                  // Full name Container
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
                        Icon(Icons.person,size: 30,),

                        const SizedBox(
                          width: 5,
                        ),

                        // Border
                        const Text(
                          "|",
                          style: TextStyle(fontSize: 40, color: Colors.black),
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
                              suffixIcon: nameTextEditingController.text.isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () =>
                                    nameTextEditingController.clear(),
                              ),

                              hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                              labelStyle:
                              const TextStyle(color: Colors.black, fontSize: 16),
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
                        Icon(Icons.email,size: 30,),

                        const SizedBox(
                          width: 5,
                        ),

                        // Border
                        const Text(
                          "|",
                          style: TextStyle(fontSize: 40, color: Colors.black),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        // Full Name TextField
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
                              suffixIcon: emailTextEditingController.text.isEmpty
                                  ? Container(width: 0)
                                  : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () =>
                                    emailTextEditingController.clear(),
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
                        )

                      ],
                    ),


                  ),

                  SizedBox(height: height * 0.25),

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
