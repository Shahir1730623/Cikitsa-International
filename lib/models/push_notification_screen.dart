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
          return PushNotificationDialogSelectSchedule();
        }
    );
  }

  void loadScreenForDoctor(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return PushNotificationDialogTalkToPatientNow();
        }
    );
  }

  void loadScreenForConsultant(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return PushNotificationDialogTalkToPatientNow();
        }
    );
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
        loadScreenForDoctor();
      }

      else if(loggedInUser == "Consultant"){
        consultationId = p!.consultationId;
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
