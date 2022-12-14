import 'dart:async';
import 'package:app/doctor_screens/doctor_live_consultations.dart';
import 'package:app/doctor_screens/doctor_physical_appointments.dart';
import 'package:app/doctor_screens/doctor_visa_invitation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../global/global.dart';
import '../models/consultation_payload_model.dart';
import '../models/doctor_model.dart';
import '../models/push_notification_screen.dart';
import '../our_services/visa_invitation/video_call.dart';
import '../push_notification/push_notification_system.dart';
import '../service_file/local_notification_service.dart';
import '../splash_screen/splash_screen.dart';
import '../widgets/progress_dialog.dart';
import '../widgets/push_notification_dialog_doctor.dart';
import 'doctor_profile_edit.dart';


class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({Key? key}) : super(key: key);

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  String patientLength = "0";
  Timer? timer;
  String? formattedDate;
  String? formattedTime;
  late final LocalNotificationService service;

  setConsultationInfoToAccepted(String consultationId){
    FirebaseDatabase.instance.ref()
        .child("Doctors")
        .child(currentFirebaseUser!.uid)
        .child("consultations")
        .child(consultationId).child("consultationType").set("Accepted");
  }

  checkPatientsInQueue(){
    timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      FirebaseDatabase.instance.ref()
          .child("Doctors")
          .child(currentFirebaseUser!.uid)
          .onValue
          .listen((dataSnap) {
        DataSnapshot snapshot = dataSnap.snapshot;
        if (mounted){
          setState((){
            patientLength = (snapshot.value as Map)["patientQueueLength"].toString();
          });
        }

    });
  });
}

  Future<void> generateLocalNotification() async {
    timer = Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
      if(localNotify == true){
        // Converting time and date to yyyy-MM-dd 24 hour format for sending the time as param to showScheduledNotification()
        var df = DateFormat.jm().parse(selectedConsultationInfoForDocAndConsultant!.time!);
        DateTime date = DateFormat("dd-MM-yyyy").parse(selectedConsultationInfoForDocAndConsultant!.date!);
        formattedDate = DateFormat('yyyy-MM-dd').format(date);
        formattedTime = DateFormat('HH:mm').format(df);
        dateTime =  formattedDate! + " " + formattedTime!;
        Fluttertoast.showToast(msg: dateTime!);

        ConsultationPayloadModel consultationPayloadModel = ConsultationPayloadModel(currentUserId: currentFirebaseUser!.uid, patientId: selectedConsultationInfoForDocAndConsultant!.patientId!, selectedServiceName: "Doctor Live Consultation", consultationId: consultationId!);
        String payloadJsonString = consultationPayloadModel.toJsonString();
        await service.showScheduledNotification(id: 0, title: "Appointment reminder", body: "You have a scheduled appointment now. Click here to see the appointment", seconds: 1, payload: payloadJsonString, dateTime: dateTime!);
        if (mounted){
          setState(() {
            localNotify = false;
            timer.cancel();
          });
        }

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
    checkPatientsInQueue();
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generateRegistrationTokenForDoctor();
    generateLocalNotification();
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();

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
  void dispose() {
    timer!.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    height: 350,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
                        )
                    ),
                  ),

                  Positioned(
                    top: 20,
                    left: 20,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorProfileEdit()));
                      },
                      child: (currentDoctorInfo!.doctorImageUrl != null) ?
                      CircleAvatar(
                        radius: 25,
                        foregroundImage: NetworkImage(currentDoctorInfo!.doctorImageUrl!),
                      ) : CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 30,
                        child: Text(
                          currentDoctorInfo!.doctorFirstName![0],
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      )
                    ),
                  ),

                  Positioned(
                      top: 120,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome!',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          Text(
                            "Dr." + currentDoctorInfo!.doctorLastName!,
                            style: GoogleFonts.montserrat(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          const SizedBox(
                            height: 15,
                          ),


                          Text(
                            'Have a nice day',
                            style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
                            ),
                          ),

                          const SizedBox(height: 10,),


                        ],
                      )
                  ),

                  Positioned(
                    top: 280,
                    left: 20,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          onPrimary: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: const Size(100, 40),
                        ),
                        onPressed: () {
                          currentDoctorInfo = null;
                          loggedInUser = "";
                          firebaseAuth.signOut();
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.logout),

                            SizedBox(width: 10,),

                            Text(
                              'Log out',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                    ),
                  ),

                  Positioned(
                    top: 260,
                    right: 20,
                    child: Column(
                      children: [
                        Text(
                            "Patient in Queue",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,fontSize: 12,color: Colors.blue
                            )
                        ),

                        const SizedBox(height: 5,),

                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blue,
                          child: Text(
                            patientLength,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),

              SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CI Services',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorLiveConsultation()));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 1,color: Colors.grey.shade400),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Image.asset(
                                          "assets/doctor (1).png"
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10,),

                                Text(
                                  'Consultation',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600
                                  ),
                                )

                              ],
                            ),

                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorPhysicalAppointments()));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 1,color: Colors.grey.shade400),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Image.asset(
                                          "assets/authenticationImages/stethoscope-2.png"
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10,),

                                  Text(
                                    'Physical\nAppointments',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600
                                    ),
                                  )

                                ],
                              ),
                            ),

                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorVisaInvitation()));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 1,color: Colors.grey.shade400),
                                    ),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Image.asset(
                                          "assets/visaInvitationImages/passport.png"
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10,),

                                  Text(
                                    'Visa\nInvitation',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600
                                    ),
                                  )

                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Appointments Now',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700
                              ),
                            ),

                            const Text('Upcoming\nAppointments',textAlign: TextAlign.center, style: TextStyle(color: Colors.blue,),)
                          ],
                        ),

                        const SizedBox(height: 20,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FirebaseAnimatedList(
                              query:  FirebaseDatabase.instance.ref().child("Doctors").child(currentFirebaseUser!.uid).child("consultations"),
                              scrollDirection: Axis.vertical,
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                                final consultationType = (snapshot.value as Map)["consultationType"].toString();
                                if(consultationType == "Now"){
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
                                              offset: const Offset(0, 0), // changes position of shadow
                                            ),
                                          ],
                                        ),

                                        child: IntrinsicHeight(
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
                                                          Text(
                                                            'Appointment Date',
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.grey.shade700
                                                            ),),

                                                          const SizedBox(height: 10,),

                                                          Row(
                                                            children: [
                                                              Icon(Icons.access_time),

                                                              SizedBox(width: 10,),

                                                              Text((snapshot.value as Map)["date"].toString() +' '+ (snapshot.value as Map)["time"].toString(),style: TextStyle(color: Colors.grey),),
                                                            ],
                                                          ),
                                                        ],
                                                      ),

                                                      SizedBox(width: MediaQuery.of(context).size.width-310,),

                                                    ],
                                                  ),

                                                  const SizedBox(height: 10,),

                                                  Container(color: Colors.grey, height: 1, width: MediaQuery.of(context).size.width-80,),

                                                  const SizedBox(height: 10,),

                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor: Colors.blue,
                                                        child: Text(
                                                          (snapshot.value as Map)["patientName"][0],
                                                          style: GoogleFonts.montserrat(
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white,
                                                            fontSize: 30
                                                          ),
                                                        ),
                                                      ),

                                                      const SizedBox(width: 20,),

                                                      Column(
                                                        children: [
                                                          Text((snapshot.value as Map)["patientName"],style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 16)),

                                                          const SizedBox(height: 15,),

                                                          Row(
                                                            children: [
                                                              Text((snapshot.value as Map)["gender"].toString(),
                                                                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 14)),

                                                              const Text(" - "),
                                                              Text("${(snapshot.value as Map)["weight"]} kg",
                                                                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 14)),
                                                              const Text(" - "),

                                                              Text("${(snapshot.value as Map)["height"]} feet",
                                                                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 14)),
                                                            ],
                                                          ),

                                                          const SizedBox(height: 10,),

                                                          // Button
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              SizedBox(
                                                                child: ElevatedButton.icon(
                                                                  onPressed: ()  {
                                                                    showDialog(
                                                                        context: context,
                                                                        barrierDismissible: false,
                                                                        builder: (BuildContext context){
                                                                          return ProgressDialog(message: "Please wait...");
                                                                        }
                                                                    );

                                                                    consultationId = (snapshot.value as Map)["id"];
                                                                    userId = (snapshot.value as Map)["userId"];
                                                                    patientId = (snapshot.value as Map)["patientId"];
                                                                    setConsultationInfoToAccepted(consultationId!);
                                                                    Timer(const Duration(seconds: 5),()  {
                                                                      Navigator.pop(context);
                                                                      channelName = consultationId;
                                                                      Fluttertoast.showToast(msg: channelName!);
                                                                      tokenRole = 1;
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AgoraScreen()));
                                                                    });


                                                                  },

                                                                  style: ElevatedButton.styleFrom(
                                                                      primary: (Colors.blue),
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(20))),

                                                                  label: Text(
                                                                    "Join Now" ,
                                                                    style: GoogleFonts.montserrat(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.white
                                                                    ),
                                                                  ),

                                                                  icon: const Icon(
                                                                    Icons.video_call_rounded
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )

                                                        ],
                                                      )

                                                    ],
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),

                                        ),

                                      ),

                                      SizedBox(height: height * 0.025,)
                                    ],
                                  );

                                }

                                else{
                                  return Container();
                                }
                              },
                            ),

                            SizedBox(height: height * 0.07,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "You have no appointments now",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade700
                                  ),
                                ),
                              ],
                            )


                          ],
                        ),


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
