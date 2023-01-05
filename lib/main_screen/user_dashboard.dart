import 'dart:async';

import 'package:app/main_screen/user_profile_screen.dart';
import 'package:app/models/user_model.dart';
import 'package:app/our_services/ci_consultation/ci_consultation_dashboard.dart';
import 'package:app/our_services/doctor_appointment/doctor_appointment_dashboard.dart';
import 'package:app/our_services/doctor_live_consultation/video_consultation_dashboard.dart';
import 'package:app/our_services/online_pharmacy/pharmacy_dashboard.dart';
import 'package:app/our_services/visa_invitation/visa_invitation_dashboard.dart';
import 'package:app/push_notification/push_notification_system.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  //String? formattedDate;
  //String? formattedTime;
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
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
        String formattedTime = DateFormat('HH:mm').format(df);
        dateTime =  formattedDate + " " + formattedTime;
        Fluttertoast.showToast(msg: dateTime!);

        ConsultationPayloadModel consultationPayloadModel = ConsultationPayloadModel(currentUserId: currentFirebaseUser!.uid, patientId: patientId!, selectedServiceName: "Doctor Live Consultation", consultationId: consultationId!);
        String payloadJsonString = consultationPayloadModel.toJsonString();
        await service.showScheduledNotification(id: 0, title: "Appointment reminder", body: "You have appointment at : ${formattedDate} Time: ${formattedTime}", seconds: 1, payload: payloadJsonString, dateTime: dateTime!);
        setState(() {
          localNotify = false;
          timer.cancel();
        });
      }

      else if(localNotifyForCI == true){
        var df = DateFormat.jm().parse(selectedCIConsultationInfo!.time!);
        DateTime date = DateFormat("dd-MM-yyyy").parse(selectedCIConsultationInfo!.date!);
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
        String formattedTime = DateFormat('HH:mm').format(df);
        dateTime =  formattedDate + " " + formattedTime;
        Fluttertoast.showToast(msg: dateTime!);

        ConsultationPayloadModel consultationPayloadModel = ConsultationPayloadModel(currentUserId: currentFirebaseUser!.uid, patientId: patientId!, selectedServiceName: "CI Consultation", consultationId: consultationId!);
        String payloadJsonString = consultationPayloadModel.toJsonString();
        await service.showScheduledNotification(id: 0, title: "Appointment reminder", body: "You have an doctor appointment now. Click here to see the appointment", seconds: 1, payload: payloadJsonString, dateTime: dateTime!);
        //await service.showScheduledNotification(id: 0, title: "Appointment reminder", body: "You have CI appointment at : ${formattedDate} Time: ${formattedTime}", seconds: 1, payload: payloadJsonString, dateTime: dateTime!);
        setState(() {
          localNotifyForCI = false;
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
    var width = MediaQuery.of(context).size.width;
    final double itemHeight = (height - kToolbarHeight - 24) / 2;
    final double itemWidth = (width / 1.0);

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xfff5feff),
            systemNavigationBarColor: Colors.black26,// Status bar
          ),
          automaticallyImplyLeading: false,
          toolbarHeight: 70,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  color: Color(0xfff5feff)
              ),

              child: Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 20,top: 5,bottom: 5),
                child: ListView(
                  children: [
                    // Logo, CircleAvatar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/Logo.png",
                              height: height * 0.075,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          actions: [
            GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const UserProfileScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10,top: 0),
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
                    radius: 35,
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
            ),
          )],

        ),

        body: Container(
          decoration: const BoxDecoration(
              color: Colors.white
          ),

           child: SingleChildScrollView(
             child: Column(
               children: [
                 SizedBox(height: height * 0.02),

                 Container(
                   height: itemHeight / 1.5,
                   decoration: const BoxDecoration(
                     image: DecorationImage(
                       image: AssetImage("assets/background_color.png"),
                       opacity: 0.5,
                       fit: BoxFit.cover,
                     ),
                   ),
                   alignment: Alignment.center,
                   child: Column(
                     children: [
                       SizedBox(height: height * 0.025),
                       // Slideshow
                       CarouselSlider(
                         items: [
                           // Slideshow first container
                           Container(
                             height: height * 0.32,
                             decoration: BoxDecoration(
                               image: const DecorationImage(
                                 image: AssetImage("assets/sliderImages/slider_img.jpg"),
                                 fit: BoxFit.cover,
                               ),
                               borderRadius: BorderRadius.circular(10),
                             ),
                           ),

                           // Slideshow second container
                           Container(
                             height: height * 0.32,
                             decoration: BoxDecoration(
                               image: const DecorationImage(
                                 image: AssetImage("assets/sliderImages/slider_img2.jpg"),
                                 fit: BoxFit.cover,
                               ),
                               borderRadius: BorderRadius.circular(10),
                             ),
                           ),
                         ],
                         options: CarouselOptions(
                           height: height * 0.25,
                           enlargeCenterPage: true,
                           autoPlay: true,
                           aspectRatio: 16 / 9,
                           autoPlayCurve: Curves.fastOutSlowIn,
                           enableInfiniteScroll: true,
                           autoPlayAnimationDuration: Duration(milliseconds: 800),
                           viewportFraction: 0.8,
                         ),
                       ),
                     ],
                   ),
                 ),

                 SizedBox(height: height * 0.025),

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
                   height: height * 0.35,

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
                         child: GridView.count(crossAxisCount: 3,childAspectRatio: (itemWidth / itemHeight),
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
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => const PharmacyDashboard()));
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

                             GestureDetector(
                               onTap: (){
                                 Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorAppointmentDashboard()));
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
                             ),

                             GestureDetector(
                               onTap: (){
                                 var snackBar = const SnackBar(content: Text('Work in progress'));
                                 ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                             ),
                           ],

                         ),
                       ),
                     ],
                   )

                 ),

                 SizedBox(height: height * 0.025),

                 //Emergency Service Container
                 Container(
                   decoration: const BoxDecoration(
                     image: DecorationImage(
                         image: AssetImage("assets/background_color.png"),
                         opacity: 0.5,
                         fit: BoxFit.cover),
                   ),

                   height: height * 0.20,


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
                             height: itemHeight,
                             width: itemWidth / 2,
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

                 SizedBox(height: height * 0.025),

                 //Consult a specialist Container
                 Container(
                 decoration: const BoxDecoration(
                   image: DecorationImage(
                       image: AssetImage("assets/background_color.png"),
                       opacity: 0.5,
                       fit: BoxFit.cover),),

                 height: height * 0.2,

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
                           height: itemHeight,
                           width: itemWidth / 2,
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

             ]
               ),
             ),
           ),
        ),
    );

}
}
