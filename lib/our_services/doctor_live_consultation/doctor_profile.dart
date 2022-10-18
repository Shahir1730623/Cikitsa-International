import 'package:app/common_screens/choose_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorProfile extends StatefulWidget {
  const DoctorProfile({Key? key}) : super(key: key);

  @override
  State<DoctorProfile> createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/doctor-1.png",
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
                            "Dr. Ventakesh Rajkumar",
                            style: GoogleFonts.montserrat(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 20,),

                          Row(
                            children: [
                              Image.asset(
                                "assets/bone-1.png",
                                height: 30,
                                width: 30,
                              ),

                              SizedBox(width: 20,),

                              Text(
                                "Orthopedics",
                                style: GoogleFonts.montserrat(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff03849F)
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 20,),

                          Text(
                            "MBBS, MPH, MS(Orthopedics),FCSPS(Orthopedics)",
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
                                    "assets/star.png",
                                    height: 25,
                                  ),

                                  SizedBox(width: 10,),

                                  Text(
                                    "10 years",
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
                                    "10 years",
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
                                    "10 years",
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

                          SizedBox(height: 40,),

                          Text(
                            "Workplace: Evercare Hospital",
                            style: GoogleFonts.montserrat(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff03849F)
                            ),
                          ),

                          SizedBox(height: 20,),

                          Text(
                            "Information",
                            style: GoogleFonts.montserrat(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff03849F)
                            ),
                          ),

                          SizedBox(height: 10,),

                          Text(
                            "Lorem ipsum dolor sit amet, incididunt ut labore et dolore exercitation ullamco laboris Lorem ipsum dolor sit amet incididunt ut labore et dolore exercitation ullamco laboris Lorem ipsum dolor sit amet, incididunt ut labore et dolore"
                          ),

                          SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseUser()));
                              },

                              style: ElevatedButton.styleFrom(
                                  primary: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),

                              icon: Icon(Icons.video_call),
                              label: Text(
                                "Talk to Doctor Now",
                                style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
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
