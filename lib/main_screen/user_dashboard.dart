import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  List firstListImages = ["covid-19","diarrhea","dengue"];
  List firstListNames = ["Covid-19 Treatment","Diarrhea Treatment","Dengue/Malaria Treatment"];
  List secondListImages = ["sugar-blood-level","bone-1","brainstorm"];
  List secondListNames = ["Diabetes Specialist","Orthopedics","Psychiatrist"];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
                  )
              ),

              child: Row(
                children: [
                  const SizedBox(height: 10,),
                  Image.asset('assets/Logo.png', height: height * 0.5,),
                ],
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
               children: [
                 const SizedBox(height: 20),

                 Container(
                   decoration: const BoxDecoration(
                     image: DecorationImage(
                         image: AssetImage("assets/background_color.png"),
                         fit: BoxFit.cover),
                   ),

                   height: 150,

                   child: ListView.builder(
                     itemCount: 3,
                     scrollDirection: Axis.horizontal,
                     itemBuilder: (context, index) => Container(
                       height: 150,
                       width: 150,
                       margin: const EdgeInsets.all(10),

                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(10),
                         color: Colors.white,
                       ),
                       child: Center(
                         child: Padding(
                           padding: const EdgeInsets.all(5.0),
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               Text(
                                 firstListNames[index],
                                 textAlign: TextAlign.center,
                                 style: GoogleFonts.montserrat(
                                   fontSize: 12,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),

                               Image.asset(
                                 'assets/' + firstListImages[index] + '.png',
                                 height: 50,
                               ),

                               Text(
                                 "৳500",
                                 style: GoogleFonts.montserrat(
                                   fontSize: 12,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),

                               SizedBox(
                                 width: double.infinity,
                                 height: 20,
                                 child: ElevatedButton(
                                   onPressed: (){

                                   },

                                   child: const Text(
                                     "See doctor Now",
                                     style: TextStyle(
                                         fontSize: 10,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),


                                 ),
                               )

                             ],
                           ),
                         )
                         ),

                       ),
                     ),
                   ),

                 const SizedBox(height: 20),

                 Container(
                 decoration: const BoxDecoration(
                   image: DecorationImage(
                       image: AssetImage("assets/background_color.png"),
                       fit: BoxFit.cover),
                 ),

                 height: 150,

                 child: ListView.builder(
                   itemCount: 3,
                   scrollDirection: Axis.horizontal,
                   itemBuilder: (context, index) => Container(
                     height: 150,
                     width: 150,
                     margin: const EdgeInsets.all(10),

                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(10),
                       color: Colors.white,
                     ),
                     child: Center(
                         child: Padding(
                           padding: const EdgeInsets.all(5.0),
                           child: Column(
                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                             children: [
                               Text(
                                 secondListNames[index],
                                 textAlign: TextAlign.center,
                                 style: GoogleFonts.montserrat(
                                   fontSize: 12,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),

                               Image.asset(
                                 'assets/' + secondListImages[index] + '.png',
                                 height: 50,
                               ),

                               Text(
                                 "৳500",
                                 style: GoogleFonts.montserrat(
                                   fontSize: 12,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),

                               SizedBox(
                                 width: double.infinity,
                                 height: 20,
                                 child: ElevatedButton(
                                   onPressed: (){

                                   },

                                   child: const Text(
                                     "See doctor Now",
                                     style: TextStyle(
                                         fontSize: 10,
                                         fontWeight: FontWeight.bold
                                     ),
                                   ),


                                 ),
                               )

                             ],
                           ),
                         )
                     ),

                   ),
                 ),
               ),

                 const SizedBox(height: 20),

                 Container(
                   decoration:  const BoxDecoration(
                     image: DecorationImage(
                         image: AssetImage("assets/background_color.png"),
                         fit: BoxFit.cover,
                     ),
                   ),
                   alignment: Alignment.center,
                   height: 300,

                   child: Column(
                     children: [
                       const SizedBox(height: 5),

                       Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           const SizedBox(width: 10),

                           Text(
                             "Our Services",
                             style: GoogleFonts.montserrat(
                               color: Colors.black,
                               fontWeight: FontWeight.bold,
                               fontSize: 20,
                             ),
                           ),
                         ],
                       ),

                       const SizedBox(height: 10),

                       Padding(
                         padding: const EdgeInsets.only(left: 5,right: 5),
                         child: GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                           shrinkWrap: true,
                           children: [
                             Container(
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10),
                                 color: Colors.white,
                               ),
                               margin: EdgeInsets.fromLTRB(5,10,5,10),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Image.asset(
                                     "assets/leader.png",
                                      height: 50,
                                      width: 50,
                                   ),

                                   const SizedBox(height: 10),

                                   Text(
                                     "CI Consultation",
                                     style: GoogleFonts.montserrat(
                                         color: Colors.black,
                                         fontSize: 12,
                                         fontWeight: FontWeight.bold
                                     ),
                                   )

                                 ],
                               ),
                             ),
                             Container(
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10),
                                 color: Colors.white,
                               ),
                               margin: EdgeInsets.fromLTRB(5,10,5,10),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Image.asset(
                                     "assets/live consultation.png",
                                     height: 50,
                                     width: 50,
                                   ),

                                   Text(
                                     "Doctor Live\nConsultation",
                                     textAlign: TextAlign.center,
                                     style: GoogleFonts.montserrat(
                                         color: Colors.black,
                                         fontSize: 12,
                                         fontWeight: FontWeight.bold
                                     ),
                                   )

                                 ],
                               ),
                             ),
                             Container(
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10),
                                 color: Colors.white,
                               ),
                               margin: EdgeInsets.fromLTRB(5,10,5,10),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Image.asset(
                                     "assets/visa.png",
                                     height: 50,
                                     width: 50,
                                   ),

                                   const SizedBox(height: 10),

                                   Text(
                                     "Visa Invitation",
                                     style: GoogleFonts.montserrat(
                                         color: Colors.black,
                                         fontSize: 12,
                                         fontWeight: FontWeight.bold
                                     ),
                                   )

                                 ],
                               ),
                             ),
                             Container(
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10),
                                 color: Colors.white,
                               ),
                               margin: EdgeInsets.fromLTRB(5,10,5,10),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Image.asset(
                                     "assets/medicine.png",
                                     height: 50,
                                     width: 50,
                                   ),

                                   Text(
                                     "Online Pharmacy",
                                     textAlign: TextAlign.center,
                                     style: GoogleFonts.montserrat(
                                         color: Colors.black,
                                         fontSize: 12,
                                         fontWeight: FontWeight.bold
                                     ),
                                   )

                                 ],
                               ),
                             ),
                             Container(
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10),
                                 color: Colors.white,
                               ),
                               margin: EdgeInsets.fromLTRB(5,10,5,10),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Image.asset(
                                     "assets/doctor (2).png",
                                     height: 50,
                                     width: 50,
                                   ),

                                   const SizedBox(height: 5,),

                                   Text(
                                     "Doctor Appointment",
                                     textAlign: TextAlign.center,
                                     style: GoogleFonts.montserrat(
                                         color: Colors.black,
                                         fontSize: 12,
                                         fontWeight: FontWeight.bold
                                     ),
                                   )

                                 ],
                               ),
                             ),
                             Container(
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10),
                                 color: Colors.white,
                               ),
                               margin: EdgeInsets.fromLTRB(5,10,5,10),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Image.asset(
                                     "assets/report.png",
                                     height: 50,
                                     width: 50,
                                   ),

                                   const SizedBox(height: 10),

                                   Text(
                                     "Report Review",
                                     style: GoogleFonts.montserrat(
                                         color: Colors.black,
                                         fontSize: 12,
                                         fontWeight: FontWeight.bold
                                     ),
                                   )

                                 ],
                               ),
                             ),
                           ],

                         ),
                       ),
                     ],
                   )

                 )


                 ]
               ),
             ),
           ),
        )
    );


}
}
