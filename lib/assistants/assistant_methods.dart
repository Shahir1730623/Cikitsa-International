import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import '../global/global.dart';
import '../models/doctor_model.dart';
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

  }

  // Retrieving device registration token
  static sendNotificationToDoctor(BuildContext context){
    FirebaseDatabase.instance.ref()
        .child("Doctors")
        .child(selectedDoctorInfo!.doctorId!)
        .child("tokens").once().then((snapData){
      DataSnapshot snapshot = snapData.snapshot;
      if(snapshot.value != null){
        String deviceRegistrationToken = snapshot.value.toString();
        // send notification now
        AssistantMethods.sendPushNotificationToDoctorNow(deviceRegistrationToken,context);
        Fluttertoast.showToast(msg: "Notification sent successfully");
      }

      else{
        Fluttertoast.showToast(msg: "Error sending notifications");
      }
    });

  }


  // Generates Push Notification and sends it
  static sendPushNotificationToDoctorNow(String deviceRegistrationToken,BuildContext context){
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

  static sendPushNotificationToPatientNow(String deviceRegistrationToken,BuildContext context){
    Map<String,String> headerNotification = {
      'Content-Type' : 'application/json',
      'Authorization' : cloudMessagingServerToken,
    };

    Map bodyNotification = {
      "notification":{
        "body": "Your prescription is uploaded by doctor. Click here to see",
        "title" : "Prescription reminder"
      },

      "priority": "high",

      "data" : {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id" : "1",
        "status" : "done",
        "consultation_id" : consultationId,
        "patient_id" : patientId
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
        "title" : "Visa Invitation Letter uploaded"
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