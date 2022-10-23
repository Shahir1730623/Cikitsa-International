import 'package:firebase_database/firebase_database.dart';

class DoctorModel{
  String? doctorId;
  String? doctorName;
  String? specialization;
  String? degrees;
  String? experience;
  String? workplace;
  String? rating;
  String? totalVisits;
  String? fee;
  String? status;

  DoctorModel(this.doctorId, this.doctorName, this.specialization, this.degrees,
      this.experience, this.workplace, this.rating, this.totalVisits, this.fee, this.status
  );

  DoctorModel.fromSnapshot(DataSnapshot snapshot){
    doctorId = snapshot.key;
    doctorName = (snapshot.value as dynamic)["name"];
    specialization = (snapshot.value as dynamic)["specialization"];
    degrees = (snapshot.value as dynamic)["degrees"];
    experience = (snapshot.value as dynamic)["experience"];
    workplace = (snapshot.value as dynamic)["workplace"];
    rating = (snapshot.value as dynamic)["rating"];
    totalVisits = (snapshot.value as dynamic)["totalVisits"];
    fee = (snapshot.value as dynamic)["fee"];
    status = (snapshot.value as dynamic)["status"];
  }


}

