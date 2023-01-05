import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mrz_scanner/mrz_scanner.dart';

import '../../global/global.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final MRZController controller = MRZController();

  @override
  Widget build(BuildContext context) {
    return MRZScanner(
      controller: controller,
      onSuccess: (mrzResult) async {
        Navigator.pop(
          context,
          {
            "type" : mrzResult.documentType,
            "country_Code" : mrzResult.countryCode,
            "document_Number" : mrzResult.documentNumber,
            "given_Name" : mrzResult.givenNames,
            "surname" : mrzResult.surnames,
            "nationality" : mrzResult.nationalityCountryCode,
            "personal_Number" : mrzResult.personalNumber,
            "birth_Date" : DateFormat('dd-MM-yyyy').format(mrzResult.birthDate),
            "gender" : mrzResult.sex.name,
            "expiry_Date" : DateFormat('dd-MM-yyyy').format(mrzResult.expiryDate),
          },
        );
      },
    );

  }

}