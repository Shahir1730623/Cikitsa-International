import 'package:app/global/global.dart';
import 'package:app/main_screen/user_profile_screen_edit.dart';
import 'package:app/our_services/doctor_live_consultation/live_doctors.dart';
import 'package:app/splash_screen/splash_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../assistants/assistant_methods.dart';
import '../common_screens/choose_user2.dart';
import '../main_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
          body: Container(
            color: Colors.white,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Back and Logo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return MainScreen();
                                  }));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                  color: Colors.blue),
                              child: const Icon(
                                Icons.arrow_back_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Image.asset(
                            "assets/Logo.png",
                            width: 100,
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.05,),

                      // Profile Image CircleAvatar
                      DottedBorder(
                          padding: EdgeInsets.all(10),
                          borderType: BorderType.Oval,
                          radius: const Radius.circular(20),
                          color: Colors.blue,
                          dashPattern: [25,10],
                          strokeWidth: 3,
                          child: (currentUserInfo!.imageUrl != null) ? CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.lightBlue,
                            foregroundImage: NetworkImage(
                              currentUserInfo!.imageUrl!,
                            ),
                          ) : CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.blue,
                            child: Text(
                              currentUserInfo!.name![0],
                              style: GoogleFonts.montserrat(
                                  fontSize: 70,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          )
                      ),

                      // Edit Circle
                      Container(
                        transform: Matrix4.translationValues(0.0, -35.0, 0.0),
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)
                        ),

                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(50)
                            ),
                            child: IconButton(
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileScreenEdit()));
                                },
                                icon: Icon(Icons.edit,color: Colors.grey.shade400,))
                        ),
                      ),

                      Transform.translate(
                        offset: const Offset(0,-20),
                        child: Text(
                          currentUserInfo!.name!,
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontSize: 22
                          ),
                        ),
                      ),

                      Transform.translate(
                        offset: const Offset(0,-10),
                        child: Text(
                          currentUserInfo!.phone!,
                          style: GoogleFonts.montserrat(
                              color: Colors.grey.shade500,
                              fontSize: 15
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.03,),

                      // Past Doctor Consultations
                      GestureDetector(
                        onTap: (){
                          selectedServiceDatabaseParentName = "consultations";
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChooseUser2()));

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.medical_services,size: 30,color: Colors.amber),

                                SizedBox(width: 15,),

                                Text(
                                  'Past Doctor Consultations',
                                  style: TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),

                            Icon(Icons.arrow_forward_ios),

                          ],
                        ),
                      ),

                      const SizedBox(height: 10,),

                      const Divider(
                        thickness: 1,
                      ),

                      const SizedBox(height: 20,),

                      // Past CI Consultations
                      GestureDetector(
                        onTap: (){
                          selectedService = "CI Consultation";
                          selectedServiceDatabaseParentName = "CIConsultations";
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ChooseUser2()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.contact_support,size: 30,color: Colors.lightBlueAccent),

                                SizedBox(width: 15,),

                                Text(
                                  'Past CI Consultations',
                                  style: TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),

                            Icon(Icons.arrow_forward_ios),

                          ],
                        ),
                      ),

                      const SizedBox(height: 10,),

                      const Divider(
                        thickness: 1,
                      ),

                      const SizedBox(height: 10,),

                      // Healthcare Packages
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.health_and_safety,size: 30,color: Colors.redAccent),

                              SizedBox(width: 15,),

                              Text(
                                'Health Care Packages',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),

                          Icon(Icons.arrow_forward_ios),

                        ],
                      ),

                      const SizedBox(height: 10,),

                      const Divider(
                        thickness: 1,
                      ),

                      const SizedBox(height: 10,),

                      // Offers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.local_offer,size: 30, color: Colors.green),

                              SizedBox(width: 15,),

                              Text(
                                'Offers and Referrals',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),

                          Icon(Icons.arrow_forward_ios),

                        ],
                      ),

                      const SizedBox(height: 10,),

                      const Divider(
                        thickness: 1,
                      ),

                      const SizedBox(height: 10,),

                      // Contact us
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.phone,size: 30,color: Colors.purple),

                              SizedBox(width: 15,),

                              Text(
                                'Contact Us',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),

                          Icon(Icons.arrow_forward_ios),

                        ],
                      ),

                      const SizedBox(height: 10,),

                      const Divider(
                        thickness: 1,
                      ),

                      const SizedBox(height: 10,),

                      // Contact Us
                      GestureDetector(
                        onTap: (){
                          firebaseAuth.signOut();
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SplashScreen()), (Route<dynamic> route) => false);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.logout,size: 30,color: Colors.blue),

                                SizedBox(width: 15,),

                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),


                          ],
                        ),
                      ),

                      const SizedBox(height: 10,),

                      const Divider(
                        thickness: 1,
                      ),

                      const SizedBox(height: 10,),

                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
