import 'dart:async';

import 'package:app/common_screens/choose_user.dart';
import 'package:app/models/doctor_model.dart';
import 'package:app/our_services/doctor_live_consultation/live_doctors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common_screens/new_user_info_form.dart';
import '../../global/global.dart';
import '../../widgets/progress_dialog.dart';

class DoctorProfile extends StatefulWidget {
  const DoctorProfile({Key? key}) : super(key: key);

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {

  List doctorImages = ["doctor-1.png","doctor-2.jpg","doctor-3.jpg"];

  /*saveSelectedDoctorIdToDatabase(){
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("Users");
    reference
        .child(currentFirebaseUser!.uid)
        .child("selectedDoctorId").set(selectedDoctorInfo!.doctorId);
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white
                ),
                child: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top:19.0),
              child: Text(
                selectedDoctorInfo!.status.toString(),
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 10.0,left: 2),
              child: Icon(
                  Icons.circle,
                  color: ((selectedDoctorInfo!.status.toString() == "Online") ? CupertinoColors.systemGreen : Colors.grey.shade400)
            ))
          ],
        ),

        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
                    )
                ),

                child: Image.asset(
                  "assets/doctor-1.png"
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Doctor Profile",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),


              const Divider(
                height: 30,
                thickness: 0.5,
                color: Colors.black,
              ),


              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedDoctorInfo!.doctorName!,
                            style: GoogleFonts.montserrat(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15,),

                          Row(
                            children: [
                              Image.asset(
                                "assets/bone-1.png",
                                height: 30,
                                width: 30,
                              ),

                              const SizedBox(width: 20,),

                              Text(
                                selectedDoctorInfo!.specialization!,
                                style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff03849F)
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10,),

                          Text(
                            selectedDoctorInfo!.degrees!,
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                            ),
                          ),

                          SizedBox(height: 20,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/suitcase.png",
                                    height: 25,
                                  ),

                                  SizedBox(width: 10,),

                                  Text(
                                    selectedDoctorInfo!.experience!,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff03849F)
                                    ),
                                  ),

                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/group.png",
                                    height: 25,
                                  ),

                                  SizedBox(width: 10,),

                                  Text(
                                    selectedDoctorInfo!.totalVisits!,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff03849F)
                                    ),
                                  ),

                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/star.png",
                                    height: 25,
                                  ),

                                  SizedBox(width: 10,),

                                  Text(
                                    selectedDoctorInfo!.rating!,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff03849F)
                                    ),
                                  ),

                                ],
                              ),


                            ],
                          ),

                          SizedBox(height: 20,),

                          Text(
                            "Workplace: " + selectedDoctorInfo!.workplace!,
                            style: GoogleFonts.montserrat(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff03849F)
                            ),
                          ),

                          SizedBox(height: 10,),

                          Text(
                            "Information",
                            style: GoogleFonts.montserrat(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff03849F)
                            ),
                          ),

                          SizedBox(height: 10,),

                          const Text(
                            "Lorem ipsum dolor sit amet, incididunt ut labore et dolore exercitation ullamco laboris Lorem ipsum dolor sit amet incididunt ut labore et dolore exercitation ullamco laboris Lorem ipsum dolor sit amet, incididunt ut labore et dolore"
                          ),

                          SizedBox(height: height * 0.04),

                          // Button
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton.icon(
                              onPressed: ()  {
                                showDialog(
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseUser()));
                                });


                              },

                              style: ElevatedButton.styleFrom(
                                  primary: (((selectedDoctorInfo!.status.toString() == "Online") ? Colors.blue : Colors.grey.shade300 )),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),

                              icon: Icon(Icons.video_call),
                              label: Text(
                                (((selectedDoctorInfo!.status.toString() == "Online") ? "Talk to Doctor Now" : "Schedule Appointment" )),
                                style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: (((selectedDoctorInfo!.status.toString() == "Online") ? Colors.white : Colors.black ))
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Emergency? Click here",
                                style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),








            ],

          ),
        ),
      ),

    );
  }
}
