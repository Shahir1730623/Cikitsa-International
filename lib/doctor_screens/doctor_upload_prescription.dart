import 'dart:async';
import 'dart:io';

import 'package:app/global/global.dart';
import 'package:app/widgets/prescription_dialog.dart';
import 'package:app/widgets/prescription_dialog_doctor.dart';
import 'package:app/widgets/upload_image_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../widgets/progress_dialog.dart';

class DoctorUploadPrescription extends StatefulWidget {
  const DoctorUploadPrescription({Key? key}) : super(key: key);

  @override
  State<DoctorUploadPrescription> createState() => _DoctorUploadPrescriptionState();
}

class _DoctorUploadPrescriptionState extends State<DoctorUploadPrescription> {
  //String imageUrl = "";
  XFile? imageFile;

  Future pickImage() async {
    try{
      // Pick an Image
      var imageSource =  await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const UploadImageDialog();
          }
      );
      final pickedImage = await ImagePicker().pickImage(source: imageSource);
      if(pickedImage!=null){
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return ProgressDialog(message: "");
            }
        );
        imageFile = pickedImage;
        firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('consultationImages/'+ consultationId! + "/doctorPrescription.png" );

        // Upload the image to firebase storage
        try{
          await reference.putFile(File(imageFile!.path));
          //imageUrl = await reference.getDownloadURL();
        }

        catch(e){
          print(e);
        }

        Navigator.pop(context);

      }
    }

    catch(e){
      imageFile = null;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[100],
                    foregroundImage: NetworkImage(
                      currentDoctorInfo!.doctorImageUrl!,
                    ),
                  )
              ),

              SizedBox(height: height * 0.03),
              Text(
                "Dr. " + currentDoctorInfo!.doctorFirstName! + " " + currentDoctorInfo!.doctorLastName!,
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),

              SizedBox(height: height * 0.01),

              Text(
                currentDoctorInfo!.specialization!,
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 20),
              ),

              SizedBox(height: height * 0.01),

              Text(
                currentDoctorInfo!.degrees!,
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 15
                ),
              ),

              const Divider(
                height: 50,
                thickness: 1,
                color: Colors.black,
              ),

              Text(
                "Please upload the prescription",
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),

              SizedBox(height: height * 0.03),

              GestureDetector(
                onTap: () async {
                  await pickImage();
                  var snackBar = const SnackBar(content: Text("Prescription uploaded successfully"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const PrescriptionDialogDoctor();
                      }
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                      width: 0.8,
                      style: BorderStyle.solid,
                    ),
                  ) ,
                  child: Row(
                      children: [
                        Image.asset("assets/add-image.png",width: 45,),

                        const SizedBox(width: 10,),

                        Expanded(
                          child: Text(
                              "Upload prescription",
                              style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                              )
                          ),
                        ),
                      ]
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
