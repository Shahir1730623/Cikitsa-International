import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main_screen.dart';

class VisaConfirmationProgressDialog extends StatefulWidget {
  const VisaConfirmationProgressDialog({Key? key}) : super(key: key);

  @override
  State<VisaConfirmationProgressDialog> createState() => _VisaConfirmationProgressDialogState();
}

class _VisaConfirmationProgressDialogState extends State<VisaConfirmationProgressDialog> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 250),
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children: [
            SizedBox(height: height * 0.04,),

            Text(
              "Your information is\being uploaded",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),

            SizedBox(height: height * 0.025,),

            Text(
              'Note',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15
              ),
            ),

            SizedBox(height: height * 0.005,),

            Text(
              'You will receive notification once your\ninvitation is uploaded',
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12
              ),
            ),

            SizedBox(height: height * 0.03,),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: ()  {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (Route<dynamic> route) => false);
                },

                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),

                child: Text(
                  ("Return"),
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
      ),
    );
  }
}

