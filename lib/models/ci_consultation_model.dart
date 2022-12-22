import 'package:firebase_database/firebase_database.dart';

class CIConsultationModel{
  String? id;
  String? userId;
  String? date;
  String? time;
  String? patientId;
  String? patientName;
  String? patientAge;
  String? gender;
  String? height;
  String? weight;
  String? selectedCountry;
  String? consultantId;
  String? consultantName;
  String? consultantFee;
  String? consultationStatus;
  String? visitationReason;
  String? problem;
  String? payment;


  CIConsultationModel.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    userId = (snapshot.value as dynamic)["userId"];
    date = (snapshot.value as dynamic)["date"];
    time = (snapshot.value as dynamic)["time"];
    patientId = (snapshot.value as dynamic)["patientId"];
    patientName = (snapshot.value as dynamic)["patientName"];
    patientAge = (snapshot.value as dynamic)["patientAge"];
    gender = (snapshot.value as dynamic)["gender"];
    height = (snapshot.value as dynamic)["height"];
    weight = (snapshot.value as dynamic)["weight"];
    selectedCountry = (snapshot.value as dynamic)["selectedCountry"];
    consultantId = (snapshot.value as dynamic)["consultantId"];
    consultantName = (snapshot.value as dynamic)["consultantName"];
    consultantFee = (snapshot.value as dynamic)["consultantFee"];
    consultationStatus = (snapshot.value as dynamic)["consultationStatus"];
    visitationReason = (snapshot.value as dynamic)["visitationReason"];
    problem = (snapshot.value as dynamic)["problem"];
    payment = (snapshot.value as dynamic)["payment"];
  }
}
