import 'package:flutter/cupertino.dart';

class FindDoctor extends StatefulWidget {
  const FindDoctor({Key? key}) : super(key: key);

  @override
  State<FindDoctor> createState() => _FindDoctorState();
}

class _FindDoctorState extends State<FindDoctor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text(
            "Find Doctor Screen"
        ),
      ),
    );
  }
}


