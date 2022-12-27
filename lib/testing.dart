import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrz_parser/mrz_parser.dart';
import 'package:image_cropper/image_cropper.dart';


class MRZTester extends StatefulWidget {
  const MRZTester({Key? key}) : super(key: key);

  @override
  State<MRZTester> createState() => _MRZTesterState();
}

class _MRZTesterState extends State<MRZTester> {
  TextEditingController nameTextEditingController = TextEditingController();
  String scannedText = '';
  String testText = 'Nothing';
  //XFile? imageFile;
  File? imageFile;
  CroppedFile? croppedImage;
  bool textScanning = false;
  String? fullImage;
  List<String> list = [];


  // PickImage for patient
  Future pickImageForPatient(ImageSource source) async {
    try{
      final pickedImage = await ImagePicker().pickImage(source: source);
      if(pickedImage!=null){
        textScanning = true;
        File? img = File(pickedImage.path);
        croppedImage = await ImageCropper().cropImage(sourcePath: img.path,aspectRatio: const CropAspectRatio(ratioX: 30, ratioY: 4));
        if(croppedImage == null) {
          img =  null;
        }
        else{
          img = File(croppedImage!.path);
        }
        //imageFile = pickedImage;
        imageFile = img;
        setState(() {});
        getRecognisedText(imageFile!);
      }
    }

    catch(e){
      print(e);
      textScanning = false;
      imageFile = null;
      scannedText = e.toString();
      setState(() {});
    }

  }

  Future<File?> cropImage({required File imageFile}) async {
    croppedImage = await ImageCropper().cropImage(sourcePath: imageFile.path,aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 19));
    if(croppedImage == null) {
      return null;
    }
    else{
      return File(croppedImage!.path);
    }
  }


  void getRecognisedText(File image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
    scannedText = "";
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text;
        list.add(line.text);
        /*list = ((line.text).split(':'));
        if(list[0] == "Name"){
          setState(() {
            nameTextEditingController.text = list[1].trim();
          });
        }

        else{
        }*/
      }
      scannedText = scannedText + '\n\n';
    }
    textScanning = false;
    setState(() {});
    mrzScanner();
  }

  void mrzScanner(){
    print(list[0]);
    final mrz = [
      "${list[0]}<<<<<<<<<<<<<<<<<<",
      list[1]
    ];

    // Alternatively use parse and catch MRZException descendants
    try {
      final result = MRZParser.parse(mrz);
      setState((){
        testText = result.surnames;
      });

    }

    on MRZException catch(e) {
      print(e);
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameTextEditingController.addListener(() => setState(() {}));

  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Column(
                children: [
                  Image.asset(
                    "assets/visaInvitationImages/Visa_Image-1.jpg",
                  ),

                  const SizedBox(height: 15,),

                  Text(
                    "Visa Form",
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black
                    ),
                  ),

                  const SizedBox(height: 10,),

                  Image.asset(
                    "assets/visaInvitationImages/passport.png",
                    width: 80,
                  ),

                  const SizedBox(height: 30,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Attach your NID",
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
                        "Please attach image of your front\npage of NID",
                        style: GoogleFonts.montserrat(
                            fontSize: 15,
                            color: Colors.grey
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10,),

                  // Uploaded Image Container
                  Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (textScanning) const CircularProgressIndicator(),
                          if (!textScanning && imageFile == null)
                            Container(
                              width: 250,
                              height: 250,
                              color: Colors.grey[200]!,
                            ),
                          if (imageFile != null) Image.file(File(imageFile!.path)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      onPrimary: Colors.blue,
                                      shadowColor: Colors.grey[200],
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0)),
                                    ),
                                    onPressed: () {
                                      pickImageForPatient(ImageSource.gallery);

                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.image,
                                            size: 30,
                                          ),
                                          Text(
                                            "Gallery",
                                            style: TextStyle(
                                                fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),

                              Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  padding: const EdgeInsets.only(top: 10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      onPrimary: Colors.blue,
                                      shadowColor: Colors.grey[200],
                                      elevation: 10,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0)),
                                    ),
                                    onPressed: () {
                                      pickImageForPatient(ImageSource.camera);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.camera_alt,
                                            size: 30,
                                          ),
                                          Text(
                                            "Camera",
                                            style: TextStyle(
                                                fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          Text(
                            scannedText + "\n" + testText,
                            style: const TextStyle(fontSize: 20),
                          )
                        ],
                      )),
                ],
              )

          ),
        ),
      ),
    );
  }
}

