import 'dart:async';
import 'dart:io';

import 'package:app/global/global.dart';
import 'package:app/widgets/prescription_dialog_consultant.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../assistants/assistant_methods.dart';
import '../widgets/prescription_dialog_doctor.dart';
import '../widgets/progress_dialog.dart';
import '../widgets/upload_image_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ConsultantUploadPrescription extends StatefulWidget {
  const ConsultantUploadPrescription({Key? key}) : super(key: key);

  @override
  State<ConsultantUploadPrescription> createState() => _ConsultantUploadPrescriptionState();
}

class _ConsultantUploadPrescriptionState extends State<ConsultantUploadPrescription> {
  @override
  XFile? imageFile;

  setCIConsultationInfoToCompleted(){
    FirebaseDatabase.instance.ref()
        .child("Consultant")
        .child(currentFirebaseUser!.uid)
        .child("CIConsultations")
        .child(consultationId!)
        .child("consultationStatus")
        .set("Completed");
  }

  Future pickAndSaveImage() async {
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
        firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('CIConsultationImages/'+ consultationId! + "/consultantPrescription.png" );

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

  getRegistrationTokenForUserAndSendPrescriptionNotification(){
    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(userId!)
        .child("tokens").once().then((snapData) async {
      DataSnapshot snapshot = snapData.snapshot;
      if(snapshot.value != null){
        String deviceRegistrationToken = snapshot.value.toString();
        // send notification now
        await AssistantMethods.sendPrescriptionPushNotificationToPatientNow(deviceRegistrationToken, selectedCIConsultationInfo!.patientId!, "CI Consultation", context);
        Fluttertoast.showToast(msg: "Notification sent to patient successfully");
      }

      else{
        Fluttertoast.showToast(msg: "Error sending notifications");
      }
    });
  }

  void loadScreen(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "Fetching data...");
        }
    );

    Timer(const Duration(seconds: 1),()  {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      loadScreen();
      setCIConsultationInfoToCompleted();
    });

  }

  Future<bool> showExitPopup() async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Please upload the CI report before exiting'),
        actions:[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child:const Text('Ok'),
          ),

        ],
      ),
    )??false; //if showDialog had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: showExitPopup,
      child: SafeArea(
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
                        currentConsultantInfo!.imageUrl!,
                      ),
                    )
                ),

                SizedBox(height: height * 0.03),
                Text(
                  currentConsultantInfo!.name!,
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),

                SizedBox(height: height * 0.01),

                Text(
                  "Consultant",
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 20
                  ),
                ),

                const Divider(
                  height: 50,
                  thickness: 1,
                  color: Colors.black,
                ),

                Text(
                  "Please upload the CI Consultation Report",
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),

                SizedBox(height: height * 0.03),

                GestureDetector(
                  onTap: () async {
                    await pickAndSaveImage();
                    getRegistrationTokenForUserAndSendPrescriptionNotification();
                    var snackBar = const SnackBar(content: Text("CI consultation report uploaded successfully"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const PrescriptionDialogConsultant();
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
                                "Upload consultation report",
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
      ),
    );
  }
}
