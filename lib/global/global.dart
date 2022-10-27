
import 'package:app/models/user_model.dart';
import 'package:app/models/consultation_model.dart';
import 'package:app/models/doctor_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/patient_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
String? userPhoneNumber;
String? userName;
var verifyId;

String? patientId;
String? consultationId;
String? doctorId;

PatientModel patientModel = PatientModel();
UserModel userData = UserModel();

UserModel? currentUserInfo;
DoctorModel? selectedDoctorInfo;
ConsultationModel? selectedConsultationInfo;

bool? pushNotify = false;