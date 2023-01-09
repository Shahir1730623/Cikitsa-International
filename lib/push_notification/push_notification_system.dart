import 'package:app/doctor_screens/doctor_visa_invitation_details.dart';
import 'package:app/main_screen/user_dashboard.dart';
import 'package:app/models/ci_consultation_model.dart';
import 'package:app/our_services/doctor_live_consultation/history_screen_details.dart';
import 'package:app/widgets/push_notification_dialog_doctor.dart';
import 'package:app/widgets/push_notification_dialog_prescription.dart';
import 'package:app/widgets/push_notification_physical_appointment.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../global/global.dart';
import '../models/consultation_model.dart';
import '../models/consultation_model2.dart';
import '../models/consultation_payload_model.dart';
import '../models/doctor_appointment_model.dart';
import '../models/visa_invitation_model.dart';
import '../navigation_service.dart';
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
          if(remoteMessage.data["selected_service"] == "Doctor Live Consultation"){
            retrieveConsultationInfoForDoctor(remoteMessage.data["consultation_id"], context);
          }

          else{
            retrieveDoctorAppointmentDataFromDatabase(remoteMessage.data["appointment_id"],remoteMessage.data["patient_id"],remoteMessage.data["type"],remoteMessage.data["push_notify"],context);
          }

        }

        else{
          if(remoteMessage.data["selected_service"] == "Doctor Live Consultation"){
            retrieveConsultationDataFromDatabase(remoteMessage.data["consultation_id"],remoteMessage.data["patient_id"], remoteMessage.data["push_notify"],context);
          }

          else if(remoteMessage.data["selected_service"] == "CI Consultation"){
            retrieveCIConsultationDataFromDatabase(remoteMessage.data["consultation_id"],remoteMessage.data["patient_id"], remoteMessage.data["push_notify"], context);
          }

          else if(remoteMessage.data["selected_service"] == "Visa Invitation"){
            retrieveVisaInvitationDataFromDatabase(remoteMessage.data["visa_invitation_id"],remoteMessage.data["patient_Id"],remoteMessage.data["push_notify"],context);
          }

          else if(remoteMessage.data["selected_service"] == "Doctor Appointment"){
            retrieveDoctorAppointmentDataFromDatabase(remoteMessage.data["appointment_id"],remoteMessage.data["patient_id"],remoteMessage.data["type"] ,remoteMessage.data["push_notify"],context);
          }

          else{
            Fluttertoast.showToast(msg: "Nothing");
          }

        }

      }
    });


    // Background - When the app is minimized and the app resumes from the push notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      if(remoteMessage != null){
        if(loggedInUser == "Doctor"){
          if(remoteMessage.data["selected_service"] == "Doctor Live Consultation"){
            retrieveConsultationInfoForDoctor(remoteMessage.data["consultation_id"], context);
          }

          else{
            retrieveDoctorAppointmentDataFromDatabase(remoteMessage.data["appointment_id"],remoteMessage.data["patient_id"],remoteMessage.data["type"],remoteMessage.data["push_notify"],context);
          }
        }
        else{
          if(remoteMessage.data["selected_service"] == "Doctor Live Consultation"){
            retrieveConsultationDataFromDatabase(remoteMessage.data["consultation_id"],remoteMessage.data["patient_id"], remoteMessage.data["push_notify"],context);
          }

          else if(remoteMessage.data["selected_service"] == "CI Consultation"){
            retrieveCIConsultationDataFromDatabase(remoteMessage.data["consultation_id"],remoteMessage.data["patient_id"], remoteMessage.data["push_notify"], context);
          }

          else if(remoteMessage.data["selected_service"] == "Visa Invitation"){
            retrieveVisaInvitationDataFromDatabase(remoteMessage.data["visa_invitation_id"],remoteMessage.data["patient_Id"],remoteMessage.data["push_notify"],context);
          }

          else if(remoteMessage.data["selected_service"] == "Doctor Appointment"){
            retrieveDoctorAppointmentDataFromDatabase(remoteMessage.data["appointment_id"],remoteMessage.data["patient_id"], remoteMessage.data["type"],remoteMessage.data["push_notify"],context);
          }

          else{
            Fluttertoast.showToast(msg: "Nothing");
          }


        }
      }
    });

    // Foreground - When the app is open and receives a notification
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      if(remoteMessage!=null){
        if(loggedInUser == "Doctor"){
          if(remoteMessage.data["selected_service"] == "Doctor Live Consultation"){
            retrieveConsultationInfoForDoctor(remoteMessage.data["consultation_id"], context);
          }

          else{
            retrieveDoctorAppointmentDataFromDatabase(remoteMessage.data["appointment_id"],remoteMessage.data["patient_id"],remoteMessage.data["type"],remoteMessage.data["push_notify"],context);
          }
        }

        else{
          if(remoteMessage.data["selected_service"] == "Doctor Live Consultation"){
            retrieveConsultationDataFromDatabase(remoteMessage.data["consultation_id"],remoteMessage.data["patient_id"], remoteMessage.data["push_notify"],context);
          }

          else if(remoteMessage.data["selected_service"] == "CI Consultation"){
            retrieveCIConsultationDataFromDatabase(remoteMessage.data["consultation_id"],remoteMessage.data["patient_id"], remoteMessage.data["push_notify"], context);
          }

          else if(remoteMessage.data["selected_service"] == "Visa Invitation"){
            retrieveVisaInvitationDataFromDatabase(remoteMessage.data["visa_invitation_id"],remoteMessage.data["patient_Id"],remoteMessage.data["push_notify"],context);
          }

          else if(remoteMessage.data["selected_service"] == "Doctor Appointment"){
            retrieveDoctorAppointmentDataFromDatabase(remoteMessage.data["appointment_id"],remoteMessage.data["patient_id"],remoteMessage.data["type"],remoteMessage.data["push_notify"],context);
          }

          else{
            Fluttertoast.showToast(msg: "Nothing");
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

  void retrieveConsultationDataFromDatabase(String cId, String pId, String p, BuildContext context) {
    pushNotifyForDoc = p;
    selectedService = "Doctor Live Consultation";
    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(pId)
        .child("consultations")
        .child(cId)
        .once()
        .then((dataSnap) {
      DataSnapshot snapshot = dataSnap.snapshot;
      if (snapshot.exists) {
        consultationId = cId;
        patientId = pId;
        selectedConsultationInfo = ConsultationModel.fromSnapshot(snapshot);
        if(pushNotifyForDoc == "true"){
          Fluttertoast.showToast(msg: pushNotifyForDoc!);
          pushNotifyForDoc = "false";
          showDialog(
              context: NavigationService.navigatorKey.currentContext!,
              barrierDismissible: false,
              builder:(context) => const PushNotificationDialogPrescription()
          );
        }

        else{
          Fluttertoast.showToast(msg: pushNotifyForDoc!);
          localNotify = true;
        }

      }

      else {
        Fluttertoast.showToast(msg: "No consultation record exist");
      }
    });
  }

  retrieveCIConsultationDataFromDatabase(String ciConsultationId, String pId, String p, BuildContext context){
    pushNotifyForCI = p;
    selectedService = "CI Consultation";
    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(pId)
        .child("CIConsultations")
        .child(ciConsultationId)
        .once().then((dataSnap) {
          DataSnapshot snapshot = dataSnap.snapshot;
          if(snapshot.exists) {
            consultationId = ciConsultationId;
            patientId = pId;
            selectedCIConsultationInfo = CIConsultationModel.fromSnapshot(snapshot);
            if(pushNotifyForCI == "true"){
              Fluttertoast.showToast(msg: pushNotifyForCI!);
              pushNotifyForCI = "false";
              showDialog(
                  context: NavigationService.navigatorKey.currentContext!,
                  barrierDismissible: false,
                  builder:(context) => const PushNotificationDialogPrescription()
              );
            }

            else{
              Fluttertoast.showToast(msg: pushNotifyForCI!);
              localNotifyForCI = true;
            }

          }
          else {
            Fluttertoast.showToast(msg: "No consultation record exist");
          }
    });


  }

  void retrieveVisaInvitationDataFromDatabase(String visaInvitationId, String patientId, String p, BuildContext context) {
    pushNotifyForVisa = p;
    selectedService = "Visa Invitation";
    FirebaseDatabase.instance.ref()
        .child("Users")
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId)
        .child("visaInvitation")
        .child(visaInvitationId)
        .once()
        .then((dataSnap) {
      DataSnapshot snapshot = dataSnap.snapshot;
      if (snapshot.exists) {
        Fluttertoast.showToast(msg: pushNotifyForVisa!);
        if(pushNotifyForVisa == "true"){
          pushNotifyForVisa = "false";
          invitationId = visaInvitationId;
          selectedVisaInvitationInfo = VisaInvitationModel.fromSnapshot(snapshot);
          showDialog(
              context: NavigationService.navigatorKey.currentContext!,
              barrierDismissible: false,
              builder:(context) => const PushNotificationDialogInvitationLetter()
          );
        }

        else{
          Fluttertoast.showToast(msg: pushNotifyForCI!);
        }

      }

      else {
        Fluttertoast.showToast(msg: "No Visa Invitation record exist");
      }
    });
  }

  void retrieveDoctorAppointmentDataFromDatabase(String apptId,String pId, String type, String p, BuildContext context){
    pushNotifyForAppointment = p;
    if(loggedInUser == "Patient"){
      FirebaseDatabase.instance.ref()
          .child("Users")
          .child(currentFirebaseUser!.uid)
          .child("patientList")
          .child(pId)
          .child("doctorAppointment")
          .child(apptId).once().then((dataSnap) {
        DataSnapshot snapshot = dataSnap.snapshot;
        if (snapshot.exists) {
          Fluttertoast.showToast(msg: pushNotifyForAppointment!);
          if(pushNotifyForAppointment == "true"){
            pushNotifyForAppointment = "false";
            appointmentId = apptId;
            selectedDoctorAppointmentInfo = DoctorAppointmentModel.fromSnapshot(snapshot);
            showDialog(
                context: NavigationService.navigatorKey.currentContext!,
                barrierDismissible: false,
                builder:(context) => PushNotificationPhysicalAppointment(type: type)
            );
          }

          else{
            Fluttertoast.showToast(msg: pushNotifyForCI!);
          }

        }

        else {
          Fluttertoast.showToast(msg: "No appointment record exist");
        }

      });
    }

    else {
      FirebaseDatabase.instance.ref()
          .child("Doctors")
          .child(currentFirebaseUser!.uid)
          .child("appointments")
          .child(apptId).once().then((dataSnap) {
        DataSnapshot snapshot = dataSnap.snapshot;
        if (snapshot.exists) {
          Fluttertoast.showToast(msg: pushNotifyForAppointment!);
          if(pushNotifyForAppointment == "true"){
            pushNotifyForAppointment = "false";
            appointmentId = apptId;
            selectedDoctorAppointmentInfo = DoctorAppointmentModel.fromSnapshot(snapshot);
            showDialog(
                context: NavigationService.navigatorKey.currentContext!,
                barrierDismissible: false,
                builder:(context) => PushNotificationPhysicalAppointment()
            );
          }

          else{
            Fluttertoast.showToast(msg: pushNotifyForCI!);
          }

        }

        else {
          Fluttertoast.showToast(msg: "No Visa Invitation record exist");
        }

      });
    }

  }







}



