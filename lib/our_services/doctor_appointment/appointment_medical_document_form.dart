import 'dart:async';
import 'dart:io';

import 'package:app/global/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import '../../common_screens/payment_screen.dart';
import '../../widgets/progress_dialog.dart';

class AppointmentMedicalDocumentForm extends StatefulWidget {
  const AppointmentMedicalDocumentForm({Key? key}) : super(key: key);

  @override
  State<AppointmentMedicalDocumentForm> createState() => _AppointmentMedicalDocumentFormState();
}

class _AppointmentMedicalDocumentFormState extends State<AppointmentMedicalDocumentForm> {
  XFile? imageFile;
  List<File> imageList = [];
  bool state = false;
  final _formKey = GlobalKey<FormState>();

  String? selectedReasonOfVisit;
  List<String> reasonOfVisitTypesList = [
    "Cancer",
    "Heart Problem",
    "Skin problem",
    "Liver problem",
    "Broken bones"
  ];
  TextEditingController problemTextEditingController = TextEditingController();
  String? formattedDate,formattedDateTo;
  int dateCounter = 0;
  int dateCounter2 = 0;
  DateTime date = DateTime.now();
  DateTime date2 = DateTime.now();
  bool flag = false;
  bool flag2 = false;

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
        for (var image in pickedImages) {
          imageList.add(File(image.path));
        }

        state = true;
        setState(() {});
        Navigator.pop(context);

      }
    }

    catch(e){
      imageFile = null;
      setState(() {});
    }
  }

  pickDateFrom() async {
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
        dateCounter++;
        flag = true;
      });
    }

    else{
      print("Date is not selected");
    }
  }

  pickDateTo() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), //get today's date
        firstDate:DateTime.now(), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2030)
    );

    if(pickedDate != null ){
      setState(() {
        date2 = pickedDate;
        formattedDateTo = DateFormat('dd-MM-yyyy').format(date);
        dateCounter2++;
        flag2 = true;
      });
    }

    else{
      print("Date is not selected");
    }
  }

  Future<void> uploadFile(File file) async {
    firebase_storage.Reference reference = firebase_storage.FirebaseStorage.instance.ref('doctorAppointmentImages/'+ appointmentId! + "/documents/"+ idGenerator() + ".png");

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
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/doctorAppointment/blank_prescription.jpg",
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
                  "assets/doctorAppointment/paper.png",
                  width: 80,
                ),


                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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

                      SizedBox(
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
                          // From - Date
                          Text(
                            "From (Date)",
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
                                  child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Icon(Icons.calendar_month,color: Colors.black,),
                                  )),

                              const SizedBox(width: 10,),

                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      pickDateFrom();
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

                          Text(
                            "To (Date)",
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
                                child: const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Icon(
                                        Icons.calendar_month_outlined,
                                        color: Colors.black
                                    )
                                ),
                              ),

                              const SizedBox(width: 10,),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      pickDateTo();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: (Colors.white70),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    child: Text(
                                      (dateCounter2 != 0) ? '$formattedDateTo' :  "Select date",
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
                                  validator: (value) {
                                    if (value == null ||value.isEmpty) {
                                      return "Please select a reason";
                                    }
                                    else {
                                      return null;
                                    }
                                  },
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
                                  height: 25,
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
                              }

                              else {
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
                            if (_formKey.currentState!.validate() && state && (dateCounter != 0 && dateCounter2 != 0)){
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(formattedDate: formattedDate, formattedTime: '', visitationReason: selectedReasonOfVisit, problem: problemTextEditingController.text.trim(), selectedCenter: '',)));
                              });
                            }

                            else{
                              if(dateCounter ==  0){
                                var snackBar = const SnackBar(content: Text('Please select From date'));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }

                              else if(dateCounter2 ==  0){
                                var snackBar = const SnackBar(content: Text('Please select To date'));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }

                              else if(state ==  false){
                                var snackBar = const SnackBar(content: Text('Please upload passport photos'));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }

                              else{
                                var snackBar = const SnackBar(content: Text('Fill up the form correctly'));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }

                            }

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
                    ],
                  ),
                ),

                SizedBox(height: height * 0.03,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
