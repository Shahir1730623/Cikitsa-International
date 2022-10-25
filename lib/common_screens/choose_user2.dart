import 'dart:async';

import 'package:app/our_services/doctor_live_consultation/history_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../global/global.dart';
import '../widgets/progress_dialog.dart';

class ChooseUser2 extends StatefulWidget {
  const ChooseUser2({Key? key}) : super(key: key);

  @override
  State<ChooseUser2> createState() => _ChooseUser2State();
}

class _ChooseUser2State extends State<ChooseUser2> {
  DatabaseReference reference = FirebaseDatabase.instance.ref().child("Users").child(currentFirebaseUser!.uid);

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
                  Text(
                      "Choose User",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,fontSize: 20
                      )
                  ),

                ],
              ),

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
                                  return const Center(child: CircularProgressIndicator());
                                }
                            );

                            Timer(const Duration(seconds: 2),()  {
                              Navigator.pop(context);
                              patientId = (snapshot.value as Map)["id"];
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen()));
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

            ],
          )


      ),
    );
  }
}
