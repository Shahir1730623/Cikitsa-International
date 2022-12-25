import 'dart:async';

import 'package:app/common_screens/waiting_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../common_screens/coundown_screen.dart';
import '../../global/global.dart';
import '../../main_screen.dart';
import '../../models/doctor_model.dart';
import '../../widgets/progress_dialog.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({Key? key}) : super(key: key);

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  String patientLength = "0";

  void countNumberOfChild(){
    FirebaseDatabase.instance.ref('Doctors').child(doctorId!).once().then((snapData) {
      DataSnapshot snapshot = snapData.snapshot;
      if(snapshot.value != null){
        selectedDoctorInfo = DoctorModel.fromSnapshot(snapshot);
        patientLength = selectedDoctorInfo!.patientQueueLength!;
      }

      else{
        Fluttertoast.showToast(msg: "No doctor record exist with this credentials");
      }
    });

    Map info = {
      "patientId" : patientId!
    };

    String count = (int.parse(selectedDoctorInfo!.patientQueueLength.toString()) + 1).toString();
    FirebaseDatabase.instance.ref('Doctors').child(doctorId!).child('patientQueueLength').set(count);
    FirebaseDatabase.instance.ref('Doctors').child(doctorId!).child('patientQueue').child(consultationId!).set(info);
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

  void loadScreen(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "Fetching data...");
        }
    );

    Timer(const Duration(seconds: 2),()  {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      loadScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
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
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainScreen()), (Route<dynamic> route) => false);
            },
            icon: (selectedDoctorInfo == null || selectedDoctorInfo!.status == "Offline") ? const Icon(Icons.arrow_back_ios,color: Colors.black,) : Container()
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
                                const TextSpan(text: 'Tap ', style: TextStyle(fontSize: 13)),

                                (selectedDoctorInfo == null || selectedDoctorInfo!.status == "Offline") ?
                                const TextSpan(text: 'Return to dashboard', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)):
                                const TextSpan(text: 'Enter Waiting Room', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)) ,


                                (selectedDoctorInfo == null || selectedDoctorInfo!.status == "Offline") ?
                                const TextSpan(text: '') :
                                const TextSpan(text: ' to enter video call', style: TextStyle(fontSize: 13)),
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
                              child: const Icon(Icons.calendar_month),
                            ),

                            const SizedBox(width: 10,),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Date & Time',style: TextStyle(fontWeight: FontWeight.bold,)),

                                const SizedBox(height: 5,),

                                (selectedDoctorInfo != null) ? Text(selectedConsultationInfo!.date!,style: TextStyle(color: Colors.grey,),) : Text(selectedCIConsultationInfo!.date!,style: TextStyle(color: Colors.grey,),),

                                const SizedBox(height: 5,),

                                (selectedDoctorInfo != null) ? Text(selectedConsultationInfo!.time!,style: TextStyle(color: Colors.grey,),) : Text(selectedCIConsultationInfo!.time!,style: TextStyle(color: Colors.grey,),)
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
                              child: const Icon(Icons.video_camera_front_rounded,color: Colors.white,),
                            ),

                            const SizedBox(width: 10,),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Appointment Type',style: TextStyle(fontWeight: FontWeight.bold,),),

                                const SizedBox(height: 5,),

                                const Text('Video Call',style: TextStyle(color: Colors.grey,)),

                                const SizedBox(height: 10,),

                                ElevatedButton(
                                  onPressed: () {
                                    if(selectedDoctorInfo == null){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                                      //pushNotify = true;
                                    }

                                    else if(selectedDoctorInfo!.status == "Online"){
                                      countNumberOfChild();
                                      if(int.parse(selectedDoctorInfo!.patientQueueLength!) == 0){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CountDownScreen()));
                                      }

                                      else{
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const WaitingScreen()));
                                      }

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

                                  child: (selectedDoctorInfo == null || selectedDoctorInfo!.status == "Offline") ? const Text('Return to dashboard') : const Text('Enter Waiting Room') ,
                                ),
                              ],
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20,),

                  (selectedDoctorInfo != null) ? const Text(
                    'Doctor Info',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,fontSize: 20,
                    ),
                  ) :
                  const Text(
                    'Consultant Info',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 20,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (selectedDoctorInfo != null) ? CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[100],
                        foregroundImage: NetworkImage(selectedDoctorInfo!.doctorImageUrl!),
                      ) : CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[100],
                        foregroundImage: const AssetImage('assets/leader.png'),
                      ),

                      const SizedBox(width: 10,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (selectedDoctorInfo != null) ? Text(selectedConsultationInfo!.doctorName!, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),) : Text(selectedCIConsultationInfo!.consultantName!, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),

                          const SizedBox(height: 5,),

                          (selectedDoctorInfo != null) ? Text(selectedDoctorInfo!.specialization!, style: const TextStyle(color: Colors.grey,fontSize: 15),) : const Text("Consultant", style: TextStyle(color: Colors.grey,fontSize: 15),),
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
                        (selectedDoctorInfo != null) ? selectedConsultationInfo!.doctorFee! : selectedCIConsultationInfo!.consultantFee!,
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
                        (selectedDoctorInfo != null) ? selectedConsultationInfo!.doctorFee! : selectedCIConsultationInfo!.consultantFee!,
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
      ),
    );
  }
}
