import 'package:app/consultant_screens/telemedicine_consultations.dart';
import 'package:app/global/global.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../splash_screen/splash_screen.dart';

class ConsultantDashboard extends StatefulWidget {
  const ConsultantDashboard({Key? key}) : super(key: key);

  @override
  State<ConsultantDashboard> createState() => _ConsultantDashboardState();
}

class _ConsultantDashboardState extends State<ConsultantDashboard> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
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
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorProfileEdit()));
                      },
                      child: (currentConsultantInfo!.imageUrl != null) ?
                      CircleAvatar(
                        radius: 25,
                        foregroundImage: NetworkImage(currentConsultantInfo!.imageUrl!),
                      ) : CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 30,
                        child: Text(
                          currentConsultantInfo!.name![0],
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
                          "Back",
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
                        currentConsultantInfo = null;
                        loggedInUser = "";
                        firebaseAuth.signOut();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SplashScreen()));
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
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorLiveConsultation()));
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
                                        "assets/leader.png"
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10,),

                              Text(
                                'CI Consultation',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600
                                ),
                              )

                            ],
                          ),

                          Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TelemedicineConsultations()));
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

                          Column(
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

                        ],
                      ),

                      const SizedBox(height: 20,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CI Consultations',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700
                            ),
                          ),

                          const Text('See All', style: TextStyle(color: Colors.blue,),)
                        ],
                      ),

                      const SizedBox(height: 20,),

                      /*Column(
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
                          )


                        ],
                      ),*/


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
