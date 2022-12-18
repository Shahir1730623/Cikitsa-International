import 'package:firebase_database/firebase_database.dart';

class VisaInvitationModel{
  String? id;
  String? userId;
  String? doctorId;
  String? doctorName;
  String? doctorImageUrl;
  String? workplace;
  String? specialization;
  String? date;
  String? time;
  String? patientId;
  String? patientName;
  String? patientDateOfBirth;
  String? patientIdNo;
  String? patientGender;
  String? patientWeight;
  String? patientHeight;
  String? attendantName;
  String? attendantDateOfBirth;
  String? attendantIdNo;
  String? visitationReason;
  String? selectedVisaCenter;
  String? problem;
  String? status;
  String? payment;

  VisaInvitationModel.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    userId = (snapshot.value as dynamic)["userId"];
    doctorId = (snapshot.value as dynamic)["doctorId"];
    doctorName = (snapshot.value as dynamic)["doctorName"];
    doctorImageUrl = (snapshot.value as dynamic)["doctorImageUrl"];
    workplace = (snapshot.value as dynamic)["workplace"];
    specialization = (snapshot.value as dynamic)["specialization"];
    date = (snapshot.value as dynamic)["date"];
    time = (snapshot.value as dynamic)["time"];
    patientId = (snapshot.value as dynamic)["patientId"];
    patientName = (snapshot.value as dynamic)["patientName"];
    patientDateOfBirth = (snapshot.value as dynamic)["patientDateOfBirth"];
    patientIdNo = (snapshot.value as dynamic)["patientIdNo"];
    patientGender = (snapshot.value as dynamic)["patientGender"];
    patientWeight = (snapshot.value as dynamic)["patientWeight"];
    patientHeight = (snapshot.value as dynamic)["patientHeight"];
    attendantName = (snapshot.value as dynamic)["attendantName"];
    attendantDateOfBirth = (snapshot.value as dynamic)["attendantDateOfBirth"];
    attendantIdNo = (snapshot.value as dynamic)["attendantIdNo"];
    visitationReason = (snapshot.value as dynamic)["visitationReason"];
    selectedVisaCenter = (snapshot.value as dynamic)["selectedVisaCenter"];
    problem = (snapshot.value as dynamic)["problem"];
    status = (snapshot.value as dynamic)["status"];
    payment = (snapshot.value as dynamic)["payment"];
  }
}
