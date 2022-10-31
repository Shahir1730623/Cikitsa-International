import 'dart:async';

import 'package:app/our_services/online_pharmacy/medicine_details_screen.dart';
import 'package:app/our_services/online_pharmacy/order_history.dart';
import 'package:app/our_services/online_pharmacy/search_medicine_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main_screen.dart';
import '../../widgets/progress_dialog.dart';

class PharmacyDashboard extends StatefulWidget {
  const PharmacyDashboard({Key? key}) : super(key: key);

  @override
  State<PharmacyDashboard> createState() => _PharmacyDashboardState();
}

class _PharmacyDashboardState extends State<PharmacyDashboard> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pharmacy Department',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
              return MainScreen();
            }));
          },
          icon: Icon(Icons.arrow_back,size: 25),
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.card_travel),
            color: Colors.black,
          ),

          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderHistoryScreen()));
            },
            icon: Icon(Icons.history),
            color: Colors.black,
          ),
        ],
      ),

      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(25.0),
                // Searchbar
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchMedicineScreen()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(width: 1),
                    ),
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Search by medicine or generic name',
                          style: TextStyle(
                              color: Colors.grey
                          ),
                        ),

                        SizedBox(width: 10,),

                        Icon(
                          Icons.search,
                          color: Colors.lightBlue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // First Container
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background_color.png"),
                    opacity: 0.5,
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    // Slideshow
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: CarouselSlider(
                        items: [
                          // Slideshow first container
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage("assets/sliderImages/slider_img.jpg"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),

                          // Slideshow second container
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage("assets/sliderImages/slider_img2.jpg"),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                        options: CarouselOptions(
                          height: 150.0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.02,),

              // Second Container
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/background_color.png"),
                    opacity: 0.5,
                    fit: BoxFit.cover,
                  ),
                ),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    const SizedBox(height: 10,),

                    // Upload Text
                    Text(
                      'Upload your prescription',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),

                    const SizedBox(height: 10,),

                    // Upload details Text
                    Text(
                      'Please upload your prescription so that\n we can do entire work for you',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          "assets/prescription.png",
                          height: 80,
                          width: 80,
                        ),
                      ],
                    ),

                    // Upload Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 180,
                          height: 35,
                          child: ElevatedButton(
                            onPressed: ()  {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context){
                                    return ProgressDialog(message: "Please wait...");
                                  }
                              );

                              // Saving selected doctor id
                              //saveSelectedDoctorIdToDatabase();

                              Timer(const Duration(seconds: 2),()  {
                                Navigator.pop(context);
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseUser()));
                              });


                            },

                            style: ElevatedButton.styleFrom(
                                primary: Colors.greenAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),

                            child: Text(
                              "Upload Prescription" ,
                              style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(10,10,10,0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Shop by Department',
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),
                    ),

                    Text(
                      'View All',
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {

                      },
                      child: Card(
                        color: Colors.white,
                        shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/sugar-blood-level.png',
                                height: 40,
                                width: 40,
                              ),
                              SizedBox(height: 5,),
                              Text(
                                'Diabetes Essentials',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {

                      },
                      child: Card(
                        color: Colors.white,
                        shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/pharmacyImages/mask.png',
                                height: 40,
                                width: 40,
                              ),
                              SizedBox(height: 5,),
                              Text(
                                'Covid Essentials',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {

                      },
                      child: Card(
                        color: Colors.white,
                        shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/pharmacyImages/baby-diaper.png',
                                height: 40,
                                width: 40,
                              ),
                              SizedBox(height: 5,),
                              Text(
                                'Baby Care',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {

                      },
                      child: Card(
                        color: Colors.white,
                        shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/pharmacyImages/thermometers.png',
                                height: 40,
                                width: 40,
                              ),
                              SizedBox(height: 5,),
                              Text(
                                'Equipments &\nDevices',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {

                      },
                      child: Card(
                        color: Colors.white,
                        shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/pharmacyImages/surgical-instrument.png',
                                height: 40,
                                width: 40,
                              ),
                              SizedBox(height: 5,),
                              Text(
                                'Surgical Items',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {

                      },
                      child: Card(
                        color: Colors.white,
                        shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/pharmacyImages/mouthwash.png',
                                height: 40,
                                width: 40,
                              ),
                              SizedBox(height: 5,),
                              Text(
                                'Dental Products',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {

                      },
                      child: Card(
                        color: Colors.white,
                        shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/pharmacyImages/shampoo.png',
                                height: 40,
                                width: 40,
                              ),
                              SizedBox(height: 5,),
                              Text(
                                'Health &\nBeauty',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {

                      },
                      child: Card(
                        color: Colors.white,
                        shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/pharmacyImages/shaving-razor.png',
                                height: 40,
                                width: 40,
                              ),
                              SizedBox(height: 5,),
                              Text(
                                "Men's Product",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {

                      },
                      child: Card(
                        color: Colors.white,
                        shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/pharmacyImages/shampoo.png',
                                height: 40,
                                width: 40,
                              ),
                              SizedBox(height: 5,),
                              Text(
                                'Women"s Care',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      )
    );
  }
}
