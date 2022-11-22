import 'package:firebase_database/firebase_database.dart';

class PatientModel{
  String? id;
  String? firstName;
  String? lastName;
  //String? imageUrl;
  String? age;
  String? weight;
  String? height;
  String? gender;
  String? relation;


  PatientModel(
      this.id,
      this.firstName,
      this.lastName,
      //this.imageUrl,
      this.age,
      this.weight,
      this.height,
      this.gender,
      this.relation,
  );

  PatientModel.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    firstName = (snapshot.value as dynamic)["firstName"];
    lastName = (snapshot.value as dynamic)["lastName"];
    //imageUrl = (snapshot.value as dynamic)["imageUrl"];
    age = (snapshot.value as dynamic)["age"];
    weight = (snapshot.value as dynamic)["weight"];
    height = (snapshot.value as dynamic)["height"];
    gender = (snapshot.value as dynamic)["gender"];
    relation = (snapshot.value as dynamic)["relation"];
  }


}