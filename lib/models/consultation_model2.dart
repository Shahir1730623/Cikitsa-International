import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class ConsultationModel2{
  String? id;
  String? userId;
  String? imageUrl;
  String? date;
  String? time;
  String? consultantFee;
  String? patientId;
  String? patientName;
  String? patientAge;
  String? gender;
  String? height;
  String? weight;
  String? doctorId;
  String? doctorName;
  String? specialization;
  String? consultationType;
  String? visitationReason;
  String? problem;
  String? payment;

  ConsultationModel2(
      this.id,
      this.userId,
      this.date,
      this.time,
      this.imageUrl,
      this.consultantFee,
      this.patientId,
      this.patientName,
      this.patientAge,
      this.gender,
      this.height,
      this.weight,
      this.doctorId,
      this.doctorName,
      this.specialization,
      this.consultationType,
      this.visitationReason,
      this.problem,
      this.payment);

  ConsultationModel2.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    imageUrl = (snapshot.value as Map)['imageUrl'];
    userId = (snapshot.value as Map)['userId'];
    date = (snapshot.value as Map)['date'];
    time = (snapshot.value as Map)['time'];
    consultantFee = (snapshot.value as Map)['consultantFee'];
    patientId = (snapshot.value as Map)['patientId'];
    patientName = (snapshot.value as Map)['patientName'];
    patientAge = (snapshot.value as Map)['patientAge'];
    gender = (snapshot.value as Map)['gender'];
    height = (snapshot.value as Map)['height'];
    weight = (snapshot.value as Map)['weight'];
    doctorId = (snapshot.value as Map)['doctorId'];
    doctorName = (snapshot.value as Map)['doctorName'];
    specialization = (snapshot.value as Map)['specialization'];
    consultationType = (snapshot.value as Map)['consultationType'];
    visitationReason = (snapshot.value as Map)['visitationReason'];
    problem = (snapshot.value as Map)['problem'];
    payment = (snapshot.value as Map)['payment'];
  }
}
