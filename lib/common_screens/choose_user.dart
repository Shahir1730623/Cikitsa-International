import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseUser extends StatefulWidget {
  const ChooseUser({Key? key}) : super(key: key);

  @override
  State<ChooseUser> createState() => _ChooseUserState();
}

class _ChooseUserState extends State<ChooseUser> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 70,
          leading: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 30,
          ),
          centerTitle:true,
          title: Text(
            "Consultation Information",
            style: GoogleFonts.montserrat(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
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
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 50,),
                  Text(
                    "Choose Patient",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

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

                                      const SizedBox(height: 15),


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
                                                    color: Colors.white
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
