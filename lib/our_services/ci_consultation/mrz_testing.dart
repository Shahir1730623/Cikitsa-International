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
        await showDialog(
          context: context,
          builder: (context) => Dialog(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      controller.currentState?.resetScanning();
                    },
                    child: const Text('Reset Scanning'),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
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
                    child: const Text('Exit Scanning'),
                  ),
                  Text('Type : ${mrzResult.documentType}'),
                  Text('Country Code : ${mrzResult.countryCode}'),
                  Text('Passport Number : ${mrzResult.documentNumber}'),
                  Text('First Name : ${mrzResult.givenNames}'),
                  Text('Last Name : ${mrzResult.surnames}'),
                  Text('Nationality : ${mrzResult.nationalityCountryCode}'),
                  Text('Personal No : ${mrzResult.personalNumber}'),
                  Text('Date of Birth : ${mrzResult.birthDate}'),
                  Text('Sex : ${mrzResult.sex.name}'),
                  Text('Expiry Date: ${mrzResult.expiryDate}'),

                ],
              ),
            ),
          ),
        );
      },
    );

  }

}