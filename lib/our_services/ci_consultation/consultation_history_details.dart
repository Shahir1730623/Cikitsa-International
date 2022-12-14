import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import '../../../global/global.dart';
import '../../../widgets/progress_dialog.dart';
import '../../main_screen.dart';
import '../../widgets/seperator.dart';

class ConsultationHistoryDetails extends StatefulWidget {
  const ConsultationHistoryDetails({Key? key}) : super(key: key);

  @override
  State<ConsultationHistoryDetails> createState() => _ConsultationHistoryDetailsState();
}

class _ConsultationHistoryDetailsState extends State<ConsultationHistoryDetails> {
  String imageUrl = "";
  bool flag = false;


  TextEditingController consultantNameTextEditingController = TextEditingController(text: "");
  TextEditingController consultantIdTextEditingController = TextEditingController(text: "");
  TextEditingController visitationReasonTextEditingController = TextEditingController(text: "");
  TextEditingController patientIdEditingController = TextEditingController(text: "");
  TextEditingController patientNameTextEditingController = TextEditingController(text: "");


  Future<void> checkPrescriptionStatus() async {
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('CIConsultationImages/'+ selectedCIConsultationInfo!.id! + "/consultantPrescription.png");
    try{
      imageUrl = await reference.getDownloadURL();
    }

    catch(e){
      print(e);
    }

    if(imageUrl.isNotEmpty){
      setState(() {
        flag = true;
      });

    }
    else{
      setState(() {
        flag = false;
      });
    }
  }

  Future downloadFile() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(message: "");
        }
    );

    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('CIConsultationImages/'+ selectedCIConsultationInfo!.id! + "/consultantPrescription.png");
    final url = await reference.getDownloadURL();

    // Not visible to user, only app can access this file
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/${reference.name}';
    await Dio().download(url, path); // Download file

    //await reference.writeToFile(path); // Save downloaded file locally

    try{
      await GallerySaver.saveImage(path,toDcim: true);
    }

    catch(e){
      print(e);
    }

    Navigator.pop(context);
    Fluttertoast.showToast(msg: "Photo Saved to gallery",toastLength: Toast.LENGTH_LONG);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      checkPrescriptionStatus();
    });


  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: height * 0.30,
              child: Image.asset(
                'assets/doctorImages/doctor-1.png',
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(height: height * 0.01),

            Text(
              selectedCIConsultationInfo!.consultantName!,
              style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),

            SizedBox(height: height * 0.01,),

            Text(
              "Consultant",
              style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600
              ),
            ),


            SizedBox(height: height * 0.005,),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Patient',
                    style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600
                    ),
                  ),

                  const SizedBox(height: 5,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          selectedPatientInfo!.firstName! + " " + selectedPatientInfo!.lastName! +  " (" + selectedPatientInfo!.gender! + ", " + selectedPatientInfo!.age! + " yrs, " + selectedPatientInfo!.weight! + " kg",
                          style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15,),

                  const MySeparator(color: Colors.grey,),

                  const SizedBox(height: 15,),

                  Text(
                    'Sickness',
                    style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600
                    ),
                  ),

                  const SizedBox(height: 5,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          selectedCIConsultationInfo!.visitationReason!,
                          style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15,),

                  const MySeparator(color: Colors.grey,),

                  const SizedBox(height: 15,),

                  Text(
                    'Problem (in details)',
                    style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600
                    ),
                  ),

                  const SizedBox(height: 5,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          selectedCIConsultationInfo!.problem!,
                          style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.05,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Consultation Information",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.02,),

                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Consultation ID",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0x59090808),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.010,),
                                    Text(
                                      "#${selectedCIConsultationInfo!.id!}",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),

                                Column(
                                  children: [
                                    Text(
                                      "Consultation Fee",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0x59090808),
                                      ),
                                    ),
                                    SizedBox(height: height * 0.010,),
                                    Text(
                                      "???500",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 15,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Date",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        color: const Color(0x59090808),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height * 0.010,),
                                    Text(
                                      selectedCIConsultationInfo!.date!,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),

                                Column(
                                  children: [
                                    Text(
                                      "Time",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                        color: const Color(0x59090808),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height * 0.010,),
                                    Text(
                                      selectedCIConsultationInfo!.time!,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 15,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Consultation Status",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Color(0x59090808),
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(height: height * 0.010,),
                                    Text(
                                      selectedCIConsultationInfo!.consultationStatus!,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),

                                Column(
                                  children: [
                                    Text(
                                      "Payment Status",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Color(0x59090808),
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    SizedBox(height: height * 0.010,),
                                    Text(
                                      selectedCIConsultationInfo!.payment!,
                                      style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )

                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10,),

            // Order Medicine Container
            GestureDetector(
              onTap: (){
                var snackBar = const SnackBar(content: Text("Pharmacy work on progress..."));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Container(
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
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton.icon(
                  onPressed: ()  async {
                    if(flag == true){
                      await downloadFile();
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainScreen()), (Route<dynamic> route) => false);
                    }

                    else{
                      var snackBar = const SnackBar(content: Text("Prescription still not uploaded..."));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },

                  style: ElevatedButton.styleFrom(
                      backgroundColor: (flag) ? Colors.blue : Colors.grey[300],
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
