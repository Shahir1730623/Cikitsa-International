import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppointmentSummaryScreen extends StatefulWidget {
  const AppointmentSummaryScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentSummaryScreen> createState() => _AppointmentSummaryScreenState();
}

class _AppointmentSummaryScreenState extends State<AppointmentSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Text(
          "Appointment Summary",
          style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
        ),

        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.blue
              ),
              child: const Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Booking Info",
              style: GoogleFonts.montserrat(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),

            SizedBox(height: 20,),

            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.calendar_month),
                      ),

                      Column(
                        children: [

                        ],
                      )
                    ],
                  ),

                ],
              ),
            ),




          ],
        ),
      ),
    );
  }
}
