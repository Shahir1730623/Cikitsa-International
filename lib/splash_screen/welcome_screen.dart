import 'package:app/authentication/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
              )
          ),

          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: const [
                    Text(
                      "Welcome To",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),

                    SizedBox(height: 5,),

                    Text(
                      "CIKITSA INTERNATIONAL",
                      style: TextStyle(
                        fontSize: 25,
                        color: Color(0xFF707070),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 150,),

                Image.asset(
                  "assets/Logo.png",
                  height: height * 0.15,
                ),

                const SizedBox(height: 100,),

                Column(
                  children:  [
                    const Text(
                      "Read our privacy policy",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 10,),

                    const Text(
                      "Tap Agree and Continue to accept our terms and services",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 30,),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()),);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.lightBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // <-- Radius
                        ),
                      ),

                      child: const Text(
                          "Agree and Continue",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          )
                      ),
                    ),
                  ],
                ),



               /* Container(
                  height: 44.0,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
                      )
                  ),

                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(primary: Colors.transparent, shadowColor: Colors.transparent),
                    child: const Text(
                      "Agree and Continue",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                      )
                    ),
                  ),
                )*/





              ],
            ),
          ),

        ),
      ),
    );
  }
}
