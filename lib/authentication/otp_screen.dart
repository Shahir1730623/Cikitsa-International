import 'package:app/authentication/create_profile_screen.dart';
import 'package:app/authentication/login_screen.dart';
import 'package:app/main_screen.dart';
import 'package:app/main_screen/user_dashboard.dart';
import 'package:app/splash_screen/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';
import '../home/home_screen.dart';
import '../widgets/progress_dialog.dart';


class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var code = "";

  loginUser() async {
   showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "Validating User...");
        }
    );

    try{
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verifyId, smsCode: code);
      final User? firebaseUser = (
          // Sign the user in (or link) with the credential
          await firebaseAuth.signInWithCredential(credential
          ).catchError((message){
            Navigator.pop(context);
            Fluttertoast.showToast(msg: "Error" + message);
          })
      ).user;

      if(firebaseUser != null){
        DatabaseReference reference = FirebaseDatabase.instance.ref().child("Users");
        reference.child(firebaseAuth.currentUser!.uid).once().then((userKey) {
          final snapshot = userKey.snapshot;
          if (snapshot.exists) {
            currentFirebaseUser = firebaseUser;
            Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
          }

          else{
            Map userMap = {
              'id' : firebaseUser.uid,
              'phone' : userPhoneNumber
            };

            DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child("Users");
            databaseReference.child(firebaseUser.uid).set(userMap);
            currentFirebaseUser = firebaseUser;
            Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateProfile()));
          }

      });

      }
    }

    catch(e){
      Fluttertoast.showToast(msg: "Wrong Credentials! Try Again");
    }

  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            ),
          )
        ),
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
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 100 ,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      children: [
                        // All Texts
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "OTP",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 70,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(
                                  "Code",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 70,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),

                                const SizedBox(
                                  height:10,
                                ),

                                const Text(
                                  "Verification",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),



                                const SizedBox(height: 50,),

                                const Text(
                                  "Enter one time password sent to",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey,
                                  ),
                                ),

                                Text(
                                  userPhoneNumber!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),


                              ],
                            )
                          ],
                        ),

                        const SizedBox(
                          height: 30 ,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: OtpTextField(
                                numberOfFields: 6,
                                fillColor: Colors.black.withOpacity(0.1),
                                filled: true,
                                borderColor: Colors.blue,
                                focusedBorderColor: Colors.blue ,
                                onCodeChanged: (value){
                                  code += value;
                                },
                              ),
                            ),

                          ],
                        ),


                        const SizedBox(height: 70,),

                        // Button
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                              onPressed: ()  {
                                loginUser();
                              },

                              style: ElevatedButton.styleFrom(
                                  primary: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  )
                              ),


                              child: const Text(
                                "Verify code",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                          ),
                        ),

                        TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
                            },

                            child: const Text(
                              "Edit Phone Number?",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ))

                      ],
                    ),
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
