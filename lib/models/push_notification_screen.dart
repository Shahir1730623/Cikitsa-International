import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';
import '../widgets/push_notification_dialog.dart';
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

  void loadScreen(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return PushNotificationDialog();
        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero,(){
      patientId = p!.patientId;
      selectedService = p!.selectedServiceName;
      consultationId = p!.consultationId;
      loadScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade500,
    );
  }
}
