import 'dart:async';

import 'package:app/main_screen/user_profile_screen.dart';
import 'package:app/models/user_model.dart';
import 'package:app/our_services/ci_consultation/ci_consultation_dashboard.dart';
import 'package:app/our_services/doctor_live_consultation/video_consultation_dashboard.dart';
import 'package:app/our_services/online_pharmacy/pharmacy_dashboard.dart';
import 'package:app/our_services/visa_invitation/visa_invitation_dashboard.dart';
import 'package:app/push_notification/push_notification_system.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../global/global.dart';
import '../models/consultation_payload_model.dart';
import '../models/push_notification_screen.dart';
import '../service_file/local_notification_service.dart';
import '../widgets/progress_dialog.dart';
import '../widgets/push_notification_dialog_select_schedule.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  late final LocalNotificationService service;
  String? formattedDate;
  String? formattedTime;
  Timer? timer;

  List firstListImages = ["covid-19","diarrhea","dengue"];
  List firstListNames = ["Covid-19 Treatment","Diarrhea Treatment","Dengue/Malaria Treatment"];
  List secondListImages = ["sugar-blood-level","bone-1","brainstorm"];
  List secondListNames = ["Diabetes Specialist","Orthopedics","Psychiatrist"];


  void loadScreen(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return PushNotificationDialogSelectSchedule();
        }
    );
  }

  Future<void> generateLocalNotification() async {
    timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
      if(localNotify == true){
        // Converting time and date to yyyy-MM-dd 24 hour format for sending the time as param to showScheduledNotification()
        var df = DateFormat.jm().parse(selectedConsultationInfo!.time!);
        DateTime date = DateFormat("dd-MM-yyyy").parse(selectedConsultationInfo!.date!);
        formattedDate = DateFormat('yyyy-MM-dd').format(date);
        formattedTime = DateFormat('HH:mm').format(df);
        dateTime =  formattedDate! + " " + formattedTime!;
        Fluttertoast.showToast(msg: dateTime!);

        ConsultationPayloadModel consultationPayloadModel = ConsultationPayloadModel(currentUserId: currentFirebaseUser!.uid, patientId: patientId!, selectedServiceName: "Doctor Live Consultation", consultationId: consultationId!);
        String payloadJsonString = consultationPayloadModel.toJsonString();
        await service.showScheduledNotification(id: 0, title: "Appointment reminder", body: "You have appointment at : ${formattedDate!} Time: ${formattedTime!}", seconds: 1, payload: payloadJsonString, dateTime: dateTime!);
        setState(() {
          localNotify = false;
          timer.cancel();
        });
      }

    });


  }


  void listenToNotification(){
    service.onNotificationClick.stream.listen(onNotificationListener);
  }

  void onNotificationListener(String? payload){
    if(payload!=null && payload.isNotEmpty){
      //ConsultationPayloadModel? p = ConsultationPayloadModel.fromJsonString(payload);
      //print(p.patientId + " " + p.selectedServiceName + " " + p.consultationId);
      Navigator.push(context, MaterialPageRoute(builder: (context) => PushNotificationScreen(payload:payload)));

    }
    else{
      Fluttertoast.showToast(msg: 'payload empty');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generateRegistrationTokenForPatient();
    generateLocalNotification();
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 130,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
                  )
              ),

              child: Padding(
                padding: const EdgeInsets.only(left: 20.0,right: 20,top: 15),
                child: ListView(
                  children: [
                    // Logo, CircleAvatar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/Logo.png",
                              height: height * 0.05,
                            ),
                          ],
                        ),

                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const UserProfileScreen()));
                          },
                          child: Row(
                            children: [
                              (currentUserInfo!.imageUrl != null) ? CircleAvatar(
                                backgroundColor: Colors.lightBlue,
                                foregroundImage: NetworkImage(
                                  currentUserInfo!.imageUrl!,
                                ),
                              ) :
                              CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Text(
                                  currentUserInfo!.name![0],
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 15,),

                    // Searchbar
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onChanged: (textTyped) {
                              //;
                            },

                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: "Search by services",
                                fillColor: Colors.white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(15)),

                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),

            ),

        ),

        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
              )
          ),

           child: SingleChildScrollView(
             child: Column(
               children: [
                 const SizedBox(height: 10),

                 //Emergency Service Container
                 Container(
                   decoration: const BoxDecoration(
                     image: DecorationImage(
                         image: AssetImage("assets/background_color.png"),
                         opacity: 0.5,
                         fit: BoxFit.cover),
                   ),
                   height: 170,


                   child: Column(
                     children: [
                       const SizedBox(width: 10),

                       // Title
                       Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           const SizedBox(width: 10),

                           Text(
                             "Emergency Doctor",
                             style: GoogleFonts.montserrat(
                               color: Colors.black,
                               fontWeight: FontWeight.bold,
                               fontSize: 15,
                             ),
                           ),
                         ],
                       ),

                       // Emergency Container
                       Expanded(
                         child: ListView.builder(
                           itemCount: 3,
                           scrollDirection: Axis.horizontal,
                           itemBuilder: (context, index) => Container(
                             height: 150,
                             width: 150,
                             margin: const EdgeInsets.all(10),

                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(10),
                               color: Colors.white,
                             ),

                             child: Center(
                               child: Padding(
                                 padding: const EdgeInsets.all(5.0),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                   children: [
                                     Text(
                                       firstListNames[index],
                                       textAlign: TextAlign.center,
                                       style: GoogleFonts.montserrat(
                                         fontSize: 12,
                                         fontWeight: FontWeight.bold,
                                       ),
                                     ),

                                     Image.asset(
                                       'assets/' + firstListImages[index] + '.png',
                                       height: 50,
                                     ),

                                     Text(
                                       "৳500",
                                       style: GoogleFonts.montserrat(
                                         fontSize: 12,
                                         fontWeight: FontWeight.bold,
                                       ),
                                     ),

                                     SizedBox(
                                       width: double.infinity,
                                       height: 20,
                                       child: ElevatedButton(
                                         onPressed: (){

                                         },

                                         child: const Text(
                                           "See doctor Now",
                                           style: TextStyle(
                                             fontSize: 12,
                                             fontWeight: FontWeight.bold
                                           ),
                                         ),

                                       ),
                                     ),

                                   ],
                                 ),
                               )
                               ),

                             ),
                           ),
                       ),
                     ],
                   ),

                   ),

                 const SizedBox(height: 10),

                 //Consult a specialist Container
                 Container(
                 decoration: const BoxDecoration(
                   image: DecorationImage(
                       image: AssetImage("assets/background_color.png"),
                       opacity: 0.5,
                       fit: BoxFit.cover),
                 ),

                 height: 170,

                 child: Column(
                   children: [
                     const SizedBox(width: 10),

                     // Title
                     Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         const SizedBox(width: 10),

                         Text(
                           "Consult a specialist",
                           style: GoogleFonts.montserrat(
                             color: Colors.black,
                             fontWeight: FontWeight.bold,
                             fontSize: 15,
                           ),
                         ),
                       ],
                     ),

                     // Specialist Container
                     Expanded(
                       child: ListView.builder(
                         itemCount: 3,
                         scrollDirection: Axis.horizontal,
                         itemBuilder: (context, index) => Container(
                           height: 150,
                           width: 150,
                           margin: const EdgeInsets.all(10),

                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             color: Colors.white,
                           ),
                           child: Center(
                               child: Padding(
                                 padding: const EdgeInsets.all(5.0),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                   children: [
                                     Text(
                                       secondListNames[index],
                                       textAlign: TextAlign.center,
                                       style: GoogleFonts.montserrat(
                                         fontSize: 12,
                                         fontWeight: FontWeight.bold,
                                       ),
                                     ),

                                     Image.asset(
                                       'assets/' + secondListImages[index] + '.png',
                                       height: 50,
                                     ),

                                     Text(
                                       "৳500",
                                       style: GoogleFonts.montserrat(
                                         fontSize: 12,
                                         fontWeight: FontWeight.bold,
                                       ),
                                     ),

                                     SizedBox(
                                       width: double.infinity,
                                       height: 20,
                                       child: ElevatedButton(
                                         onPressed: (){

                                         },

                                         child: const Text(
                                           "See doctor Now",
                                           style: TextStyle(
                                               fontSize: 12,
                                               fontWeight: FontWeight.bold
                                           ),
                                         ),


                                       ),
                                     )

                                   ],
                                 ),
                               )
                           ),

                         ),
                       ),
                     ),
                   ],
                 ),
               ),

                 const SizedBox(height: 10),

                 //Our Services Container
                 Container(
                   decoration:  const BoxDecoration(
                     image: DecorationImage(
                         image: AssetImage("assets/background_color.png"),
                         opacity: 0.5,
                         fit: BoxFit.cover,
                     ),
                   ),
                   alignment: Alignment.center,
                   height: 270,

                   child: Column(
                     children: [
                       const SizedBox(height: 5),

                       Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           const SizedBox(width: 10),

                           Text(
                             "Our Services",
                             style: GoogleFonts.montserrat(
                               color: Colors.black,
                               fontWeight: FontWeight.bold,
                               fontSize: 15,
                             ),
                           ),
                         ],
                       ),

                       const SizedBox(height: 5),

                       Padding(
                         padding: const EdgeInsets.only(left: 5,right: 5),
                         child: GridView(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                           shrinkWrap: true,
                           scrollDirection: Axis.vertical,
                           physics: const ScrollPhysics(),
                           children: [
                             GestureDetector(
                               onTap: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => const CIConsultationDashboard()));
                               },
                               child: Container(
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(10),
                                   color: Colors.white,
                                 ),
                                 margin: const EdgeInsets.fromLTRB(5,10,5,0),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Image.asset(
                                       "assets/leader.png",
                                        height: 50,
                                        width: 50,
                                     ),

                                     const SizedBox(height: 10),

                                     Text(
                                       "CI Consultation",
                                       style: GoogleFonts.montserrat(
                                           color: Colors.black,
                                           fontSize: 12,
                                           fontWeight: FontWeight.bold
                                       ),
                                     )

                                   ],
                                 ),
                               ),
                             ),

                             GestureDetector(
                               onTap: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => VideoConsultationDashboard()));
                               },
                               child: Container(
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(10),
                                   color: Colors.white,
                                 ),
                                 margin: EdgeInsets.fromLTRB(5,10,5,10),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Image.asset(
                                       "assets/live consultation.png",
                                       height: 50,
                                       width: 50,
                                     ),

                                     Text(
                                       "Doctor Live\nConsultation",
                                       textAlign: TextAlign.center,
                                       style: GoogleFonts.montserrat(
                                           color: Colors.black,
                                           fontSize: 12,
                                           fontWeight: FontWeight.bold
                                       ),
                                     )

                                   ],
                                 ),
                               ),
                             ),

                             GestureDetector(
                               onTap: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => const VisaInvitationDashboard()));
                                 selectedService = "Visa Invitation";
                               },
                               child: Container(
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(10),
                                   color: Colors.white,
                                 ),
                                 margin: const EdgeInsets.fromLTRB(5,10,5,10),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Image.asset(
                                       "assets/visa.png",
                                       height: 50,
                                       width: 50,
                                     ),

                                     const SizedBox(height: 10),

                                     Text(
                                       "Visa Invitation",
                                       style: GoogleFonts.montserrat(
                                           color: Colors.black,
                                           fontSize: 12,
                                           fontWeight: FontWeight.bold
                                       ),
                                     )

                                   ],
                                 ),
                               ),
                             ),

                             GestureDetector(
                               onTap: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => PharmacyDashboard()));
                               },
                               child: Container(
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(10),
                                   color: Colors.white,
                                 ),
                                 margin: EdgeInsets.fromLTRB(5,10,5,10),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     Image.asset(
                                       "assets/medicine-2.png",
                                       height: 50,
                                       width: 50,
                                     ),

                                     Text(
                                       "Online Pharmacy",
                                       textAlign: TextAlign.center,
                                       style: GoogleFonts.montserrat(
                                           color: Colors.black,
                                           fontSize: 12,
                                           fontWeight: FontWeight.bold
                                       ),
                                     )

                                   ],
                                 ),
                               ),
                             ),
                             Container(
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10),
                                 color: Colors.white,
                               ),
                               margin: EdgeInsets.fromLTRB(5,10,5,10),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Image.asset(
                                     "assets/doctor (2).png",
                                     height: 50,
                                     width: 50,
                                   ),

                                   const SizedBox(height: 5,),

                                   Text(
                                     "Doctor Appointment",
                                     textAlign: TextAlign.center,
                                     style: GoogleFonts.montserrat(
                                         color: Colors.black,
                                         fontSize: 12,
                                         fontWeight: FontWeight.bold
                                     ),
                                   )

                                 ],
                               ),
                             ),
                             Container(
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10),
                                 color: Colors.white,
                               ),
                               margin: EdgeInsets.fromLTRB(5,10,5,10),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Image.asset(
                                     "assets/report.png",
                                     height: 50,
                                     width: 50,
                                   ),

                                   const SizedBox(height: 10),

                                   Text(
                                     "Report Review",
                                     style: GoogleFonts.montserrat(
                                         color: Colors.black,
                                         fontSize: 12,
                                         fontWeight: FontWeight.bold
                                     ),
                                   )

                                 ],
                               ),
                             ),
                           ],

                         ),
                       ),
                     ],
                   )

                 )

                 ]
               ),
             ),
           ),
        )
    );

}
}
