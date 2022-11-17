import 'dart:async';
import 'package:app/home/home_screen.dart';
import 'package:app/main_screen/user_dashboard.dart';
import 'package:app/splash_screen/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Initialization extends StatefulWidget {
  const Initialization({Key? key}) : super(key: key);

  @override
  State<Initialization> createState() => _InitializationState();
}

class _InitializationState extends State<Initialization> {

  startTimer(){
    Timer(const Duration(seconds: 5),() async {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SplashScreen()));
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

          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Initialization",
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 35
                        ),
                      ),

                    ],
                  ),

                  SizedBox(height: 5,),

                  Text(
                    "Please wait a moment",
                    style: GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontSize: 15
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 100,),

              const CircleAvatar(
                radius: 100.0,
                backgroundImage:
                AssetImage("assets/background_color.png"),
                backgroundColor: Colors.transparent,
              ),

              const SizedBox(height: 100,),

              const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  backgroundColor: Colors.grey,
                ),
              )

            ]

          ),
        ),
      ),
    );
  }
}
