import 'package:flutter/cupertino.dart';

class ConsultationHistoryDetails extends StatefulWidget {
  const ConsultationHistoryDetails({Key? key}) : super(key: key);

  @override
  State<ConsultationHistoryDetails> createState() => _ConsultationHistoryDetailsState();
}

class _ConsultationHistoryDetailsState extends State<ConsultationHistoryDetails> {
  TextEditingController patientIdTextEditingController = TextEditingController(text: "");
  TextEditingController patientNameTextEditingController = TextEditingController(text: "");
  TextEditingController patientAgeTextEditingController = TextEditingController(text: "");
  TextEditingController patientCountryTextEditingController = TextEditingController(text: "");
  TextEditingController genderTextEditingController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
