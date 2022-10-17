
import 'package:app/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
String? userPhoneNumber;
String? userName;
var verifyId;

UserModel userData = UserModel();
UserModel? currentUserInfo;