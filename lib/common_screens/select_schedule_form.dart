import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:app/common_screens/payment_screen.dart';
import 'package:app/models/consultation_payload_model.dart';
import 'package:app/our_services/doctor_live_consultation/history_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../global/global.dart';
import '../models/push_notification_screen.dart';
import '../service_file/local_notification_service.dart';
import '../widgets/progress_dialog.dart';
import 'choose_user.dart';
import '../service_file/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SelectSchedule extends StatefulWidget {
  const SelectSchedule({Key? key}) : super(key: key);

  @override
  State<SelectSchedule> createState() => _SelectScheduleState();
}

class _SelectScheduleState extends State<SelectSchedule> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController relationTextEditingController = TextEditingController();
  TextEditingController problemTextEditingController = TextEditingController();
  List<String> reasonOfVisitTypesList = [
    "Cancer",
    "Heart Problem",
    "Skin problem",
    "Liver problem",
    "Broken bones"
  ];
  String? selectedReasonOfVisit;

  // Image Storage
  List<File> imageList = [];
  final Storage storage = Storage();

  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  String? formattedDate,formattedTime;
  int dateCounter = 0;
  int timeCounter = 0;
  bool flag = false;
  String selectedTime = " ";

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

        pickedImages.forEach((image) {
          imageList.add(File(image.path));
        });
        setState(() {});
        Navigator.pop(context);

      }
    }

    catch(e){
      print(e);
    }
  }

  Future<void> uploadFile(File file) async {
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('consultationImages/'+ consultationId! + "/" + idGenerator() + ".png" );

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
        flag = true;
      });
    }

    else{
      print("Date is not selected");
    }

  }

  /*pickTime() async {
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
  }*/

  /*saveConsultationInfo() async {
    DatabaseReference reference = FirebaseDatabase.instance.ref().child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId!);

    consultationId = idGenerator();
    if(selectedService == "CI Consultation"){
      Map CIConsultationInfoMap = {
        "id" : consultationId,
        "consultantName" : "TBA",
        "date" : formattedDate,
        "time" : selectedTime,
        "selectedCountry" : selectedCountry,
        "consultantFee" : "500",
        "consultationType" : "Scheduled",
        "visitationReason": selectedReasonOfVisit,
        "problem": problemTextEditingController.text.trim(),
        "payment" : "Pending"
      };

      reference.child(selectedServiceDatabaseParentName!).child(consultationId!).set(CIConsultationInfoMap);
    }

    else{
      Map consultationInfoMap = {
        "id" : consultationId,
        "date" : formattedDate,
        "time" : selectedTime,
        "doctorId" : selectedDoctorInfo!.doctorId,
        "doctorName" : "Dr. " + selectedDoctorInfo!.doctorFirstName! + " " + selectedDoctorInfo!.doctorLastName!,
        "doctorImageUrl" : selectedDoctorInfo!.doctorImageUrl,
        "specialization" : selectedDoctorInfo!.specialization,
        "doctorFee" : selectedDoctorInfo!.fee,
        "workplace" : selectedDoctorInfo!.workplace,
        "consultationType" : "Scheduled",
        "visitationReason": selectedReasonOfVisit,
        "problem": problemTextEditingController.text.trim(),
        "payment" : "Pending"
      };

      reference.child(selectedServiceDatabaseParentName!).child(consultationId!).set(consultationInfoMap);
    }

  }*/


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    problemTextEditingController.addListener(() => setState(() {}));
    relationTextEditingController.addListener(() => setState(() {}));
    consultationId = idGenerator();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFC7E9F0), Color(0xFFFFFFFF)]
              )
          ),

          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Book Now
                          Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      color: Colors.blue
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              SizedBox(width: height * 0.08),

                              Row(
                                children: [
                                  Text(
                                    "Book Now",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),

                          SizedBox(height: height * 0.03,),

                          // Date
                          Text(
                            "Date",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                          SizedBox(height: height * 0.01,),
                          // Date Picker
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey.shade200,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    "assets/medical.png",
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 10,),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      pickDate();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: (Colors.white70),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    child: Text(
                                      (dateCounter != 0) ? '$formattedDate' :  "Select date",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                          SizedBox(height: height * 0.03,),

                          Row(
                            children: const [
                              Icon(
                                Icons.access_time_outlined,
                                color: Colors.black,
                                size: 25,
                              ),
                              SizedBox(width: 10,),

                              Text(
                                "Available Slots",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: height * 0.01,),

                          (flag == true) ?
                          Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 0),
                            child: GridView(gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 100.0,
                              mainAxisSpacing: 20.0,
                              crossAxisSpacing: 20.0,
                              childAspectRatio: 2.0,
                            ),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectedTime = "6:39 PM";
                                    });
                                  },

                                  child: (selectedTime == "6:39 PM") ?
                                  Container(
                                    padding: const EdgeInsets.only(top: 0,left: 5,right: 5,bottom: 0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1.5,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        selectedTime,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),

                                  ) : Padding(
                                    padding: const EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 0),
                                    child: Text(
                                      "6:39 PM",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectedTime = "8:20 PM";
                                    });
                                  },
                                  child: (selectedTime == "8:20 PM") ?
                                  Container(
                                    padding: const EdgeInsets.only(top: 0,left: 5,right: 5,bottom: 0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1.5,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        selectedTime,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),

                                  ) : Padding(
                                    padding: const EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 0),
                                    child: Text(
                                      "8:20 PM",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectedTime = "8:40 PM";
                                    });
                                  },

                                  child: (selectedTime == "8:40 PM") ?
                                  Container(
                                    padding: const EdgeInsets.only(top: 0,left: 5,right: 5,bottom: 0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1.5,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        selectedTime,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),

                                  ) :  Padding(
                                    padding: const EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 0),
                                    child: Text(
                                      "8:40 PM",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectedTime = "9:00 PM";
                                    });
                                  },

                                  child: (selectedTime == "9:00 PM") ?
                                  Container(
                                    padding: const EdgeInsets.only(top: 0,left: 5,right: 5,bottom: 0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1.5,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        selectedTime,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),

                                  ) : Padding(
                                    padding: const EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 0),
                                    child: Text(
                                      "9:00 PM",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: (){
                                    setState((){
                                      selectedTime = "9:20 PM";
                                    });
                                  },

                                  child: (selectedTime == "9:20 PM") ?
                                  Container(
                                    padding: const EdgeInsets.only(top: 0,left: 5,right: 5,bottom: 0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1.5,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        selectedTime,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),

                                  ) : Padding(
                                    padding: const EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 0),
                                    child: Text(
                                      "9:20 PM",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),

                                GestureDetector(
                                  onTap: (){
                                    setState((){
                                      selectedTime = "9:40 PM";
                                    });
                                  },
                                  child: (selectedTime == "9:40 PM") ?
                                  Container(
                                    padding: const EdgeInsets.only(top: 0,left: 5,right: 5,bottom: 0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1.5,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        selectedTime,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),

                                  ) :  Padding(
                                    padding: const EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 0),
                                    child: Text(
                                      "9:40 PM",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ) : Container(),

                          SizedBox(height: height * 0.05,),

                          // Reason of Consultation
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
                              } else
                                return null;
                            },
                          ),


                          SizedBox(height: height * 0.01,),

                          SizedBox(height: height * 0.02,),

                          // Image Picker
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

                          // Display Image Container
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
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
                          ),


                          SizedBox(height: height * 0.02,),

                          // Consultation fee
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Consultation Fee",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                ),
                              ),
                              Text(
                                selectedDoctorInfo == null ? "500" : (selectedDoctorInfo!.fee!),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: height * 0.02,),

                          // Button
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

                                Timer(const Duration(seconds: 2),()  {
                                  Navigator.pop(context);
                                  var df = DateFormat.jm().parse(selectedTime);
                                  formattedDate = DateFormat('yyyy-MM-dd').format(date);
                                  formattedTime = DateFormat('HH:mm').format(df);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(formattedDate: formattedDate, formattedTime: formattedTime, visitationReason: selectedReasonOfVisit, problem: problemTextEditingController.text.trim(), selectedCenter: '',)));
                                });
                              },

                              style: ElevatedButton.styleFrom(
                                  primary: (Colors.blue),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),

                              child: Text(
                                "Book Now" ,
                                style: GoogleFonts.montserrat(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: height * 0.03),

                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),



        ),
      ),
    );
  }
}
