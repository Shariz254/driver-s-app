import 'dart:async';
import 'package:driver_app/authentications/login_screen.dart';
import 'package:driver_app/global/global.dart';
import 'package:driver_app/mainScreens/main_screen.dart';
import 'package:flutter/material.dart';

class DriverSplashScreen extends StatefulWidget
{
  const DriverSplashScreen({Key? key}) : super(key: key);

  @override
  State<DriverSplashScreen> createState() => _DriverSplashScreenState();
}

class _DriverSplashScreenState extends State<DriverSplashScreen>
{

  startTimer(){
    Timer(const Duration(seconds: 3), () async
      {
        //checking if user is already logged in
        if(await fAuth.currentUser != null)
        {
          currentFirebaseUser = fAuth.currentUser;
          Navigator.push(context, MaterialPageRoute(builder: (c) => MainScreen()));

        } else {
          //send user to home screen
          Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
        }

      }

    );
  }


  @override
  void initState() {
    super.initState();

    startTimer();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 280,
                height: 280,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/driver_logo.png"),
                    // fit: BoxFit.cover,
                    // colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                  ),
                ),
              ),

              Text(
                "Driver's App",
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
