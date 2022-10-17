import 'package:firebase_database/firebase_database.dart';

import '../global/global.dart';
import '../models/UserModel.dart';

class AssistantMethods{
  static void readOnlineUserCurrentInfo() {
    currentFirebaseUser = firebaseAuth.currentUser;
    DatabaseReference reference = FirebaseDatabase.instance.ref()
        .child("Users").child(currentFirebaseUser!.uid);

    reference.once().then((snap) {
      final snapshot = snap.snapshot;
      if (snapshot.exists) {
        currentUserInfo = UserModel.fromSnapshot(snapshot);
      }
    });
  }

}