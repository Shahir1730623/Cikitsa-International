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

    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(currentFirebaseUser!.uid)
        .once()
        .then((snap) {
      final snapshot = snap.snapshot;
      if (snapshot.exists) {
        currentUserInfo = UserModel.fromSnapshot(snapshot);
        loggedInUser = "Patient";
      }
    });


    FirebaseDatabase.instance.ref()
        .child("Doctors")
        .child(currentFirebaseUser!.uid)
        .once().then((snap) {
      final snapshot = snap.snapshot;
      if (snapshot.exists) {
        currentDoctorInfo = DoctorModel.fromSnapshot(snapshot);
        loggedInUser = "Doctor";
      }
    });


    FirebaseDatabase.instance.ref()
        .child("Consultant")
        .child(currentFirebaseUser!.uid)
        .once().then((snap) {
      final snapshot = snap.snapshot;
      if (snapshot.exists) {
        currentConsultantInfo = ConsultantModel.fromSnapshot(snapshot);
        loggedInUser = "Consultant";
      }
    });

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
        "selected_service" : "Doctor Live Consultation"
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
        "dateTime" : dateTime,
        "push_notify" : "false"
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


  static sendCIConsultationPushNotificationToPatientNow(String deviceRegistrationToken, String patientId, String selectedService,BuildContext context){
    Map<String,String> headerNotification = {
      'Content-Type' : 'application/json',
      'Authorization' : cloudMessagingServerToken,
    };

    Map bodyNotification = {
      "notification":{
        "body": "You have appointment Later. Please go to CI Consultation history to check your appointment time",
        "title" : "Appointment reminder"
      },

      "priority": "high",

      "data" : {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id" : "1",
        "status" : "done",
        "consultation_id" : consultationId,
        "patient_id" : patientId,
        "selected_service" : selectedService,
        "push_notify" : "false"
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
        "selected_service" : "Visa Invitation",
        "push_notify" : "true"
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

  static sendPrescriptionPushNotificationToPatientNow(String deviceRegistrationToken, String patientId, String selectedService, BuildContext context){
    Map<String,String> headerNotification = {
      'Content-Type' : 'application/json',
      'Authorization' : cloudMessagingServerToken,
    };

    Map bodyNotification = {
      "notification":{
        "body": "Your prescription is uploaded by doctor. Click here to see",
        "title" : "Doctor Prescription Uploaded"
      },

      "priority": "high",

      "data" : {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id" : "1",
        "status" : "done",
        "consultation_id" : consultationId,
        "patient_id" : patientId,
        "selected_service" : selectedService,
        "push_notify" : "true"
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

  static sendAppointmentPushNotificationToPatientNow(String deviceRegistrationToken, String appointmentId, String patientId, BuildContext context){
    Map<String,String> headerNotification = {
      'Content-Type' : 'application/json',
      'Authorization' : cloudMessagingServerToken,
    };

    Map bodyNotification = {
      "notification":{
        "body": "Your appointment has been scheduled. Click here to see",
        "title" : "Doctor Appointment Confirmation"
      },

      "priority": "high",

      "data" : {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id" : "1",
        "status" : "done",
        "appointment_id" : appointmentId,
        "patient_id" : patientId,
        "selected_service" : "Doctor Appointment",
        "push_notify" : "true",
        "type" : "confirmation"
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

  static sendAppointmentPushNotificationToDoctorNow(String deviceRegistrationToken, String appointmentId, String patientId, BuildContext context){
    Map<String,String> headerNotification = {
      'Content-Type' : 'application/json',
      'Authorization' : cloudMessagingServerToken,
    };

    Map bodyNotification = {
      "notification":{
        "body": "You have an upcoming physical appointment. Click here to see",
        "title" : "Physical Appointment Confirmation"
      },

      "priority": "high",

      "data" : {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id" : "1",
        "status" : "done",
        "appointment_id" : appointmentId,
        "patient_id" : patientId,
        "selected_service" : "Doctor Appointment",
        "push_notify" : "true",
        "type" : "confirmation"

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

  static sendAppointmentPrescriptionPushNotificationToPatientNow(String deviceRegistrationToken, String appointmentId, String patientId, BuildContext context){
    Map<String,String> headerNotification = {
      'Content-Type' : 'application/json',
      'Authorization' : cloudMessagingServerToken,
    };

    Map bodyNotification = {
      "notification":{
        "body": "Your physical appointment prescription is uploaded. Click here to see",
        "title" : "Physical Appointment Prescription"
      },

      "priority": "high",

      "data" : {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id" : "1",
        "status" : "done",
        "appointment_id" : appointmentId,
        "patient_id" : patientId,
        "selected_service" : "Doctor Appointment",
        "push_notify" : "true",
        "type" : "prescription"
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