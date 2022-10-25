import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../global/global.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.arrow_back_outlined,
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          "Schedule",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ()  {
                  //
                },
                style: ElevatedButton.styleFrom(
                    primary: (Colors.white),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                            color: Colors.black,
                        )
                    )),

                child: Text(
                  "Pay Now",
                  style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ()  {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context){
                        return const Center(child: CircularProgressIndicator());
                      }
                  );

                  Timer(const Duration(seconds: 2),()  {
                    Navigator.pop(context);
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                  });

                },
                style: ElevatedButton.styleFrom(
                    primary: (Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Colors.black,
                        )
                    )),

                child: Text(
                  "Pay Now",
                  style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
              ),
            ),

            SizedBox(height: height * 0.1,),

            Flexible(
              child: FirebaseAnimatedList(
                  query: FirebaseDatabase.instance.ref().child("Users")
                      .child(currentFirebaseUser!.uid)
                      .child("patientList")
                      .child(patientId!)
                      .child("consultations"),

                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context,DataSnapshot snapshot, Animation<double> animation,int index) {
                    //final specialization = (snapshot.value as Map)["name"].toString();

                    return GestureDetector(
                      onTap: (){
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => LiveDoctors()));
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        margin: const EdgeInsets.fromLTRB(25,10,25,10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5,),

                            Text(
                              "Appointment Date",
                              style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.blue
                              ),
                            ),

                            // Specialization Name
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/appointment_date.png",
                                ),

                                const SizedBox(width: 5),

                                Text(
                                  (snapshot.value as Map)["date"].toString(),
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
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
                                  (snapshot.value as Map)["time"].toString() + " AM",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
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
                                    CircleAvatar(//or 15.0
                                      child: Container(
                                        height: 30.0,
                                        width: 30.0,
                                        color: Colors.grey[100],
                                        child: Image.asset(
                                          "assets/Logo.png",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                  ],
                                ),

                                const SizedBox(width: 5,),

                                // Right Column
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Doctor Name
                                      Text(
                                        (snapshot.value as Map)["doctorName"].toString(),
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),

                                      const SizedBox(height: 5),


                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            (snapshot.value as Map)["specialization"].toString(),
                                            style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),

                                          // Online status
                                          Container(
                                            decoration: BoxDecoration(
                                                color: ((snapshot.value as Map)["consultationType"].toString() == "Scheduled") ? Colors.blue : Colors.grey
                                            ),

                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                (snapshot.value as Map)["status"].toString(),
                                                style: GoogleFonts.montserrat(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),

                                          ),
                                        ],
                                      ),

                                      Text(
                                        "Workplace: " + (snapshot.value as Map)["workplace"].toString(),
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),


                                      const SizedBox(height: 10),

                                      Text(
                                        "Status: " + (snapshot.value as Map)["consultationType"].toString(),
                                        style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                    ],
                                  ),
                                ),

                              ],
                            ),

                            const SizedBox(height: 20,),


                          ],
                        ),
                      ),
                    );


                  }
              ),
            )

          ],
        ),
      ),
    );
  }
}
