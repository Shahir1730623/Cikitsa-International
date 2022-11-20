import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../global/global.dart';

class ConsultationHistory extends StatefulWidget {
  const ConsultationHistory({Key? key}) : super(key: key);

  @override
  State<ConsultationHistory> createState() => _ConsultationHistoryState();
}

class _ConsultationHistoryState extends State<ConsultationHistory> {
  String consultationStatus = "Scheduled";
  int toggleIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Previous History',
            style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
        )),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
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
        color: Colors.white,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  const Text(
                    'Upcoming Appointment',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(height: 20,),

                  DottedBorder(
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(20),
                    color: Colors.blue,
                    dashPattern: [10,10],
                    strokeWidth: 3,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Maman Somberan',
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                            ),
                          ),

                          const SizedBox(height: 15,),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Consultant',
                                    style: TextStyle(
                                        color: Colors.grey
                                    ),
                                  ),

                                  const SizedBox(height: 15,),

                                  Text(
                                      'February, 16 2022 at 01:00 PM'
                                  ),

                                  const SizedBox(height: 15,),

                                  Container(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.phone),
                                      label: const Text(
                                        'Contact me',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),

                                    ),
                                  ),
                                ],
                              ),

                              //Image.asset('assets/doctor1.jpg',width: 100,),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20,),

                  const Divider(thickness: 2,height: 1,color: Colors.grey,),

                  const SizedBox(height: 20,),

                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2,color: Colors.blue),
                        borderRadius: BorderRadius.circular(30)
                    ),

                    child: ToggleSwitch(
                      minWidth: 150,
                      cornerRadius: 20.0,
                      activeBgColors: [[Colors.white], [Colors.white]],
                      activeFgColor: Colors.black,
                      inactiveBgColor: Colors.blueAccent,
                      inactiveFgColor: Colors.white,
                      initialLabelIndex: toggleIndex,
                      totalSwitches: 2,
                      labels: ['Upcoming', 'Past'],
                      radiusStyle: true,
                      onToggle: (index) {
                        if(index == 1){
                          setState(() {
                            toggleIndex = 1;
                            consultationStatus = "Completed";
                          });

                        }
                        else{
                          setState(() {
                            toggleIndex = 0;
                            consultationStatus = "Scheduled";
                          });
                        }


                      },
                    ),
                  ),

                  const SizedBox(height: 20,),

                  FirebaseAnimatedList(
                      query: FirebaseDatabase.instance.ref().child("Users")
                          .child(currentFirebaseUser!.uid)
                          .child("patientList")
                          .child(patientId!)
                          .child("CIConsultations"),

                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context,DataSnapshot snapshot, Animation<double> animation,int index){
                        final consultationType = (snapshot.value as Map)["consultationType"].toString();
                        if(consultationStatus == consultationType){
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          const VerticalDivider(color: Colors.blueAccent, thickness: 3,),

                                          const SizedBox(width: 10,),

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Text('Appointment Date',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),

                                                      const SizedBox(height: 10,),

                                                      Row(
                                                        children:  [
                                                          Icon(Icons.access_time,size: 25,),

                                                          SizedBox(width: 10,),

                                                          Text((snapshot.value as Map)["date"].toString(),style: const TextStyle(color: Colors.grey,fontSize: 15),),

                                                          Text(' - '),

                                                          Text((snapshot.value as Map)["time"].toString(),style: const TextStyle(color: Colors.grey,fontSize: 15),),

                                                        ],
                                                      ),
                                                    ],
                                                  ),

                                                  SizedBox(width: MediaQuery.of(context).size.width-310,),

                                                ],
                                              ),

                                              const SizedBox(height: 10,),

                                              // Divider
                                              Container(color: Colors.grey, height: 1, width: MediaQuery.of(context).size.width-80,),

                                              const SizedBox(height: 15,),

                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 30,
                                                    backgroundColor: Colors.grey[200],
                                                    foregroundImage: AssetImage("assets/doctor_new.png"),
                                                  ),

                                                  const SizedBox(width: 10,),

                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        (snapshot.value as Map)["consultantName"].toString(),
                                                        style: GoogleFonts.montserrat(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black),
                                                      ),

                                                      const SizedBox(height: 10,),

                                                      Text(
                                                        'Consultant',
                                                        style: GoogleFonts.montserrat(
                                                            color: Colors.grey,
                                                            fontSize: 15
                                                        ),
                                                      ),

                                                      const SizedBox(height: 10,),

                                                      Text(
                                                        "Status: " + (snapshot.value as Map)["consultationType"].toString(),
                                                        style: GoogleFonts.montserrat(
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                      ),

                                                    ],
                                                  )

                                                ],
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              const SizedBox(height: 20,),
                            ],
                          );
                        }

                        else{
                          return Container();
                        }
                      }
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
