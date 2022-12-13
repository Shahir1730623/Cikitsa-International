import 'dart:async';
import 'dart:math';
import 'package:app/our_services/visa_invitation/visa_doctor_details.dart';
import 'package:app/widgets/progress_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../global/global.dart';
import '../../models/doctor_model.dart';
import '../doctor_live_consultation/doctor_profile.dart';

class VisaDoctorChoose extends StatefulWidget {
  const VisaDoctorChoose({Key? key}) : super(key: key);

  @override
  State<VisaDoctorChoose> createState() => _VisaDoctorChooseState();
}

class _VisaDoctorChooseState extends State<VisaDoctorChoose> {
  DatabaseReference reference = FirebaseDatabase.instance.ref().child("Doctors");
  TextEditingController searchTextEditingController = TextEditingController();

  void retrieveDoctorDataFromDatabase(String doctorId) {
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("Doctors");
    reference
        .child(doctorId)
        .once()
        .then((dataSnap){
      DataSnapshot snapshot = dataSnap.snapshot;
      if (snapshot.exists) {
        selectedDoctorInfo = DoctorModel.fromSnapshot(snapshot);
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
    });
  }

    @override
    Widget build(BuildContext context) {
      return SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return false;
          },
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
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, top: 20, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Logo, CircleAvatar

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset("assets/visaInvitationImages/passport.png", height: 35,),

                          SizedBox(width: 10),

                          Text(
                            "Visa Invitation",
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black
                            ),
                          ),


                        ],
                      ),

                      const SizedBox(height: 15),

                      // Searchbar
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: searchTextEditingController,
                              onChanged: (textTyped) {
                                setState(() {

                                });
                              },

                              decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.search),
                                  hintText: "Search by doctor or hospital",
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
                      // Search bar

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

              child: Column(
                children: [
                  const SizedBox(height: 10,),

                  Flexible(
                    child: FirebaseAnimatedList(
                        query: reference,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot, Animation<double> animation,
                            int index) {
                          final doctorName = "Dr. " + (snapshot.value as Map)["firstName"].toString() + " " + (snapshot.value as Map)["lastName"].toString();
                          final workplace = (snapshot.value as Map)["workplace"].toString();
                          if (searchTextEditingController.text.isEmpty) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return ProgressDialog(message: "message");
                                    }
                                );

                                doctorId = (snapshot.value as Map)["id"];
                                retrieveDoctorDataFromDatabase(doctorId!);

                                Timer(const Duration(seconds: 3), () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const VisaDoctorDetails()));
                                });

                                //saveSelectedDoctor(index);

                              },

                              child: Container(
                                height: 220,
                                width: 200,
                                margin: const EdgeInsets.only(top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),

                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20, left: 15, top: 15,),
                                  child: Row(
                                    children: [
                                      // Left Column
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          // Doc image
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundColor: Colors.grey[100],
                                            foregroundImage: NetworkImage(
                                              (snapshot.value as Map)["imageUrl"].toString(),
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                        ],
                                      ),

                                      const SizedBox(width: 10,),

                                      // Right Column
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Doctor Name
                                            Text(
                                              "Dr. " + (snapshot.value as Map)["firstName"].toString() + " " + (snapshot.value as Map)["lastName"].toString(),
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                              ),
                                            ),

                                            const SizedBox(height: 15),


                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  (snapshot.value as Map)["specialization"].toString(),
                                                  style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),

                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(50),
                                                      color: Colors.grey.shade200
                                                  ),

                                                  height: 30,
                                                  width: 30,

                                                  child: Transform.rotate(
                                                    angle: 180 * pi / 180,
                                                    child: const Icon(
                                                      Icons.arrow_back_ios_new,
                                                      color: Colors.black,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),

                                            const SizedBox(height: 15),

                                            Text(
                                              "MBBS, MPH, MS(Orthopedics),FCSPS(Orthopedics)",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 13,
                                              ),
                                            ),


                                            const SizedBox(height: 15),

                                            Text(
                                              "Experience: " + (snapshot.value as Map)["experience"].toString(),
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),

                                            const SizedBox(height: 12),

                                            Text(
                                              "Workplace: " + (snapshot.value as Map)["workplace"].toString(),
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 5,),


                                    ],
                                  ),
                                ),
                              ),
                            );
                          }

                          else if ((doctorName.toLowerCase().contains(
                              searchTextEditingController.text.toLowerCase())) || (workplace.toLowerCase().contains(searchTextEditingController.text.toLowerCase()))) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return ProgressDialog(message: "message");
                                    }
                                );

                                doctorId = (snapshot.value as Map)["id"];
                                retrieveDoctorDataFromDatabase(doctorId!);

                                Timer(const Duration(seconds: 3), () {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const VisaDoctorDetails()));
                                });

                                //saveSelectedDoctor(index);

                              },

                              child: Container(
                                height: 220,
                                width: 200,
                                margin: const EdgeInsets.only(top: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),

                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20, left: 15, top: 15,),
                                  child: Row(
                                    children: [
                                      // Left Column
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          // Doc image
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundColor: Colors.grey[100],
                                            foregroundImage: NetworkImage(
                                              (snapshot.value as Map)["imageUrl"].toString(),
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                        ],
                                      ),

                                      const SizedBox(width: 10,),

                                      // Right Column
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // Doctor Name
                                            Text(
                                              "Dr. " + (snapshot.value as Map)["firstName"].toString() + " " + (snapshot.value as Map)["lastName"].toString(),
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                              ),
                                            ),

                                            const SizedBox(height: 15),


                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  (snapshot.value as Map)["specialization"].toString(),
                                                  style: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),

                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(50),
                                                      color: Colors.grey.shade200
                                                  ),

                                                  height: 30,
                                                  width: 30,

                                                  child: Transform.rotate(
                                                    angle: 180 * pi / 180,
                                                    child: const Icon(
                                                      Icons.arrow_back_ios_new,
                                                      color: Colors.black,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),

                                            const SizedBox(height: 15),

                                            Text(
                                              "MBBS, MPH, MS(Orthopedics),FCSPS(Orthopedics)",
                                              style: GoogleFonts.montserrat(
                                                fontSize: 13,
                                              ),
                                            ),


                                            const SizedBox(height: 15),

                                            Text(
                                              "Experience: " + (snapshot.value as Map)["experience"].toString(),
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),

                                            const SizedBox(height: 12),

                                            Text(
                                              "Workplace: " + (snapshot
                                                  .value as Map)["workplace"]
                                                  .toString(),
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 5,),


                                    ],
                                  ),
                                ),
                              ),
                            );
                          }

                          else {
                            return Container();
                          }
                        }


                    ),
                  ),

                ],
              ),

            ),
          ),
        ),
      );
    }



}
