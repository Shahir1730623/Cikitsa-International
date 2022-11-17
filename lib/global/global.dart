
import 'package:app/models/ci_consultation_model.dart';
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
CIConsultationModel? selectedCIConsultationInfo;

String selectedService = "";
String? selectedCountry;
String? selectedServiceDatabaseParentName;

bool? pushNotify = false;
String tempToken = "";
bool isBroadcaster = true;

// Agora
/*const appId = 'dda00641d5894ee0b40aec14845f364b';
const token = '007eJxTYJjTs78ij+/l1Wo530P6Nf87Cp5ueH7Q9ZbHyoln9u9aF2imwJCSkmhgYGZimGJqYWmSmmqQZGKQmJpsaGJhYppmbGaSdH9SSXJDICND06E+ZkYGCATxWRhKUotLGBgAMcEiuw==';*/

String? channelName;
int? tokenRole;