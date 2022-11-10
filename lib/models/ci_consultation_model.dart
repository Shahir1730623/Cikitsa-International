import 'package:firebase_database/firebase_database.dart';

class CIConsultationModel{
  String? id;
  String? consultantName;
  String? date;
  String? time;
  String? selectedCountry;
  String? consultantFee;
  String? consultationType;
  String? visitationReason;
  String? problem;
  String? payment;

  CIConsultationModel.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    date = (snapshot.value as dynamic)["date"];
    time = (snapshot.value as dynamic)["time"];
    consultantName = (snapshot.value as dynamic)["consultantName"];
    selectedCountry = (snapshot.value as dynamic)["selectedCountry"];
    consultantFee = (snapshot.value as dynamic)["consultantFee"];
    consultationType = (snapshot.value as dynamic)["consultationType"];
    visitationReason = (snapshot.value as dynamic)["visitationReason"];
    problem = (snapshot.value as dynamic)["problem"];
    payment = (snapshot.value as dynamic)["payment"];
  }
}
