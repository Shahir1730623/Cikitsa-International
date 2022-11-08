import 'package:firebase_database/firebase_database.dart';

class ConsultationModel{
  String? consultationId;
  String? doctorName;
  String? doctorImageUrl;
  String? specialization;
  String? doctorFee;
  String? workplace;
  String? date;
  String? time;
  String? visitationReason;
  String? problem;
  String? consultationType;
  String? payment;

  ConsultationModel.fromSnapshot(DataSnapshot snapshot){
    consultationId = snapshot.key;
    doctorName = (snapshot.value as dynamic)["doctorName"];
    doctorImageUrl = (snapshot.value as dynamic)["doctorImageUrl"];
    specialization = (snapshot.value as dynamic)["specialization"];
    doctorFee = (snapshot.value as dynamic)["doctorFee"];
    workplace = (snapshot.value as dynamic)["workplace"];
    date = (snapshot.value as dynamic)["date"];
    time = (snapshot.value as dynamic)["time"];
    visitationReason = (snapshot.value as dynamic)["visitationReason"];
    problem = (snapshot.value as dynamic)["problem"];
    consultationType = (snapshot.value as dynamic)["consultationType"];
    payment = (snapshot.value as dynamic)["payment"];
  }

}