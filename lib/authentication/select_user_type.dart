import 'dart:async';

import 'package:app/authentication/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';
import '../widgets/progress_dialog.dart';

class SelectUserType extends StatefulWidget {
  const SelectUserType({Key? key}) : super(key: key);

  @override
  State<SelectUserType> createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends State<SelectUserType> {
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
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/Logo.png",
                      width: 250,
                    ),

                  ],
                ),

                Image.asset(
                  "assets/authenticationImages/healthcare.png",
                  width: 80,
                  opacity: const AlwaysStoppedAnimation(.5),
                ),

               Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: const [
                       Text(
                         "Select an option",
                         style: TextStyle(
                             fontWeight: FontWeight.bold,
                             color: Colors.black,
                             fontSize: 20
                         ),
                       ),
                     ],
                   ),

                   const SizedBox(height: 20,),

                   SizedBox(
                     height: 45,
                     width: double.infinity,
                     child: ElevatedButton(
                       onPressed: ()  {
                         showDialog(
                             context: context,
                             barrierDismissible: false,
                             builder: (BuildContext context){
                               return ProgressDialog(message: "");
                             }
                         );

                         Timer(const Duration(seconds: 1),()  {
                           Navigator.pop(context);
                           userType = "Users";
                           Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));

                         });
                       },
                       style: ElevatedButton.styleFrom(
                           primary: (Colors.lightBlue),
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(20))),

                       child: Text(
                         "Login as a patient",
                         style: GoogleFonts.montserrat(
                             fontSize: 15,
                             fontWeight: FontWeight.bold,
                             color: Colors.white
                         ),
                       ),
                     ),
                   ),

                   const SizedBox(height: 20,),

                   const Text(
                     'Or',
                     style: TextStyle(
                         fontSize: 20,
                         fontWeight: FontWeight.bold,
                         color: Colors.black
                     ),
                   ),

                   const SizedBox(height: 20,),

                   SizedBox(
                     height: 45,
                     width: double.infinity,
                     child: ElevatedButton(
                       onPressed: ()  {
                         showDialog(
                             context: context,
                             barrierDismissible: false,
                             builder: (BuildContext context){
                               return ProgressDialog(message: "");
                             }
                         );

                         Timer(const Duration(seconds: 1),()  {
                           Navigator.pop(context);
                           userType = "Doctors";
                           Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));

                         });
                       },
                       style: ElevatedButton.styleFrom(
                           primary: (Colors.lightBlue),
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(20))),

                       child: Text(
                         "Login as a doctor",
                         style: GoogleFonts.montserrat(
                             fontSize: 15,
                             fontWeight: FontWeight.bold,
                             color: Colors.white
                         ),
                       ),
                     ),
                   ),

                 ],
               ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/authenticationImages/stethoscope-2.png",
                          width: 170,
                          opacity: const AlwaysStoppedAnimation(.5),
                        )
                      ],
                    )
                  ],
                )




              ],
            ),
          ),
        ),
      ),
    );
  }
}
