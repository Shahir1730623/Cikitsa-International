import 'package:app/authentication/initialization_screen.dart';
import 'package:app/common_screens/coundown_screen.dart';
import 'package:app/main_screen.dart';
import 'package:app/our_services/doctor_live_consultation/chat_screen.dart';
import 'package:app/our_services/doctor_live_consultation/video_consultation_dashboard.dart';
import 'package:app/splash_screen/splash_screen.dart';
import 'package:app/widgets/unfocus_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
      MyApp(
        child: MaterialApp(
          title: 'Cikitsa International',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const SplashScreen(),
          builder: (context,child) => unFocus(child: child!),
          debugShowCheckedModeBanner: false,
        ),
  ));
}


class MyApp extends StatefulWidget
{
  final Widget? child;
  MyApp({this.child});

  static void restartApp(BuildContext context)
  {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
{
  Key key = UniqueKey();

  void restartApp()
  {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child!,
    );
  }
}
