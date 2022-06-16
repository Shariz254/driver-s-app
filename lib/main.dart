import 'package:driver_app/splashScreens/driver_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(
      MyApp(
          child: MaterialApp(
            title: "Driver's App",
            theme: ThemeData(
                primaryColor: Colors.blue[400]
            ),

            home: DriverSplashScreen(),

            debugShowCheckedModeBanner: false,
          )
      )
  );
}

class MyApp extends StatefulWidget
{

  final Widget? child;

  MyApp({this.child});

  static void restartApp(BuildContext context){
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
{

  Key key = UniqueKey();

  void restartApp(){
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child!,);
  }
}
