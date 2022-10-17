import 'package:app/global/global.dart';
import 'package:app/splash_screen/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            firebaseAuth.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
          },

          child: const Text(
            "Logout"
          ),
        ),
      ),
    );
  }
}

