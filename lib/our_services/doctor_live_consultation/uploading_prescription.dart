import 'package:app/global/global.dart';
import 'package:app/widgets/prescription_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadingPrescription extends StatefulWidget {
  const UploadingPrescription({Key? key}) : super(key: key);

  @override
  State<UploadingPrescription> createState() => _UploadingPrescriptionState();
}

class _UploadingPrescriptionState extends State<UploadingPrescription> {
  void loadScreen() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return const PrescriptionDialog();
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      loadScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  //or 15.0
                  radius: 60,
                  backgroundColor: Colors.grey[100],
                  foregroundImage: NetworkImage(
                    selectedConsultationInfo!.doctorImageUrl!,
                  ),
                ),
              ),
              SizedBox(height: height * 0.05),
              Text(
                selectedConsultationInfo!.doctorName!,
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              SizedBox(height: height * 0.5),
              Text(
                "This may take several minutes",
                style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
