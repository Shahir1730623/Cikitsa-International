import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../assistants/assistant_methods.dart';
import '../global/global.dart';

class UserProfileScreenEdit extends StatefulWidget {
  const UserProfileScreenEdit({Key? key}) : super(key: key);

  @override
  State<UserProfileScreenEdit> createState() => _UserProfileScreenEditState();
}

class _UserProfileScreenEditState extends State<UserProfileScreenEdit> {

  TextEditingController nameTextEditingController = TextEditingController(text: currentUserInfo!.name!);
  TextEditingController emailTextEditingController = TextEditingController(text: currentUserInfo!.email);
  TextEditingController phoneTextEditingController = TextEditingController(text: currentUserInfo!.phone!);

  updateUserInformation(){
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("Users");
    reference.child(currentFirebaseUser!.uid).once().then((userKey) {
      final snapshot = userKey.snapshot;
      if (snapshot.exists) {
        reference.child(currentFirebaseUser!.uid).child("name").set(nameTextEditingController.text);
        reference.child(currentFirebaseUser!.uid).child("email").set(emailTextEditingController.text);
        reference.child(currentFirebaseUser!.uid).child("phone").set(phoneTextEditingController.text);

        setState(() {
          currentUserInfo!.name = nameTextEditingController.text;
          currentUserInfo!.email = emailTextEditingController.text;
          currentUserInfo!.phone = phoneTextEditingController.text;
        });
      }

      firebaseAuth.currentUser != null ? AssistantMethods.readOnlineUserCurrentInfo() : null;

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameTextEditingController.addListener(() => setState(() {}));
    emailTextEditingController.addListener(() => setState(() {}));
    phoneTextEditingController.addListener(() => setState(() {}));

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
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back and Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Transform.translate(
                          offset: const Offset(-15, 0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
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
                        ),

                        Transform.translate(
                          offset: const Offset(20, 0),
                          child: Image.asset(
                            "assets/Logo.png",
                            width: 100,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: height * 0.05,
                    ),

                    // Profile Image CircleAvatar
                    DottedBorder(
                      padding: EdgeInsets.all(10),
                      borderType: BorderType.Oval,
                      radius: const Radius.circular(20),
                      color: Colors.blue,
                      dashPattern: [25, 10],
                      strokeWidth: 3,
                      child: (currentUserInfo!.imageUrl != null)
                          ? CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.lightBlue,
                        foregroundImage: NetworkImage(
                          currentUserInfo!.imageUrl!,
                        ),
                      )
                          : CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.grey.shade200,
                          child: const Text(
                            "Upload Image",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),
                          )
                      ),
                    ),

                    // Edit Circle
                    Container(
                      transform: Matrix4.translationValues(0.0, -35.0, 0.0),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50)),
                          child: IconButton(
                              onPressed: () {
                                //
                              },
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.grey.shade400,
                              ))),
                    ),

                    Transform.translate(
                      offset: const Offset(0, -20),
                      child: Text(
                        currentUserInfo!.name!,
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),

                    Transform.translate(
                      offset: const Offset(0, -10),
                      child: Text(
                        currentUserInfo!.phone!,
                        style: GoogleFonts.montserrat(
                            color: Colors.grey.shade500, fontSize: 15),
                      ),
                    ),

                    SizedBox(
                      height: height * 0.03,
                    ),

                    // Full name Container
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.5, color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(15)
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),

                          // Country Code
                          Icon(Icons.person,size: 30,),

                          const SizedBox(
                            width: 5,
                          ),

                          // Border
                          const Text(
                            "|",
                            style: TextStyle(fontSize: 40, color: Colors.black),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          // Full Name TextField
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              maxLines: null,
                              controller: nameTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Full Name",
                                hintText: "Full Name",
                                suffixIcon: nameTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      nameTextEditingController.clear(),
                                ),

                                hintStyle:
                                const TextStyle(color: Colors.grey, fontSize: 16),
                                labelStyle:
                                const TextStyle(color: Colors.black, fontSize: 16),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The field is empty";
                                }

                                else {
                                  return null;
                                }
                              },
                            ),
                          ),

                        ],
                      ),


                    ),

                    SizedBox(
                      height: height * 0.02,
                    ),

                    // Email Container
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.5, color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(15)
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),

                          // Country Code
                          Icon(Icons.email,size: 30,),

                          const SizedBox(
                            width: 5,
                          ),

                          // Border
                          const Text(
                            "|",
                            style: TextStyle(fontSize: 40, color: Colors.black),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          // Full Name TextField
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              maxLines: null,
                              controller: emailTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Email",
                                hintText: "Email",
                                suffixIcon: emailTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      emailTextEditingController.clear(),
                                ),

                                hintStyle:
                                const TextStyle(color: Colors.grey, fontSize: 15),
                                labelStyle:
                                const TextStyle(color: Colors.black, fontSize: 15),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The field is empty";
                                }

                                else {
                                  return null;
                                }
                              },
                            ),
                          )

                        ],
                      ),


                    ),

                    SizedBox(
                      height: height * 0.02,
                    ),

                    // Phone Container
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.5, color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(15)
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),

                          // Country Code
                          Icon(Icons.phone,size: 30,),

                          const SizedBox(
                            width: 5,
                          ),

                          // Border
                          const Text(
                            "|",
                            style: TextStyle(fontSize: 40, color: Colors.black),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          // Full Name TextField
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              maxLines: null,
                              controller: phoneTextEditingController,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Phone",
                                hintText: "Phone",
                                suffixIcon: phoneTextEditingController.text.isEmpty
                                    ? Container(width: 0)
                                    : IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () =>
                                      phoneTextEditingController.clear(),
                                ),

                                hintStyle:
                                const TextStyle(color: Colors.grey, fontSize: 15),
                                labelStyle:
                                const TextStyle(color: Colors.black, fontSize: 15),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "The field is empty";
                                }

                                else {
                                  return null;
                                }
                              },
                            ),
                          )

                        ],
                      ),

                    ),

                    SizedBox(height: height * 0.08,),

                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                          onPressed: () async {
                            updateUserInformation();
                            const snackBar = SnackBar(
                              content: Text('Information updated Successfully!'),
                              backgroundColor: (Colors.black),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          },
                          style: ElevatedButton.styleFrom(
                            primary: (Colors.blue),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: Icon(Icons.update),
                          label: Text(
                            "Update",
                            style: GoogleFonts.montserrat(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),)

                      ),
                    ),


                  ],
                ),
              )
            ],
          ),
        ),
    ));
  }
}
