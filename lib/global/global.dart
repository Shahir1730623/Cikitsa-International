
import 'package:app/models/ci_consultation_model.dart';
import 'package:app/models/user_model.dart';
import 'package:app/models/consultation_model.dart';
import 'package:app/models/doctor_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/consultant_model.dart';
import '../models/consultation_model2.dart';
import '../models/patient_model.dart';
import '../models/visa_invitation_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
String? userPhoneNumber;
String? userName;
var verifyId;

String? userId;
String? patientId;
String? consultationId;
String? invitationId;
String? doctorConsultationId;
String? doctorId;
String? userType;
String? loggedInUser;


UserModel? currentUserInfo;
DoctorModel? currentDoctorInfo;
ConsultantModel? currentConsultantInfo;

DoctorModel? selectedDoctorInfo;
PatientModel? selectedPatientInfo;
ConsultantModel? selectedConsultantInfo;

ConsultationModel? selectedConsultationInfo;
ConsultationModel2? selectedConsultationInfoForDocAndConsultant;
CIConsultationModel? selectedCIConsultationInfo;
VisaInvitationModel? selectedVisaInvitationInfo;

String selectedService = "";
String? selectedCountry = "Select a country";
String? selectedServiceDatabaseParentName;

bool? pushNotify = false;
String tempToken = "";
bool isBroadcaster = true;
bool? localNotify = false;
bool? localNotifyForCI = false;
String cloudMessagingServerToken = 'key=AAAALn1lelI:APA91bG0BH1-fwORR9mWgt53XA_DlnsOQmX80BwR7XAzVU0KRBNVoXGM1ruuq7u-K-nUsgGarqb9BasoyfNaHpbr4ec2oOzzGlAFh0RwE5s1VKNxr0fARMp418B2aZHZmdux3gSbF516';

// Agora
/*const appId = 'dda00641d5894ee0b40aec14845f364b';
const token = '007eJxTYJjTs78ij+/l1Wo530P6Nf87Cp5ueH7Q9ZbHyoln9u9aF2imwJCSkmhgYGZimGJqYWmSmmqQZGKQmJpsaGJhYppmbGaSdH9SSXJDICND06E+ZkYGCATxWRhKUotLGBgAMcEiuw==';*/

String? channelName;
int? tokenRole;

//Visa invitation
String? patientName;
String? patientDateOfBirth;
String? patientIDNo;

String? attendantName;
String? attendantDateOfBirth;
String? attendantIDNo;

String? dateTime;


