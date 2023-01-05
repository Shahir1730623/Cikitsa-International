import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common_screens/choose_user.dart';
import '../../global/global.dart';
import '../../widgets/progress_dialog.dart';

class VisaDoctorDetails extends StatefulWidget {
  const VisaDoctorDetails({Key? key}) : super(key: key);

  @override
  State<VisaDoctorDetails> createState() => _VisaDoctorDetailsState();
}

class _VisaDoctorDetailsState extends State<VisaDoctorDetails> {
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
        ),

        backgroundColor: Colors.white,
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
                  selectedDoctorInfo!.doctorImageUrl!,
                  fit: BoxFit.cover,
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
                            "Dr. " + selectedDoctorInfo!.doctorFirstName! + " " + selectedDoctorInfo!.doctorLastName!,
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

                          SizedBox(height: height * 0.1),

                          // Button
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: ()  {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context){
                                      return ProgressDialog(message: "Please wait...");
                                    }
                                );

                                Timer(const Duration(seconds: 1),()  {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChooseUser()));
                                });
                              },

                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              child: Text(
                                "Select Doctor",
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
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
