import 'dart:io';
import 'package:app/global/global.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:fluttertoast/fluttertoast.dart';

class Storage{
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future<void> uploadPrescriptionAndReportsOfPatient (
      String filePath,
      String fileName,
      ) async {
    File file = File(filePath);
    try{
      final reference =  await storage.ref('Patient Reports and Prescriptions')
          .child(currentFirebaseUser!.uid)
          .child("patientList")
          .child(patientId!).child(fileName);

      reference.putFile(file);

    }
    catch(e){
      Fluttertoast.showToast(msg: "Error" + e.toString());
    }

  }

  Future<String> downloadPrescriptionAndReportsOfPatientUrl(
      String fileName,
      ) async {
      final reference =  await storage.ref('Patient Reports and Prescriptions')
          .child(currentFirebaseUser!.uid)
          .child("patientList")
          .child(patientId!).child(fileName);

      String imageUrl =  await reference.getDownloadURL();
      return imageUrl;

  }


  Future<firebase_storage.ListResult> listFiles() async{
    firebase_storage.ListResult results = await storage.ref('Patient Prescriptions and Reports')
        .child(currentFirebaseUser!.uid)
        .child("patientList")
        .child(patientId!).list();

    results.items.forEach((firebase_storage.Reference reference) {
      Fluttertoast.showToast(msg: "Found File: + $reference");
    });
    return results;
  }

}