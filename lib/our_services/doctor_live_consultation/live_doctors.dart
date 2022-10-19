import 'package:app/main_screen/user_dashboard.dart';
import 'package:app/models/doctor_model.dart';
import 'package:app/our_services/doctor_live_consultation/doctor_profile.dart';
import 'package:app/our_services/doctor_live_consultation/live_consultation_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LiveDoctors extends StatefulWidget {
  const LiveDoctors({Key? key}) : super(key: key);

  @override
  State<LiveDoctors> createState() => _LiveDoctorsState();
}

class _LiveDoctorsState extends State<LiveDoctors> {
  static List<DoctorModel> doctorList = [
    DoctorModel("1", "Dr. Ventakesh Rajkumar", "Orthopedics", "MBBS, MPH, MS(Orthopedics),FCSPS(Orthopedics)", "10", "Evercare Hospital", "5", "10", "500","Online"),
    DoctorModel("2", "Dr. Narendar Dasaraju", "Orthopedics", "MBBS, MPH, MS(Orthopedics),FCSPS(Orthopedics)", "15", "Square Hospital", "5", "10", "500","Online"),
    DoctorModel("3", "Dr. Rajesh Krishnamoorhty", "Orthopedics", "MBBS, MPH, MS(Orthopedics),FCSPS(Orthopedics)", "15", "United Hospital", "5", "10", "500","Offline"),
  ];

  // Creating the list that we are going to display and filter
  List<DoctorModel> displayList = List.from(doctorList);

  void updateDoctorList(String text){
    setState(() {
      displayList = doctorList.where((element) => element.doctorName!.toLowerCase().contains(text.toLowerCase())).toList();
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
                padding: const EdgeInsets.only(left: 20.0,right: 20,top: 20,bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo, CircleAvatar

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset("assets/video-call.png", height: 30,),

                        SizedBox(width: 10),

                        Text(
                          "Doctor Live Consultation",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black
                          ),
                        ),


                      ],
                    ),

                    const SizedBox(height: 20),

                    // Searchbar
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onChanged: (textTyped) {
                              updateDoctorList(textTyped);
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

            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10,),

                  Flexible(
                    child: ListView.builder(
                      itemCount: displayList.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorProfile()));
                        },
                        child: Container(
                          height: 220,
                          width: 200,
                          margin: const EdgeInsets.only(top: 10,bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),

                          child: Padding(
                            padding: const EdgeInsets.only(right: 0,left: 20,top: 15,),
                            child: Row(
                              children: [
                                // Left Column
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Doc image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),//or 15.0
                                      child: Container(
                                        height: 70.0,
                                        width: 70.0,
                                        color: Colors.grey[100],
                                        child: Image.asset(
                                          "assets/Logo.png",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    // Star,Rating and Total visits
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "assets/star.png",
                                          height: 15,
                                        ),

                                        const SizedBox(width: 7,),

                                        Text(
                                          displayList[index].rating!,
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),

                                        const SizedBox(width: 7,),

                                        Text(
                                          "(" + displayList[index].totalVisits! + ")",
                                           style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),


                                      ],
                                    ),

                                    const SizedBox(height: 10,),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Fee",
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),

                                        Text(
                                          displayList[index].fee!,
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    )


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
                                        displayList[index].doctorName!,
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),

                                      const SizedBox(height: 5),


                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            displayList[index].specialization!,
                                            style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),

                                          // Online status
                                          Container(
                                            decoration: BoxDecoration(
                                                color: (displayList[index].status == "Online") ? Colors.lightGreen : Colors.grey
                                            ),

                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                displayList[index].status!,
                                                style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),

                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 15),

                                      Text(
                                        displayList[index].degrees!,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                        ),
                                      ),

                                      const SizedBox(height: 15),

                                      Text(
                                        "Experience: ${displayList[index].experience!}",
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      Text(
                                        "Workplace: ${displayList[index].workplace!}",
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),

                                SizedBox(height: 5,),



                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )


                ],
              ),
            ),

          ),
        ),
      ),
    );
  }
}
