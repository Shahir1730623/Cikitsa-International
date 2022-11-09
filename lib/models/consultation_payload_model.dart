import 'package:meta/meta.dart';
import 'dart:convert';
class ConsultationPayloadModel{

  final String currentUserId;
  final String patientId;
  final String selectedServiceName;
  final String consultationId;

  ConsultationPayloadModel({required this.currentUserId,required this.patientId, required this.selectedServiceName, required this.consultationId});

  //Add these methods below

  factory ConsultationPayloadModel.fromJsonString(String str) => ConsultationPayloadModel._fromJson(jsonDecode(str));

  String toJsonString() => jsonEncode(_toJson());

  factory ConsultationPayloadModel._fromJson(Map<String, dynamic> json) => ConsultationPayloadModel(
    currentUserId : json['currentUserId'],
    patientId: json['patientId'],
    selectedServiceName: json['selectedServiceName'],
    consultationId: json['consultationId'],
  );


  Map<String, dynamic> _toJson() => {
  'currentUserId' :  currentUserId,
  'patientId': patientId,
  'selectedServiceName': selectedServiceName,
  'consultationId' : consultationId
  };

}