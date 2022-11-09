import 'dart:async';

import 'package:app/main_screen.dart';
import 'package:app/our_services/doctor_live_consultation/booking_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';
import '../widgets/progress_dialog.dart';
import 'coundown_screen.dart';

class ConfirmationPageScreen extends StatefulWidget {
  const ConfirmationPageScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmationPageScreen> createState() => _ConfirmationPageScreenState();
}

class _ConfirmationPageScreenState extends State<ConfirmationPageScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3),(){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return ProgressDialog(message: "");
          }
      );

      Timer(const Duration(seconds: 3),()  {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetailsScreen()));

      });



    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/checked.png",
                  width: 150,
                ),

                const SizedBox(height: 30),

                Text(
                  "Payment Confirmed",
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
                ),

              ],
            )
        ),
      ),
    );
  }
}
