import 'package:app/TabPages/history_screen.dart';
import 'package:app/home/home_screen.dart';
import 'package:app/main_screen.dart';
import 'package:app/main_screen/user_dashboard.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/specialization_model.dart';
import 'live_doctors.dart';

class LiveConsultationCategory extends StatefulWidget {
  const LiveConsultationCategory({Key? key}) : super(key: key);

  @override
  State<LiveConsultationCategory> createState() => _LiveConsultationCategoryState();
}

class _LiveConsultationCategoryState extends State<LiveConsultationCategory> {
  final List<Color> colorList = <Color>[Colors.green, Colors.blue,Colors.yellow,Colors.pink];

  static List<SpecializationModel> specializationList = [
    SpecializationModel("Endocrinologist","Lorem ipsum dolor sit amet\nincididunt ut labore et dolore\nexercitation ullamco laboris","sugar-blood-level"),
    SpecializationModel("Orthopedics","Lorem ipsum dolor sit amet\nincididunt ut labore et dolore\nexercitation ullamco laboris","bone"),
    SpecializationModel("Psychiatrist","Lorem ipsum dolor sit amet\nincididunt ut labore et dolore\nexercitation ullamco laboris","brain"),
    SpecializationModel("Ophthalmologist","Lorem ipsum dolor sit amet\nincididunt ut labore et dolore\nexercitation ullamco laboris","eye"),
  ];

  // Creating the list that we are going to display and filter
  /*List<SpecializationModel> displayList = List.from(specializationList);
  void updateSpecializationList(String text){
    setState(() {
      displayList = specializationList.where((element) => element.specializationName!.toLowerCase().contains(text.toLowerCase())).toList();
    });
  }*/
  
  TextEditingController searchTextEditingController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
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
                      // Logo, Title
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

                      // Search bar
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: searchTextEditingController,
                              onChanged: (textTyped) {
                                //updateSpecializationList(textTyped);
                                setState(() {

                                });
                              },

                              decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.search),
                                  hintText: "Search by specialization",
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
                const SizedBox(height: 15,),

                Flexible(
                  child: FirebaseAnimatedList(
                    query: FirebaseDatabase.instance.ref().child("specializationCategories"),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context,DataSnapshot snapshot, Animation<double> animation,int index) {
                      final specialization = (snapshot.value as Map)["name"].toString();

                      if(searchTextEditingController.text.isEmpty){
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LiveDoctors()));
                          },
                          child: Container(
                            height: 130,
                            width: 150,
                            margin: const EdgeInsets.fromLTRB(25,10,25,10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: colorList[index],
                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const SizedBox(height: 10,),

                                // Specialization Name
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 85),
                                    Text(
                                      specializationList[index].specializationName!,
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 5,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: 1,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/${specializationList[index].imageName!}.png",
                                          height: 50,
                                        ),
                                      ],
                                    ),

                                    Text(
                                        specializationList[index].specializationDetails!
                                    ),

                                    Image.asset(
                                      "assets/right-arrow.png",
                                      height: 20,
                                    ),

                                    const SizedBox(width: 1),

                                  ],
                                ),

                                const SizedBox(height: 30,),


                              ],
                            ),
                          ),
                        );
                      }

                      else if ((specialization.toLowerCase().contains(searchTextEditingController.text.toLowerCase()))){
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LiveDoctors()));
                          },
                          child: Container(
                            height: 130,
                            width: 150,
                            margin: const EdgeInsets.fromLTRB(25,10,25,10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: colorList[index],
                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const SizedBox(height: 10,),

                                // Specialization Name
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 85),
                                    Text(
                                      specializationList[index].specializationName!,
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 5,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: 1,),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/${specializationList[index].imageName!}.png",
                                          height: 50,
                                        ),
                                      ],
                                    ),

                                    Text(
                                        specializationList[index].specializationDetails!
                                    ),

                                    Image.asset(
                                      "assets/right-arrow.png",
                                      height: 20,
                                    ),

                                    const SizedBox(width: 1),

                                  ],
                                ),

                                const SizedBox(height: 30,),


                              ],
                            ),
                          ),
                        );
                      }

                      else{
                        return Container();
                      }


                    }
                  ),
                )

              ],
            ),
          ) ,
        ),
      ),
    );
  }
}
