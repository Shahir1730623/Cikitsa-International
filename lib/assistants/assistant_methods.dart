import 'dart:convert';

import 'package:app/models/consultant_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import '../global/global.dart';
import '../models/doctor_model.dart';
import '../models/push_notification_screen.dart';
import '../models/user_model.dart';

class AssistantMethods{
  static void readOnlineUserCurrentInfo() async {
    currentFirebaseUser = firebaseAuth.currentUser;
    DatabaseReference reference = FirebaseDatabase.instance.ref()
        .child("Users").child(currentFirebaseUser!.uid);

    reference.once().then((snap) {
      final snapshot = snap.snapshot;
      if (snapshot.exists) {
        currentUserInfo = UserModel.fromSnapshot(snapshot);
        loggedInUser = "Patient";
      }
    });

    DatabaseReference reference2 = FirebaseDatabase.instance.ref()
        .child("Doctors").child(currentFirebaseUser!.uid);

    reference2.once().then((snap) {
      final snapshot = snap.snapshot;
      if (snapshot.exists) {
        currentDoctorInfo = DoctorModel.fromSnapshot(snapshot);
        loggedInUser = "Doctor";
      }
    });

    DatabaseReference reference3 = FirebaseDatabase.instance.ref()
        .child("Consultant").child(currentFirebaseUser!.uid);

    reference3.once().then((snap) {
      final snapshot = snap.snapshot;
      if (snapshot.exists) {
        currentConsultantInfo = ConsultantModel.fromSnapshot(snapshot);
        loggedInUser = "Consultant";
      }
    });

  }

  static sendConsultationPushNotificationToPatientNow(String deviceRegistrationToken, String patientId, String selectedService,BuildContext context){
    Map<String,String> headerNotification = {
      'Content-Type' : 'application/json',
      'Authorization' : cloudMessagingServerToken,
    };

    Map bodyNotification = {
      "notification":{
        "body": "You have appointment now. Click here to join",
        "title" : "Appointment reminder"
      },

      "priority": "high",

      "data" : {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id" : "1",
        "status" : "done",
        "consultation_id" : consultationId,
        "selected_service" : selectedService,
        "patient_id" : patientId,
        "dateTime" : dateTime
      },

      "to" : deviceRegistrationToken
    };

    // Work of postman to send notification
    var responseNotification = post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(bodyNotification),
    );
  }

  // Generates Push Notification and sends it
  static sendConsultationPushNotificationToDoctorNow(String deviceRegistrationToken,BuildContext context){
    Map<String,String> headerNotification = {
      'Content-Type' : 'application/json',
      'Authorization' : cloudMessagingServerToken,
    };

    Map bodyNotification = {
      "notification":{
        "body": "You have appointment now. Click here to join",
        "title" : "Appointment reminder"
      },

      "priority": "high",

      "data" : {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id" : "1",
        "status" : "done",
        "consultation_id" : consultationId,
      },

      "to" : deviceRegistrationToken
    };

    // Work of postman to send notification
    var responseNotification = post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(bodyNotification),
    );
  }


  static sendInvitationPushNotificationToPatientNow(String deviceRegistrationToken, String invitationId, String patientId,BuildContext context){
    Map<String,String> headerNotification = {
      'Content-Type' : 'application/json',
      'Authorization' : cloudMessagingServerToken,
    };

    Map bodyNotification = {
      "notification":{
        "body": "Your visa invitation letter is uploaded by doctor. Click here to see",
        "title" : "Visa Invitation Letter Uploaded"
      },

      "priority": "high",

      "data" : {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id" : "1",
        "status" : "done",
        "visa_invitation_id" : invitationId,
        "patient_Id" : patientId,
      },

      "to" : deviceRegistrationToken
    };

    // Work of postman to send notification
    var responseNotification = post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(bodyNotification),
    );
  }



}