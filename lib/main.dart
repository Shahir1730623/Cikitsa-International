import 'package:app/splash_screen/splash_screen.dart';
import 'package:app/widgets/unfocus_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'consultant_screens/ci_consultation_details.dart';
import 'navigation_service.dart';
import 'our_services/ci_consultation/mrz_testing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
      MyApp(
        child: MaterialApp(
          title:'Cikitsa International',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const SplashScreen(),
          builder: (context,child) => unFocus(child: child!),
          debugShowCheckedModeBanner: false,
          navigatorKey: NavigationService.navigatorKey,
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
