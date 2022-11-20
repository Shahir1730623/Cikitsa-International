import 'package:firebase_database/firebase_database.dart';

class DoctorModel{
  String? doctorId;
  String? doctorFirstName;
  String? doctorLastName;
  String? doctorPhone;
  String? doctorEmail;
  String? doctorImageUrl;
  String? specialization;
  String? degrees;
  String? experience;
  String? workplace;
  String? rating;
  String? totalVisits;
  String? fee;
  String? status;

  DoctorModel(this.doctorId, this.doctorFirstName, this.doctorLastName, this.specialization, this.degrees,
      this.experience, this.workplace, this.rating, this.totalVisits, this.fee, this.status
  );

  DoctorModel.fromSnapshot(DataSnapshot snapshot){
    doctorId = snapshot.key;
    doctorFirstName = (snapshot.value as dynamic)["firstName"];
    doctorLastName = (snapshot.value as dynamic)["lastName"];
    doctorPhone = (snapshot.value as dynamic)["phone"];
    doctorEmail = (snapshot.value as dynamic)["email"];
    doctorImageUrl = (snapshot.value as dynamic)["imageUrl"];
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

