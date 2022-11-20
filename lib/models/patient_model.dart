import 'package:firebase_database/firebase_database.dart';

class PatientModel{
  String? id;
  String? firstName;
  String? lastName;
  String? age;
  String? weight;
  String? height;
  String? gender;
  String? relation;
  String? visitationReason;
  String? problem;


  PatientModel(
      this.id,
      this.firstName,
      this.lastName,
      this.age,
      this.weight,
      this.height,
      this.gender,
      this.relation,
      this.visitationReason,
      this.problem
  );

  PatientModel.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    firstName = (snapshot.value as dynamic)["firstName"];
    lastName = (snapshot.value as dynamic)["lastName"];
    age = (snapshot.value as dynamic)["age"];
    weight = (snapshot.value as dynamic)["weight"];
    height = (snapshot.value as dynamic)["height"];
    gender = (snapshot.value as dynamic)["gender"];
    relation = (snapshot.value as dynamic)["relation"];
    visitationReason = (snapshot.value as dynamic)["visitationReason"];
    problem = (snapshot.value as dynamic)["problem"];
  }


}