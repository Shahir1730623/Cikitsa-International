import 'package:firebase_database/firebase_database.dart';

class ConsultantModel{
  String? id;
  String? name;
  String? email;
  String? phone;
  String? age;
  String? imageUrl;
  String? patientQueueLength;

  ConsultantModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.imageUrl,
    this.patientQueueLength,
});

  ConsultantModel.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    name = (snapshot.value as dynamic)["name"];
    email = (snapshot.value as dynamic)["email"];
    phone = (snapshot.value as dynamic)["phone"];
    imageUrl = (snapshot.value as dynamic)["imageUrl"];
    patientQueueLength = (snapshot.value as dynamic)["patientQueueLength"];
  }

}