import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LiveDoctors extends StatefulWidget {
  const LiveDoctors({Key? key}) : super(key: key);

  @override
  State<LiveDoctors> createState() => _LiveDoctorsState();
}

class _LiveDoctorsState extends State<LiveDoctors> {
  List doctorImagesList = ["doctor-1","doctor-2","doctor-3"];
  List doctorNames = ["Dr. Ventakesh Rajkumar","Dr. Narendar Dasaraju","Dr. Rajesh Krishnamoorhty"];
  List experienceList = ["10","15","30"];
  List hospitalNameList = ["Evercare Hospital","Square Hospital","United Hospital"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150.0),
          child: AppBar(
            leading: const Icon(
              Icons.arrow_back_outlined,
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
                  )
              ),

              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo, CircleAvatar

                    Text(
                      "Doctor's List",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black
                      ),
                    ),

                    const SizedBox(height: 17),

                    // Search bar
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextField(
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none
                                ),
                                hintText: 'Search by doctor or hospital',
                                hintStyle: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15
                                ),
                                prefixIcon: Container(
                                  padding: const EdgeInsets.all(15),
                                  width: 10,
                                  child: Image.asset("assets/NavigationBarItem/search.png"),
                                )
                            ),
                          ),
                        ),

                      ],
                    )
                  ],
                ),
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
                const SizedBox(height: 15,),

                Flexible(
                  child: ListView.builder(
                    itemCount: doctorNames.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LiveDoctors()));
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
                          padding: const EdgeInsets.only(right: 15,left: 15,top: 15,),
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
                                      height: 100.0,
                                      width: 90.0,
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

                                      const SizedBox(width: 10,),

                                      Text(
                                        "5.0",
                                        style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),

                                      const SizedBox(width: 10,),

                                      Text(
                                        "(10)",
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
                                        "৳500",
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
                                    // Doc image
                                    Text(
                                      doctorNames[index],
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),

                                    const SizedBox(height: 15),

                                    Text(
                                      "Orthopedics",
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),

                                    const SizedBox(height: 15),

                                    Text(
                                      "MBBS, MPH, MS(Orthopedics),FCSPS(Orthopedics)",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 13,
                                      ),
                                    ),

                                    const SizedBox(height: 35),

                                    Text(
                                      "Experience: " + experienceList[index],
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    Text(
                                      "Workplace: " + hospitalNameList[index],
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),






                                  ],
                                ),
                              ),



                            ],
                          ),
                        ),
                      ),
                    ),
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
