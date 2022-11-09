import 'package:app/global/global.dart';
import 'package:app/main_screen.dart';
import 'package:app/service_file/local_notification_service.dart';
import 'package:app/splash_screen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../models/doctor_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  late final LocalNotificationService service;

  void listenToNotification(){
    service.onNotificationClick.stream.listen(onNotificationListener);
  }

  void onNotificationListener(String? payload){
    if(payload!=null && payload.isNotEmpty){
      Fluttertoast.showToast(msg: "Payload:" + payload);
      //Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
    }
    else{
      //
    }
  }
  

  @override
  void initState() {
    // TODO: implement initState
    service = LocalNotificationService();
    service.intialize();
    listenToNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            await service.showNotification(id: 0, title: 'Notification Title', body: "body");
          },

          child: const Text(
              "Show Local Notification"
          ),
        ),

        ElevatedButton(
          onPressed: () async {
            //await service.showScheduledNotification(id: 0, title: 'Appointment reminder', body: "You have appointment now\nPlease Click here to join now", seconds: 1, payload: "You just took water! Huurray!", dateTime: '08-11-2022 18:27:00');
          },

          child: const Text(
              "Show Scheduled Notification"
          ),
        ),

        ElevatedButton(
          onPressed: () async{
            await service.showNotificationWithPayload(id: 0, title: 'Appointment reminder', body: "You have appointment now\nplease click here to join now", payload: "Hello Payload", seconds: 1);
          },

          child: const Text(
              "Show Notification with payload"
          ),
        ),

        ElevatedButton(
          onPressed: () {
            firebaseAuth.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
          },

          child: const Text(
              "Logout"
          ),
        ),
      ],

    );
  }
}

