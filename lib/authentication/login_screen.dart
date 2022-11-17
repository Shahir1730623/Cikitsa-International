import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';
import '../widgets/progress_dialog.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String verificationId = "";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController phoneTextEditingController = TextEditingController();

  List<String> countryTypeList = ["Bangladesh", "India"];
  String? selectedCountry;
  String selectedCode = "+88";
  String? phoneNumber;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    phoneTextEditingController.addListener(() => setState(() {}) );
  }

  void sendOtp() async{
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: selectedCode + phoneNumber!,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print("Message:$e");
      },
      codeSent: (String verificationId, int? resendToken) {
        verifyId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );


  }




  void checkCountry(){
    if(selectedCountry == "Bangladesh"){
      setState(() {
        selectedCode = "+88";
      });

    }

    else if (selectedCountry == "India"){
      setState(() {
        selectedCode = "+91";
      });
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
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/Logo.png",
                    height: height * 0.10,
                  ),

                  const SizedBox(
                    height: 20 ,
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
                                  "Let us Take",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 40,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),


                                Text(
                                  "Care",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                      fontSize: 40,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),

                                SizedBox(
                                  height: 30,
                                ),

                                const Text(
                                  "Enter your Phone number",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),

                                const SizedBox(height: 50,),

                                const Text(
                                  "CI will need to verify your",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),

                                const Text(
                                  "Phone Number",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
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

                        // SelectCountry
                        DropdownButton(
                          iconSize: 26,
                          dropdownColor: Colors.white,
                          hint: const Text(
                            "Please select your country",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                          ),
                          value: selectedCountry,
                          onChanged: (newValue)
                          {
                            setState(() {
                              selectedCountry = newValue.toString();
                              (selectedCountry == "Bangladesh") ? selectedCode = "+88" : selectedCode = "+91";
                            });
                          },

                          items: countryTypeList.map((country){
                            return DropdownMenuItem(
                              value: country,
                              child: Text(
                                country,
                                style: const TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(
                          height: 20 ,
                        ),

                        // Phone Container
                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1.5, color: Colors.grey.shade500),
                            borderRadius: BorderRadius.circular(10)
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),

                              // Country Code
                              SizedBox(
                                width: 40,
                                child: Text(
                                  selectedCode,
                                  style: TextStyle(
                                    fontSize: 16
                                  ),
                                ),
                              ),

                              // Border
                              const Text(
                                "|",
                                style: TextStyle(fontSize: 33, color: Colors.black),
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              // Phone TextField
                              Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Phone",
                                    ),

                                    onChanged:(value) {
                                      phoneNumber = value;

                                    },
                                  )
                              )
                            ],
                          ),

                        ),

                        const SizedBox(height: 20,),

                        const Text(
                          "Carrier charges may apply",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 60,),

                        // Button
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context){
                                      return ProgressDialog(message: "Validating phone number...");
                                    }
                                );

                                sendOtp();

                                Timer(const Duration(seconds: 2),()  {
                                  Navigator.pop(context);
                                  userPhoneNumber = selectedCode + phoneNumber!;
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const OTPScreen()));
                                });
                              },

                              style: ElevatedButton.styleFrom(
                                  primary: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)
                                  )
                              ),


                              child: const Text(
                                "Send code",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                          ),
                        )
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
