import 'dart:async';

import 'package:app/splash_screen/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {
  startTimer(){
    //Fetching the User Data
    //firebaseAuth.currentUser != null ? AssistantMethods.readOnlineUserCurrentInfo() : null;

    Timer(const Duration(seconds: 5),() async {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => WelcomeScreen()));
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
