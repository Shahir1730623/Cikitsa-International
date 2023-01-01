import 'dart:async';
import 'dart:io';

import 'package:app/common_screens/payment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../global/global.dart';
import '../../widgets/progress_dialog.dart';
import '../../widgets/upload_image_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MedicalDocumentsForm extends StatefulWidget {
  const MedicalDocumentsForm({Key? key}) : super(key: key);

  @override
  State<MedicalDocumentsForm> createState() => _MedicalDocumentsFormState();
}

class _MedicalDocumentsFormState extends State<MedicalDocumentsForm> {
  XFile? imageFile;
  List<File> imageList = [];
  TextEditingController problemTextEditingController = TextEditingController();

  String? selectedCenter;
  List<String> visaCenterList = [
    "Dhaka",
    "Syhlet",
    "Barishal",
    "Chattogram",
  ];

  String? selectedReasonOfVisit;
  List<String> reasonOfVisitTypesList = [
    "Cancer",
    "Heart Problem",
    "Skin problem",
    "Liver problem",
    "Broken bones"
  ];


  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  String? formattedDate,formattedTime;
  int dateCounter = 0;
  int timeCounter = 0;


  pickDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), //get today's date
        firstDate:DateTime.now(), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2030)
    );

    if(pickedDate != null ){
      setState(() {
        date = pickedDate;
        formattedDate = DateFormat('dd-MM-yyyy').format(date);
        Fluttertoast.showToast(msg: formattedDate.toString());
        dateCounter++;
      });
    }

    else{
      print("Date is not selected");
    }

  }

  pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()), //get today's date
    );

    if(pickedTime != null ){
      setState(() {
        time = pickedTime;
        formattedTime = time.format(context);
        Fluttertoast.showToast(msg: formattedTime.toString());
        timeCounter++;
      });
    }
  }

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  Future pickImages() async {
    try{
      final pickedImages = await ImagePicker().pickMultiImage();
      if(pickedImages != null){
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return ProgressDialog(message: "");
            }
        );
        //var file = await ImageCropper().cropImage(sourcePath: pickedImage.path,aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
        pickedImages.forEach((image) {
          imageList.add(File(image.path));
        });
        setState(() {});
        Navigator.pop(context);

      }
    }

    catch(e){
      imageFile = null;
      setState(() {});
    }
  }

  Future<void> uploadFile(File file) async {
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('invitationImages/'+ invitationId! + "/documents/"+ idGenerator() + ".png" );

    // Upload the image to firebase storage
    try{
      await reference.putFile(File(file.path));
      //imageUrl = await reference.getDownloadURL();
    }

    catch(e){
      print(e);
    }

    //String url = await reference.getDownloadURL();
    //return url;
  }

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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/visaInvitationImages/Visa_Image-1.jpg",
                ),

                const SizedBox(height: 15,),

                Text(
                  "Medical Form",
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black
                  ),
                ),

                const SizedBox(height: 10,),

                Image.asset(
                  "assets/visaInvitationImages/health-check.png",
                  width: 80,
                ),

                const SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Attach your Medical\nDocuments",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Please attach images of your past reports\nand prescriptions",
                      style: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: Colors.grey
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10,),

                // Uploaded Image Container
                GestureDetector(
                  onTap: () async {
                    await pickImages();
                    var snackBar = const SnackBar(content: Text("Uploaded successfully"));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.black,
                        width: 0.5,
                        style: BorderStyle.solid,
                      ),
                    ) ,
                    child: Row(
                        children: [
                          Image.asset("assets/add-image.png",width: 40,),

                          const SizedBox(width: 10,),

                          Expanded(
                            child: Text(
                                "Upload report and previous prescriptions",
                                style: GoogleFonts.montserrat(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                )
                            ),
                          ),
                        ]
                    ),
                  ),
                ),

                Container(
                  width: Get.width,
                  height: 150,
                  child: imageList.isEmpty
                      ? const Center(
                    child: Text("No Images found"),
                  )
                      : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, i) {
                      return Container(
                          width: 100,
                          margin: EdgeInsets.only(right: 10),
                          height: 100,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(2)),
                          child: Image.file(
                            imageList[i],
                            fit: BoxFit.cover,
                          ));
                    },

                    itemCount: imageList.length,
                  ),
                ),

                const SizedBox(height: 30,),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Visa Center",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      "Select your desirable visa centre",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.shade200,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              "assets/visaInvitationImages/workplace.png",
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: DropdownButtonFormField(
                            decoration:  InputDecoration(
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ) ,
                            isExpanded: true,
                            iconSize: 30,
                            dropdownColor: Colors.white,
                            hint: const Text(
                              "Select the centre",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                            value: selectedCenter,
                            onChanged: (newValue) {
                              setState(() {
                                selectedCenter = newValue.toString();
                              });
                            },
                            items: visaCenterList.map((center) {
                              return DropdownMenuItem(
                                value: center,
                                child: Text(
                                  center,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20,),

                    Text(
                      "Reason of Consultation",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                    SizedBox(height: height * 0.01,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey.shade200,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              "assets/advisor.png",
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: DropdownButtonFormField(
                            decoration:  InputDecoration(
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ) ,
                            isExpanded: true,
                            iconSize: 30,
                            dropdownColor: Colors.white,
                            hint: const Text(
                              "Specify the reason",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                            ),
                            value: selectedReasonOfVisit,
                            onChanged: (newValue) {
                              setState(() {
                                selectedReasonOfVisit = newValue.toString();
                              });
                            },
                            items: reasonOfVisitTypesList.map((reason) {
                              return DropdownMenuItem(
                                value: reason,
                                child: Text(
                                  reason,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: height * 0.03,),

                    // Describe the problem
                    Text(
                      "Describe the problem",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),
                    ),
                    SizedBox(height: height * 0.01,),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: problemTextEditingController,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        labelText: "Write here",
                        hintText: "Write here",
                        prefixIcon: IconButton(
                          icon: Image.asset(
                            "assets/edit-info.png",
                            height: 18,
                          ),
                          onPressed: () {},
                        ),
                        suffixIcon: problemTextEditingController.text.isEmpty
                            ? Container(width: 0)
                            : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () =>
                              problemTextEditingController.clear(),
                        ),
                        enabledBorder:  OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        hintStyle:
                        const TextStyle(color: Colors.grey, fontSize: 15),
                        labelStyle:
                        const TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "The field is empty";
                        } else {
                          return null;
                        }
                      },
                    ),

                  ],
                ),

                SizedBox(height: height * 0.05,),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: ()  async {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context){
                            return ProgressDialog(message: "Please wait...");
                          }
                      );
                      for (int i = 0; i < imageList.length; i++) {
                        await uploadFile(imageList[i]);
                        //downloadUrls.add(url);
                      }

                      Timer(const Duration(seconds: 5),()  {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(formattedDate: '', formattedTime: '', visitationReason: selectedReasonOfVisit, problem: problemTextEditingController.text.trim(), selectedCenter: selectedCenter,)));
                      });


                    },

                    style: ElevatedButton.styleFrom(
                        primary: (Colors.blue),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),

                    child: Text(
                      "Continue" ,
                      style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20,),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
