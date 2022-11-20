import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../global/global.dart';
import '../splash_screen/splash_screen.dart';


class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({Key? key}) : super(key: key);

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: CircleAvatar(
                  radius: 20,
                  foregroundImage: NetworkImage(currentDoctorInfo!.doctorImageUrl!),
                ),
              ),

              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications,color: Colors.black),
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

                      const SizedBox(height: 30,),

                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            onPrimary: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                            minimumSize: const Size(100, 40),
                          ),
                          onPressed: () {
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.doorbell),

                              SizedBox(width: 10,),

                              Text(
                                'Urgent Care',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  )
              ),
            ],
          ),

          Container(
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
                          Container(
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

                      Column(
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
                                  "assets/prescription.png"
                              ),
                            ),
                          ),

                          const SizedBox(height: 10,),

                          Text(
                            'Prescription\nGenerator',
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
                        'My Appointment',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700
                        ),
                      ),

                      const Text('See All', style: TextStyle(color: Colors.blue,),)
                    ],
                  ),

                  const SizedBox(height: 20,),

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
                                          Text(
                                            'Appointment Date',
                                            style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade700
                                          ),),

                                          const SizedBox(height: 10,),

                                          Row(
                                            children: const[
                                              Icon(Icons.access_time),

                                              SizedBox(width: 10,),

                                              Text('Wed Jun 20 - 8:00 - 8:30 AM',style: TextStyle(color: Colors.grey),),
                                            ],
                                          ),
                                        ],
                                      ),

                                      SizedBox(width: MediaQuery.of(context).size.width-310,),

                                      const Icon(Icons.more_vert),

                                    ],
                                  ),

                                  const SizedBox(height: 10,),

                                  Container(color: Colors.grey, height: 1, width: MediaQuery.of(context).size.width-80,),

                                  const SizedBox(height: 10,),

                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        backgroundImage: AssetImage('assets/doctorImages/doctor-1.png'),
                                      ),

                                      const SizedBox(width: 10,),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('dr. Rokabuming'),

                                          SizedBox(height: 10,),

                                          Text('Dentist'),
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
                ],
              ),
            ),
          )


        ],
      ),
    );
  }
}
