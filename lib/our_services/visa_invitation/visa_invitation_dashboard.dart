import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common_screens/choose_user.dart';
import '../../common_screens/choose_user2.dart';
import '../../global/global.dart';
import '../../main_screen.dart';

class VisaInvitationDashboard extends StatefulWidget {
  const VisaInvitationDashboard({Key? key}) : super(key: key);

  @override
  State<VisaInvitationDashboard> createState() => _VisaInvitationDashboardState();
}

class _VisaInvitationDashboardState extends State<VisaInvitationDashboard> {
  List<String> countryList = ["Bangladesh","India"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedServiceDatabaseParentName = "visaConsultations";
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
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
                                  "Visa Invitation",
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

                        SizedBox(height: height * 0.02,),

                        Image.asset("assets/visaInvitationImages/passport.png",width: 80),

                        SizedBox(height: height * 0.02,),

                        Text(
                          "Do you want to get visa appointment?",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                          ),
                        ),

                        SizedBox(height: height * 0.03,),

                        Row(
                          children: [
                            Text(
                              "Select Country",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: height * 0.01,),

                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ) ,
                          isDense: true,
                          isExpanded: true,
                          iconSize: 30,
                          dropdownColor: Colors.white,
                          hint: const Text(
                            "Select country",
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                            ),
                          ),
                          value: selectedCountry,

                          onChanged: (newValue) {
                            setState(() {
                              selectedCountry = newValue.toString();
                            });
                          },

                          items: countryList.map((country) {
                            return DropdownMenuItem(
                              value: country,
                              child: Text(
                                country,
                                style: const TextStyle(color: Colors.black,height: 0.0),
                              ),
                            );
                          }).toList(),
                        ),

                        SizedBox(height: height * 0.03,),

                        // New Consultation History
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChooseUser()));
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
                                      "assets/consultationImages/consultation.png",
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
      ),
    );
  }
}
