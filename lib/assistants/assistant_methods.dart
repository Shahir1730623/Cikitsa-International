import 'package:firebase_database/firebase_database.dart';

import '../global/global.dart';
import '../models/doctor_model.dart';
import '../models/user_model.dart';

class AssistantMethods{
  static void readOnlineUserCurrentInfo() async {
    currentFirebaseUser = firebaseAuth.currentUser;
    DatabaseReference reference = FirebaseDatabase.instance.ref()
        .child("Users").child(currentFirebaseUser!.uid);

    reference.once().then((snap) {
      final snapshot = snap.snapshot;
      if (snapshot.exists) {
        currentUserInfo = UserModel.fromSnapshot(snapshot);
        loggedInUser = "Patient";
      }
    });

    DatabaseReference reference2 = FirebaseDatabase.instance.ref()
        .child("Doctors").child(currentFirebaseUser!.uid);

    reference2.once().then((snap) {
      final snapshot = snap.snapshot;
      if (snapshot.exists) {
        currentDoctorInfo = DoctorModel.fromSnapshot(snapshot);
        loggedInUser = "Doctor";
      }
    });




  }

}