import 'package:app/common_screens/new_user_info_form.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';
import '../our_services/doctor_live_consultation/doctor_profile.dart';

class ChooseUser extends StatefulWidget {
  const ChooseUser({Key? key}) : super(key: key);

  @override
  State<ChooseUser> createState() => _ChooseUserState();
}

class _ChooseUserState extends State<ChooseUser> {

  DatabaseReference reference = FirebaseDatabase.instance.ref().child("Users").child(currentFirebaseUser!.uid);

  void retrievePatientDataFromDatabase() {
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("Users");
    reference.child(currentFirebaseUser!.uid).once().then((dataSnap){
      final DataSnapshot snapshot = dataSnap.snapshot;
      if (snapshot.exists) {
        patientModel.id = (snapshot.value as Map)["patientList"]["1666248443568974"]["id"];
        patientModel.firstName = (snapshot.value as Map)["patientList"]["1666248443568974"]["firstName"];
        patientModel.lastName = (snapshot.value as Map)["patientList"]["lastName"];
        patientModel.weight = (snapshot.value as Map)["patientList"]["weight"];
        patientModel.height = (snapshot.value as Map)["patientList"]["height"];
        patientModel.gender = (snapshot.value as Map)["patientList"]["gender"];
        patientModel.relation = (snapshot.value as Map)["patientList"]["relation"];
        patientModel.visitationReason = (snapshot.value as Map)["patientList"]["visitationReason"];
        patientModel.problem = (snapshot.value as Map)["patientList"]["problem"];
      }

      else {
        Fluttertoast.showToast(msg: "No Patient record exist with this credentials");
      }
    });
    

    }


  @override
  void initState() {
    // TODO: implement initState
    retrievePatientDataFromDatabase();
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
                    color: Colors.lightBlueAccent
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
            const SizedBox(height: 100,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/doctor_new.png",width: 40),

                SizedBox(width: height * 0.01,),

                Text(
                  "Orthopedics",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,fontSize: 17
                  )
                ),

              ],
            ),

            SizedBox(height: height * 0.001),

            FirebaseAnimatedList(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                query: reference.child("patientList"),
                itemBuilder: (BuildContext context,DataSnapshot snapshot, Animation<double> animation,int index){
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
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
                  );
                }
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
