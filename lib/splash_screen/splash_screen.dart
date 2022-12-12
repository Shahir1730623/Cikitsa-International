import 'dart:async';

import 'package:app/authentication/initialization_screen.dart';
import 'package:app/authentication/login_screen.dart';
import 'package:app/doctor_screens/doctor_dashboard.dart';
import 'package:app/main_screen.dart';
import 'package:app/main_screen/user_dashboard.dart';
import 'package:app/splash_screen/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../assistants/assistant_methods.dart';
import '../global/global.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  startTimer() async{
    //Fetching the User Data
    firebaseAuth.currentUser != null ? AssistantMethods.readOnlineUserCurrentInfo() : null;

    Timer(const Duration(seconds: 5),() async {
      if(await firebaseAuth.currentUser!=null){
        // Send Patient to Patient Dashboard
        currentFirebaseUser = firebaseAuth.currentUser;
        if(loggedInUser == "Patient"){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainScreen()));
        }

        // Send Doctor to Doctor Dashboard
        else if(loggedInUser == "Doctor"){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DoctorDashboard()));
        }
      }
      else{
        // send User to login screen
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WelcomeScreen()));
      }

    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();

  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
          )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
               "assets/Logo.png",
                height: height * 0.15,
              ),

              const SizedBox(height: 10),

            ],
          ),
        ),
      ),
    );
  }
}
