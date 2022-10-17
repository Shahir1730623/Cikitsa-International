import 'package:firebase_database/firebase_database.dart';

class UserModel{
  String? id;
  String? name;
  String? phone;

  UserModel({
    this.id,
    this.name,
    this.phone
  });

  UserModel.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    name = (snapshot.value as dynamic)["name"];
    phone = (snapshot.value as dynamic)["phone"];
  }


}