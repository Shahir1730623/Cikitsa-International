import 'package:firebase_database/firebase_database.dart';

class DoctorAppointmentModel{
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
  String? documentType;
  String? countryCode;
  String? passportNumber;
  String? patientSurname;
  String? patientGivenName;
  String? nationality;
  String? passportPersonalNumber;
  String? dateOfBirth;
  String? gender;
  String? expiryDate;
  String? patientGender;
  String? patientWeight;
  String? patientHeight;
  String? visitationReason;
  String? problem;
  String? status;
  String? payment;

  DoctorAppointmentModel.fromSnapshot(DataSnapshot snapshot){
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
    documentType = (snapshot.value as dynamic)["documentType"];
    countryCode = (snapshot.value as dynamic)["countryCode"];
    passportNumber = (snapshot.value as dynamic)["passportNumber"];
    patientSurname = (snapshot.value as dynamic)["patientSurname"];
    patientGivenName = (snapshot.value as dynamic)["patientGivenName"];
    nationality = (snapshot.value as dynamic)["nationality"];
    passportPersonalNumber = (snapshot.value as dynamic)["passportPersonalNumber"];
    dateOfBirth = (snapshot.value as dynamic)["dateOfBirth"];
    gender = (snapshot.value as dynamic)["gender"];
    expiryDate = (snapshot.value as dynamic)["expiryDate"];
    patientGender = (snapshot.value as dynamic)["patientGender"];
    patientWeight = (snapshot.value as dynamic)["patientWeight"];
    patientHeight = (snapshot.value as dynamic)["patientHeight"];
    visitationReason = (snapshot.value as dynamic)["visitationReason"];
    problem = (snapshot.value as dynamic)["problem"];
    status = (snapshot.value as dynamic)["status"];
    payment = (snapshot.value as dynamic)["payment"];
  }

}
