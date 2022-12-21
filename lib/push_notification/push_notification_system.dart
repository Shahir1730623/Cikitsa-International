import 'package:app/doctor_screens/doctor_visa_invitation_details.dart';
import 'package:app/main_screen/user_dashboard.dart';
import 'package:app/our_services/doctor_live_consultation/history_screen_details.dart';
import 'package:app/widgets/push_notification_dialog_doctor.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../global/global.dart';
import '../models/consultation_model.dart';
import '../models/consultation_model2.dart';
import '../models/consultation_payload_model.dart';
import '../models/visa_invitation_model.dart';
import '../service_file/local_notification_service.dart';
import '../widgets/push_notification_dialog_select_schedule.dart';
import '../widgets/push_notification_dialog_invitation_letter.dart';

class PushNotificationSystem{
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;


  Future initializeCloudMessaging(BuildContext context) async{

    // Terminated - When the app is completely closed and the app resumes from the push notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage){
      if(remoteMessage!=null){
        if(loggedInUser == "Doctor"){
          retrieveConsultationInfoForDoctor(remoteMessage.data["consultation_id"], context);
        }

        else{
          //consultationId = remoteMessage.data["consultation_id"];
          //patientId = remoteMessage.data["patient_id"];
          if(remoteMessage.data["selected_service"] == "Doctor Live Consultation"){
            retrieveConsultationDataFromDatabase(remoteMessage.data["consultation_id"],remoteMessage.data["patient_id"],context);
          }
          else{
            retrieveVisaInvitationDataFromDatabase(remoteMessage.data["visa_invitation_id"],remoteMessage.data["patient_Id"],context);
          }

        }

      }
    });


    // Background - When the app is minimized and the app resumes from the push notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      if(remoteMessage!=null){
        if(loggedInUser == "Doctor"){
          retrieveConsultationInfoForDoctor(remoteMessage.data["consultation_id"], context);
        }
        else{
          //consultationId = remoteMessage.data["consultation_id"];
          //patientId = remoteMessage.data["patient_id"];
          if(remoteMessage.data["selected_service"] == "Doctor Live Consultation"){
            retrieveConsultationDataFromDatabase(remoteMessage.data["consultation_id"],remoteMessage.data["patient_id"],context);
          }
          else{
            retrieveVisaInvitationDataFromDatabase(remoteMessage.data["visa_invitation_id"],remoteMessage.data["patient_Id"],context);
          }


        }
      }
    });

    // Foreground - When the app is open and receives a notification
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      if(remoteMessage!=null){
        if(loggedInUser == "Doctor"){
          retrieveConsultationInfoForDoctor(remoteMessage.data["consultation_id"], context);
        }

        else{
          //consultationId = remoteMessage.data["consultation_id"];
          //patientId = remoteMessage.data["patient_id"];
          if(remoteMessage.data["selected_service"] == "Doctor Live Consultation"){
            retrieveConsultationDataFromDatabase(remoteMessage.data["consultation_id"],remoteMessage.data["patient_id"],context);
          }
          else{
            retrieveVisaInvitationDataFromDatabase(remoteMessage.data["visa_invitation_id"],remoteMessage.data["patient_Id"],context);
          }
        }

      }
    });

  }

  Future generateRegistrationTokenForPatient() async{
    String? registrationToken = await firebaseMessaging.getToken(); // Generate and get registration token
    print("FCM Registration Token: ${registrationToken!}");

    FirebaseDatabase.instance.ref()  // Saving the registration token
        .child("Users")
        .child(currentFirebaseUser!.uid)
        .child("tokens")
        .set(registrationToken);

    firebaseMessaging.subscribeToTopic("allUsers");
  }

  Future generateRegistrationTokenForDoctor() async{
    String? registrationToken = await firebaseMessaging.getToken(); // Generate and get registration token
    print("FCM Registration Token: ${registrationToken!}");

    FirebaseDatabase.instance.ref()  // Saving the registration token
        .child("Doctors")
        .child(currentFirebaseUser!.uid)
        .child("tokens")
        .set(registrationToken);

    //firebaseMessaging.subscribeToTopic("allDoctors");
  }

  void retrieveConsultationInfoForDoctor(String consultationIdFromNotification, BuildContext context){
    FirebaseDatabase.instance.ref()
        .child("Doctors")
        .child(currentFirebaseUser!.uid)
        .child("consultations")
        .child(consultationIdFromNotification)
        .once()
        .then((snapData) {
          DataSnapshot snapshot = snapData.snapshot;
          if(snapshot.value != null){
            consultationId = (snapshot.value as Map)["id"].toString();
            patientId = (snapshot.value as Map)["patientId"].toString();
            userId = (snapshot.value as Map)["userId"].toString();
            selectedConsultationInfoForDocAndConsultant = ConsultationModel2.fromSnapshot(snapshot);
            Fluttertoast.showToast(msg: "ID:" + consultationId! + "User ID:" + userId! + "Patient ID:" + patientId! + "Date:" + selectedConsultationInfoForDocAndConsultant!.date!);
            localNotify = true;

            /*if(consultationId != null && userId != null && patientId != null){
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:(BuildContext context) => PushNotificationDialogTalkToDoctorNow()
              );
            }*/

          }

          else{
            Fluttertoast.showToast(msg: "Failed retrieving Consultation Information For Doctor");
          }
    });
  }

  void retrieveConsultationDataFromDatabase(String consultationId, String patientId, BuildContext context) {
    Fluttertoast.showToast(msg: "ID:" + consultationId + "Patient ID: " + patientId);
    FirebaseDatabase.instance.ref().child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId)
        .child("consultations").child(consultationId).once().then((dataSnap) {
      DataSnapshot snapshot = dataSnap.snapshot;
      if (snapshot.exists) {
        consultationId = (snapshot.value as Map)["id"].toString();
        patientId = (snapshot.value as Map)["patientId"].toString();
        selectedConsultationInfo = ConsultationModel.fromSnapshot(snapshot);
        localNotify = true;
      }

      else {
        Fluttertoast.showToast(msg: "No consultation record exist");
      }
    });
  }

  void retrieveVisaInvitationDataFromDatabase(String visaInvitationId, String patientId, BuildContext context) {
    Fluttertoast.showToast(msg: "ID:" + visaInvitationId + "Patient ID:" + patientId);
    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId)
        .child("visaInvitation")
        .child(invitationId!)
        .once()
        .then((dataSnap) {
      DataSnapshot snapshot = dataSnap.snapshot;
      if (snapshot.exists) {
        selectedVisaInvitationInfo = VisaInvitationModel.fromSnapshot(snapshot);
        if(visaInvitationId != null && patientId != null){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder:(BuildContext context) => const PushNotificationDialogInvitationLetter()
          );
        }
      }

      else {
        Fluttertoast.showToast(msg: "No Visa Invitation record exist");
      }
    });
  }







}



