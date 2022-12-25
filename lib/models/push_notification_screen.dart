import 'dart:async';

import 'package:app/consultant_screens/ci_consultations.dart';
import 'package:app/consultant_screens/telemedicine_consultations.dart';
import 'package:app/doctor_screens/doctor_live_consultations.dart';
import 'package:app/our_services/ci_consultation/consultation_history.dart';
import 'package:app/our_services/doctor_live_consultation/history_screen.dart';
import 'package:app/our_services/doctor_live_consultation/history_screen_details.dart';
import 'package:app/widgets/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';
import '../widgets/push_notification_dialog_doctor.dart';
import '../widgets/push_notification_dialog_select_schedule.dart';
import 'consultation_payload_model.dart';

class PushNotificationScreen extends StatefulWidget {
  final String payload;
  const PushNotificationScreen({
        Key? key,
        required this.payload,
  }) : super(key: key);


  @override
  State<PushNotificationScreen> createState() => _PushNotificationScreenState();
}

class _PushNotificationScreenState extends State<PushNotificationScreen> {
  late ConsultationPayloadModel? p = ConsultationPayloadModel.fromJsonString(widget.payload);

  void loadScreenForPatient(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "message");
        }
    );

    if(selectedService == "Doctor Live Consultation"){
      Timer(const Duration(seconds: 2),()  {
        Navigator.pop(context);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HistoryScreen()), (Route<dynamic> route) => false);
      });
    }

    else{
      Timer(const Duration(seconds: 2),()  {
        Navigator.pop(context);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const ConsultationHistory()), (Route<dynamic> route) => false);
      });
    }

  }

  void loadScreenForDoctor(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "message");
        }
    );

    Timer(const Duration(seconds: 2),()  {
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const DoctorLiveConsultation()), (Route<dynamic> route) => false);
    });
  }

  void loadScreenForConsultant(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return ProgressDialog(message: "message");
        }
    );

    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const CIConsultations()), (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero,(){
      if(loggedInUser == "Patient"){
        patientId = p!.patientId;
        selectedService = p!.selectedServiceName;
        consultationId = p!.consultationId;
        loadScreenForPatient();
      }

      else if(loggedInUser == "Doctor"){
        consultationId = p!.consultationId;
        selectedService = p!.selectedServiceName;
        loadScreenForDoctor();
      }

      else if(loggedInUser == "Consultant"){
        consultationId = p!.consultationId;
        selectedService = p!.selectedServiceName;
        loadScreenForConsultant();
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade500,
    );
  }
}
