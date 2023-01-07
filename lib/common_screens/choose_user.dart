import 'dart:async';

import 'package:app/common_screens/new_user_info_form.dart';
import 'package:app/common_screens/old_user_info_form.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';
import '../models/doctor_model.dart';
import '../our_services/doctor_live_consultation/doctor_profile.dart';
import '../widgets/progress_dialog.dart';

class ChooseUser extends StatefulWidget {
  const ChooseUser({Key? key}) : super(key: key);

  @override
  State<ChooseUser> createState() => _ChooseUserState();
}

class _ChooseUserState extends State<ChooseUser> {

  List countList = [];
  DatabaseReference reference = FirebaseDatabase.instance.ref().child("Users").child(currentFirebaseUser!.uid);
  String patientLength = "0";

  void countNumberOfChild(){
    FirebaseDatabase.instance.ref('Doctors').child(doctorId!).once().then((snapData) {
      DataSnapshot snapshot = snapData.snapshot;
      if(snapshot.value != null){
        selectedDoctorInfo = DoctorModel.fromSnapshot(snapshot);
        setState((){
          patientLength = selectedDoctorInfo!.patientQueueLength!;
        });
      }

      else{
        Fluttertoast.showToast(msg: "No doctor record exist with this credentials");
      }

    });
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
      if(selectedService == "Doctor Live Consultation"){
        countNumberOfChild();
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Choose Patient",
            style: GoogleFonts.montserrat(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
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
        body: Column(
          children: [
            const SizedBox(height: 70,),

           (selectedServiceDatabaseParentName == "consultations")?
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10),

                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[100],
                  foregroundImage: NetworkImage(
                    selectedDoctorInfo!.doctorImageUrl!,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  flex: 2,
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                         "Dr. " + selectedDoctorInfo!.doctorFirstName! + " " + selectedDoctorInfo!.doctorLastName!,
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,fontSize: 13
                          )
                      ),

                      const SizedBox(height: 5),

                      Text(
                          selectedDoctorInfo!.specialization!,
                          style: GoogleFonts.montserrat(fontSize: 13
                          )
                      ),

                      const SizedBox(height: 5),

                      Text(
                          selectedDoctorInfo!.workplace!,
                          style: GoogleFonts.montserrat(fontSize: 13
                          )
                      ),

                    ],
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 5,),

                      Text(
                          "Patient in Queue",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,fontSize: 10,color: Colors.blue
                          )
                      ),

                      const SizedBox(height: 5,),

                     CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue,
                        child: Text(
                          patientLength,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,color: Colors.white
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 5,),


              ],
            ) : Container(),

            SizedBox(height: height * 0.001),

            Flexible(
              child: FirebaseAnimatedList(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  query: reference.child("patientList"),
                  itemBuilder: (BuildContext context,DataSnapshot snapshot, Animation<double> animation,int index){
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: (){
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context){
                                return ProgressDialog(message: "");
                              }
                          );

                          Timer(const Duration(seconds: 1),()  {
                            Navigator.pop(context);
                            patientId = (snapshot.value as Map)["id"];
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const OldUserForm()));
                          });

                        },

                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name: ${(snapshot.value as Map)["firstName"]} ${(snapshot.value as Map)["lastName"]}",
                                style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 20,),),

                                const SizedBox(height: 10,),

                                Text("Age: " + (snapshot.value as Map)["age"].toString(),
                                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 20)
                                ),


                                Row(
                                  children: [
                                    Text((snapshot.value as Map)["gender"].toString(),
                                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 15)),

                                    const Text(" - "),
                                    Text("${(snapshot.value as Map)["weight"]} kg",
                                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 15)),
                                    const Text(" - "),

                                    Text("${(snapshot.value as Map)["height"]} feet",
                                        style: GoogleFonts.montserrat(fontWeight: FontWeight.bold,fontSize: 15)),

                                    SizedBox(width: height *  0.1,),

                                    Image.asset("assets/select.png",width: 40)

                                  ],
                                )
                              ],
                            ),
                          ),

                        ),
                      ),
                    );
                  }
              ),
            ),

            SizedBox(height: height * 0.025),

            TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NewUserForm()));
                },
                child: Text(
                  "New Patient? Create Profile Now",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold, fontSize: 17,color: Colors.black,
                  ),
                )
            ),


          ],
        )


          ),
        );

  }
}
