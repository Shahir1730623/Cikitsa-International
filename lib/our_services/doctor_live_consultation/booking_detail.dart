import 'package:flutter/material.dart';

import '../../common_screens/coundown_screen.dart';
import '../../global/global.dart';
import '../../main_screen.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Booking Detail',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: Colors.black,),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    "Booking Info",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),

                const SizedBox(height: 20,),

                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        const VerticalDivider(color: Colors.blueAccent, thickness: 3,),

                        const SizedBox(width: 10,),

                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Text('!',style: TextStyle(color: Colors.white),),
                        ),

                        const SizedBox(width: 10,),
                        
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: 'Tap ', style: TextStyle(fontSize: 13)),

                              (selectedDoctorInfo!.status == "Online") ?
                              const TextSpan(text: 'Enter Waiting Room', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)) :
                              const TextSpan(text: 'Return to dashboard', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),

                              (selectedDoctorInfo!.status == "Online") ?
                              const TextSpan(text: ' to enter video call', style: TextStyle(fontSize: 13)):
                              const TextSpan(text: ''),
                            ],

                              style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            )
                          ),
                        )
                        
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20,),

                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.calendar_month),
                          ),

                          const SizedBox(width: 10,),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date & Time',style: TextStyle(fontWeight: FontWeight.bold,),),

                              SizedBox(height: 5,),

                              Text('Monday, 20 Jun 2022',style: TextStyle(color: Colors.grey,),),

                              SizedBox(height: 5,),

                              Text('08:00 AM',style: TextStyle(color: Colors.grey,),),
                            ],
                          ),

                        ],
                      ),

                      const SizedBox(height: 10,),

                      const Divider(thickness: 2,),

                      const SizedBox(height: 10,),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.video_camera_front_rounded,color: Colors.white,),
                          ),

                          const SizedBox(width: 10,),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Appointment Type',style: TextStyle(fontWeight: FontWeight.bold,),),

                              const SizedBox(height: 5,),

                              Text('Video Call',style: TextStyle(color: Colors.grey,),),

                              const SizedBox(height: 10,),

                              ElevatedButton(
                                onPressed: () {
                                  if(selectedDoctorInfo == null){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                                    //pushNotify = true;
                                  }

                                  if(selectedDoctorInfo!.status == "Online"){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CountDownScreen()));
                                  }

                                  else{
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                                    //pushNotify = true;
                                  }
                                },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: (Colors.blue),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),

                                child: (selectedDoctorInfo!.status == "Online") ? const Text('Enter Waiting Room') : const Text('Return to dashboard') ,
                              ),
                            ],
                          ),

                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20,),

                const Text(
                  'Doctor Info',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,fontSize: 20,
                  ),
                ),

                SizedBox(height: 20,),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(//or 15.0
                      radius: 30,
                      backgroundColor: Colors.grey[100],
                      foregroundImage: AssetImage(
                        "assets/doctor_new.png",
                      ),
                    ),

                    const SizedBox(width: 10,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(selectedDoctorInfo!.doctorName! ,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),

                        const SizedBox(height: 5,),

                        Text(selectedDoctorInfo!.specialization!,style: const TextStyle(color: Colors.grey,fontSize: 15),),
                      ],
                    ),
                    
                  ],
                ),

                const SizedBox(height: 10,),

                const Divider(thickness: 2,),

                const SizedBox(height: 10,),

                const Text(
                  'Payment Info',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                ),

                const SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Consultation fee',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                      ),
                    ),

                    Text(
                      selectedDoctorInfo!.fee!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Tax',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16
                      ),
                    ),

                    Text(
                      '0',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10,),

                const Divider(thickness: 2,),

                const SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Fee',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),

                    Text(
                      selectedDoctorInfo!.fee!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
