import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common_screens/choose_user.dart';
import '../../common_screens/choose_user2.dart';
import '../../global/global.dart';
import '../../main_screen.dart';
import '../../testing.dart';
import '../doctor_live_consultation/live_consultation_category.dart';

class DoctorAppointmentDashboard extends StatefulWidget {
  const DoctorAppointmentDashboard({Key? key}) : super(key: key);

  @override
  State<DoctorAppointmentDashboard> createState() => _DoctorAppointmentDashboardState();
}

class _DoctorAppointmentDashboardState extends State<DoctorAppointmentDashboard> {

  List<String> countryList = ["Bangladesh","India"];
  Future<bool> showExitPopup() async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you want to exit the App?'),
        actions:[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child:Text('No'),
          ),

          ElevatedButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            //return true when click on "Yes"
            child:Text('Yes'),
          ),

        ],
      ),
    )??false; //if showDialog had returned null, then return false
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedServiceDatabaseParentName = "doctorAppointment";
    selectedService = "Doctor Appointment";
    selectedDoctorInfo = null;
    //selectedCountry = countryList[1];
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: WillPopScope(
        onWillPop: showExitPopup,
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
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){return MainScreen();}));
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
                                    "Doctor Appointment",
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

                          Image.asset("assets/doctorAppointment/doctor.png",width: 80),

                          SizedBox(height: height * 0.02,),

                          Text(
                            "Do you want to get doctor appointment from Indian doctors?",
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
                                borderSide: const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ) ,
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
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),

                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please select a country";
                              }

                              else {
                                return null;
                              }
                            },

                          ),

                          SizedBox(height: height * 0.03,),

                          // New Consultation History
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const LiveConsultationCategory()));
                            },
                            child: Container(
                              padding: const EdgeInsets.only(left: 10),
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
                                    backgroundColor: const Color(0xffF5F5F5),
                                    radius: 30,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Image.asset(
                                        "assets/doctor (2).png",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 25,),

                                  Text(
                                    "New Appointment",
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
                              padding: const EdgeInsets.only(left: 10),
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
                                    backgroundColor: const Color(0xffF5F5F5),
                                    radius: 30,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Image.asset(
                                        "assets/clock.png",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 25,),

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
                            onTap: (){
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => const MRZTester()));
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
      ),
    );
  }
}
