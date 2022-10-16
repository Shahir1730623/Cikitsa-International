import 'package:app/global/global.dart';
import 'package:app/splash_screen/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
          onPressed: (){
            firebaseAuth.signOut();
            Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
          },
          child: Text(
            "Logout",
          ),
        )
      ),
    );
  }
}
