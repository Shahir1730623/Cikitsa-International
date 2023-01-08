import 'dart:async';
import 'dart:math';

import 'package:app/our_services/visa_invitation/visa_invitation_details.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../global/global.dart';
import '../../models/visa_invitation_model.dart';
import '../../widgets/progress_dialog.dart';

class VisaInvitationHistory extends StatefulWidget {
  const VisaInvitationHistory({Key? key}) : super(key: key);

  @override
  State<VisaInvitationHistory> createState() => _VisaInvitationHistoryState();
}

class _VisaInvitationHistoryState extends State<VisaInvitationHistory> {
  String invitationStatus = "Waiting";

  void retrieveInvitationDataFromDatabase(String invitationId) {
    FirebaseDatabase.instance.ref().child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId!)
        .child("visaInvitation")
        .child(invitationId)
        .once()
        .then((dataSnap) {
          DataSnapshot snapshot = dataSnap.snapshot;
          if (snapshot.exists) {
            selectedVisaInvitationInfo = VisaInvitationModel.fromSnapshot(snapshot);
          }

          else {
            Fluttertoast.showToast(msg: "No consultation record exist");
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
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
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

        title: Text(
          "Invitations History",
          style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: height * 0.1,),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        invitationStatus = "Waiting";
                      });

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: (invitationStatus == "Waiting") ? Colors.white : Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: Colors.black,
                            )
                        )),

                    child: Text(
                      "Waiting",
                      style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5,),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        invitationStatus = "Accepted";
                      });

                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: (invitationStatus == "Accepted") ? Colors.white : Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: Colors.black,
                            )
                        )),

                    child: Text(
                      "Accepted",
                      style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: height * 0.05,),

            Flexible(
              child: FirebaseAnimatedList(
                  query: FirebaseDatabase.instance.ref().child("Users")
                      .child(currentFirebaseUser!.uid)
                      .child("patientList")
                      .child(patientId!)
                      .child("visaInvitation"),

                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    final status = (snapshot.value as Map)["status"].toString();

                    if (invitationStatus == status) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return ProgressDialog(message: 'message');
                              }
                          );

                          invitationId = (snapshot.value as Map)["id"];
                          retrieveInvitationDataFromDatabase(invitationId!);

                          Timer(const Duration(seconds: 1), () {
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const VisaInvitationDetails()));
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blueAccent),
                            color: Colors.white,
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 5,),

                              Text(
                                "Applied date",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                              ),

                              SizedBox(height: height * 0.01),

                              // Specialization Name
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    "assets/appointment_date.png",
                                  ),

                                  const SizedBox(width: 10),

                                  Text(
                                    (snapshot.value as Map)["date"].toString(),
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),

                                  Text(
                                    " - ",
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),

                                  Text(
                                    (snapshot.value as Map)["time"],
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 5,),

                              const Divider(
                                thickness: 1,
                              ),

                              const SizedBox(height: 5,),

                              Row(
                                children: [
                                  // Left Column
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Doc image
                                      CircleAvatar( //or 15.0
                                        radius: 30,
                                        backgroundColor: Colors.grey[100],
                                        foregroundImage: NetworkImage(
                                          (snapshot.value as Map)["doctorImageUrl"],
                                        ),
                                      ),

                                    ],
                                  ),

                                  const SizedBox(width: 10,),

                                  // Right Column
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Doctor Name
                                        Text(
                                          (snapshot.value as Map)["doctorName"].toString(),
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),

                                        const SizedBox(height: 5),

                                        // Doctor Specialization
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              (snapshot.value as Map)["specialization"],
                                              style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),

                                            // Status
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                  color: (status == "Waiting")
                                                      ? Colors.grey.shade200
                                                      : Colors.blue
                                              ),

                                              height: 30,
                                              width: 30,

                                              child: Transform.rotate(
                                                angle: 180 * pi / 180,
                                                child: Icon(
                                                  Icons.arrow_back_ios_new,
                                                  color: (status == "Waiting") ? Colors.black : Colors.white,
                                                  size: 20,
                                                ),
                                              ),


                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 5),

                                        // Workplace
                                        Text(
                                          (snapshot.value as Map)["workplace"],
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),


                                        const SizedBox(height: 15),

                                        Text(
                                          "Status: " + (snapshot.value as Map)["status"].toString(),
                                          style: GoogleFonts.montserrat(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),

                                ],
                              ),

                            ],
                          ),
                        ),
                      );
                    }

                    else {
                      return Container();
                    }
                  }
              ),
            )

          ],
        ),
      ),
    );

  }
}
