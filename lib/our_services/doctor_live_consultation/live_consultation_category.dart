import 'package:app/TabPages/history_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'live_doctors.dart';

class LiveConsultationCategory extends StatefulWidget {
  const LiveConsultationCategory({Key? key}) : super(key: key);

  @override
  State<LiveConsultationCategory> createState() => _LiveConsultationCategoryState();
}

class _LiveConsultationCategoryState extends State<LiveConsultationCategory> {
  List specializationImagesList = ["sugar-blood-level","bone","brain","eye"];
  List specializationNamesList = ["Diabetes Specialist","Orthopedics","Psychiatrist","Ophthalmologist"];
  final List<Color> colorList = <Color>[Colors.green, Colors.blue,Colors.yellow,Colors.pink];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150.0),
            child: AppBar(
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
                        "Doctor Live Consultation",
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
                                  hintText: 'Search by services or speciality',
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
                    itemCount: 4,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LiveDoctors()));
                      },
                      child: Container(
                        height: 150,
                        width: 150,
                        margin: const EdgeInsets.fromLTRB(20,10,20,10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: colorList[index],
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(height: 10,),

                            Row(
                              children: [
                                SizedBox(width: 85),
                                Text(
                                  specializationNamesList[index],
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 5,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 1,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/" + specializationImagesList[index] + ".png",
                                      height: 50,
                                    ),
                                  ],
                                ),

                                Text(
                                    "Lorem ipsum dolor sit amet,\nincididunt ut labore et dolore\nexercitation ullamco laboris "
                                ),

                                Image.asset(
                                  "assets/right-arrow.png",
                                  height: 20,
                                ),

                                SizedBox(width: 1),

                              ],
                            ),

                            SizedBox(height: 30,),




                          ],
                        ),
                      ),
                    ),
                  ),
                ),


              ],
            ),
          ),
        ) ,
      ),
    );
  }
}
