import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:app/global/global.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';

import '../../main_screen.dart';
import '../../navigation_service.dart';
import '../../widgets/progress_dialog.dart';

class HistoryScreenDetails extends StatefulWidget {
  const HistoryScreenDetails({Key? key}) : super(key: key);

  @override
  State<HistoryScreenDetails> createState() => _HistoryScreenDetailsState();
}

class _HistoryScreenDetailsState extends State<HistoryScreenDetails> {
  String imageUrl = "";
  bool flag = false;


  Future<void> checkPrescriptionStatus() async {
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('consultationImages/'+ selectedConsultationInfo!.consultationId! + "/doctorPrescription.png" );
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

    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('consultationImages/'+ selectedConsultationInfo!.consultationId! + "/doctorPrescription.png" );
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

    Navigator.pop(NavigationService.navigatorKey.currentContext!);
    Fluttertoast.showToast(msg: "Photo Saved to gallery");

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPrescriptionStatus();
  }

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
              height: height * 0.25,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
                  )
              ),
              child: Image.network(
                selectedConsultationInfo!.doctorImageUrl!,
                fit: BoxFit.cover,
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

            SizedBox(height: height * 0.02,),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Consultation Information",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.02,),

                  DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(10),
                    color: Colors.blue,
                    dashPattern: [10,5],
                    strokeWidth: 1,
                    child: Container(
                      padding: const EdgeInsets.only(left: 58,right: 58,top: 15,bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
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

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.005,),


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
