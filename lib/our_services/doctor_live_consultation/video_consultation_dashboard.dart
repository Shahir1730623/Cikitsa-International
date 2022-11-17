import 'package:app/common_screens/choose_user2.dart';
import 'package:app/main_screen.dart';
import 'package:app/main_screen/user_dashboard.dart';
import 'package:app/our_services/doctor_live_consultation/history_screen.dart';
import 'package:app/our_services/doctor_live_consultation/live_consultation_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../global/global.dart';

class VideoConsultationDashboard extends StatefulWidget {
  const VideoConsultationDashboard({Key? key}) : super(key: key);

  @override
  State<VideoConsultationDashboard> createState() => _VideoConsultationDashboardState();
}

class _VideoConsultationDashboardState extends State<VideoConsultationDashboard> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedServiceDatabaseParentName = "consultations";
    selectedService = "Doctor Live Consultation";
    Fluttertoast.showToast(msg: selectedService + " " + selectedServiceDatabaseParentName!);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
            )
        ),

        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),

                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                                return MainScreen();
                              }));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
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

                          SizedBox(width: height * 0.040),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Video Consultation",
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      SizedBox(height: height * 0.05,),

                      Image.asset("assets/video-call.png"),

                      SizedBox(height: height * 0.02,),

                      Text(
                        "Do you want to talk to\na doctor live?",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                      ),

                      SizedBox(height: height * 0.05,),

                      // New Consultation History
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LiveConsultationCategory()));
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          height: height * 0.1,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey,),
                            color: Colors.white,
                          ),

                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0xffF5F5F5),
                                radius: 30,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    "assets/doctor (1).png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),

                              SizedBox(width: 25,),

                              Text(
                                "New Consultation",
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17
                                ),
                              ),

                            ],
                          ),


                        ),
                      ),

                      SizedBox(height: height * 0.02,),

                      // Consultation History
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChooseUser2()));
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          height: height * 0.1,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey,),
                            color: Colors.white,
                          ),

                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0xffF5F5F5),
                                radius: 30,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    "assets/clock.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),

                              SizedBox(width: 25,),

                              Text(
                                "Consultation History",
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17
                                ),
                              ),

                            ],
                          ),


                        ),
                      ),

                      SizedBox(height: height * 0.02,),

                      // Last Consultation
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          height: height * 0.1,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey,),
                            color: Colors.white,
                          ),

                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0xffF5F5F5),
                                radius: 30,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                    "assets/history.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),

                              SizedBox(width: 25,),

                              Text(
                                "Last Consultation",
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17
                                ),
                              ),

                            ],
                          ),


                        ),
                      ),

                      SizedBox(height: height * 0.02,),

                      // How to book Consultation
                      GestureDetector(
                        onTap: (){},
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          height: height * 0.1,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey,),
                            color: Colors.white,
                          ),

                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Color(0xffF5F5F5),
                                radius: 30,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Image.asset(
                                    "assets/television.png",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Text(
                                  "How to book consultation",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17
                                  ),
                                ),
                              ),

                              SizedBox(width: 20,),
                            ],
                          ),


                        ),
                      ),

                      SizedBox(height: height * 0.1,),
                    ],
                  ),
                ),

              ),
            )
          ],
        ),

      ),
    );
  }
}
