import 'dart:async';
import 'dart:math';

import 'package:app/global/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/progress_dialog.dart';

class HistoryScreenDetails extends StatefulWidget {
  const HistoryScreenDetails({Key? key}) : super(key: key);

  @override
  State<HistoryScreenDetails> createState() => _HistoryScreenDetailsState();
}

class _HistoryScreenDetailsState extends State<HistoryScreenDetails> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Text(
          "History details",
          style: GoogleFonts.montserrat(
              fontSize: 20,
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

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
                  )
              ),
              child: Image.network(
                selectedConsultationInfo!.doctorImageUrl!,
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(height: height * 0.02),

            Text(
              selectedConsultationInfo!.doctorName!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),

            SizedBox(height: height * 0.025,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                Text(
                  "Consultation Information",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(
                  height: 30,
                  thickness: 0.5,
                  color: Colors.black,
                ),

              ],
            ),

            const Divider(
              height: 10,
              thickness: 1,
              color: Colors.blue,
            ),

            SizedBox(height: height * 0.010,),

            // Consultation Fee
            Text(
              "Consultation ID",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),

            SizedBox(height: height * 0.010,),

            Text(
              "#" + selectedConsultationInfo!.consultationId!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),

            SizedBox(height: height * 0.020,),

            // Consultation Fee
            Text(
              "Consultation Fee",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                color: Color(0x59090808),
              ),
            ),

            SizedBox(height: height * 0.010,),

            Text(
              "৳" + selectedConsultationInfo!.doctorFee!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),

            SizedBox(height: height * 0.020,),

            // Date
            Text(
              "Date",
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: const Color(0x59090808)
              ),
            ),

            SizedBox(height: height * 0.010,),

            Text(
              selectedConsultationInfo!.date!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),

            SizedBox(height: height * 0.020,),

            // Time
            Text(
              "Time",
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: const Color(0x59090808)
              ),
            ),

            SizedBox(height: height * 0.010,),

            Text(
              selectedConsultationInfo!.time!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),

            SizedBox(height: height * 0.020,),

            // Visitation Reason
            Text(
              "Visitation Reason",
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: const Color(0x59090808)
              ),
            ),

            SizedBox(height: height * 0.010,),

            Text(
              selectedConsultationInfo!.visitationReason!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),

            SizedBox(height: height * 0.020,),

            // ConsultationStatus Reason
            Text(
              "Consultation Status",
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: const Color(0x59090808)
              ),
            ),

            SizedBox(height: height * 0.010,),

            Text(
              selectedConsultationInfo!.consultationType!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),

            const Divider(
              height: 30,
              thickness: 1,
              color: Colors.blue,
            ),

            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue),
                ),

              child: Column(
                children: [
                  Text(
                    "Order Medicine Now",
                    style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                  SizedBox(height: height * 0.005,),

                  Text(
                    "Order the prescribed medicines",
                    style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),

                  SizedBox(height: height * 0.02,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/prescription.png",
                        height: 50,
                        width: 50,
                      ),


                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.blue),
                            ),

                            child: Text(
                              "Free Delivery",
                              style:GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.blue),
                            ),

                            child: Text(
                              "Discount upto 20%",
                              style:GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 3,),

                      Transform.rotate(
                        angle: 180 * pi / 180,
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.blue,
                          size: 22,
                        ),
                      ),

                    ],
                  ),

                ],
              ),
              ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: ()  {
                    /*showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context){
                          return ProgressDialog(message: "Please wait...");
                        }
                    );

                    // Saving selected doctor id
                    //saveSelectedDoctorIdToDatabase();

                    Timer(const Duration(seconds: 2),()  {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => D));
                    });*/


                  },

                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  icon: const Icon(Icons.contact_page),
                  label: Text(
                    "Download Prescription",
                    style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
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
