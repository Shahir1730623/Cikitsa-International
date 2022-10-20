
import 'package:app/models/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/patient_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
String? userPhoneNumber;
String? userName;
var verifyId;
PatientModel patientModel = PatientModel();

UserModel userData = UserModel();
UserModel? currentUserInfo;