import 'package:driver_app/authentications/sign_up_screen.dart';
import 'package:driver_app/global/global.dart';
import 'package:driver_app/mainScreens/main_screen.dart';
import 'package:driver_app/splashScreens/driver_splash_screen.dart';
import 'package:driver_app/widgets/custom_text_field.dart';
import 'package:driver_app/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget
{

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /**form validation done here**/
  validateForm(){

    if(!emailController.text.contains("@"))
      {
        Fluttertoast.showToast(msg: "Invalid Email");
      }
      else if(passwordController.text.isEmpty)
      {
        Fluttertoast.showToast(msg: "Password is Required!");
      }
    else
    {
      LoginDriverData();
    }
  }

  //saving to Firebase db
  LoginDriverData() async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message: "Please Wait ..,",);
        }
    );

    final User? firebaseUser = (
        await fAuth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),

          //trim is to remove extra space typed(white space)
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: " +msg.toString());
        })
    ).user;

    if(firebaseUser != null)
    {

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Login Successfull");

      Navigator.push(context, MaterialPageRoute(builder: (c) => const DriverSplashScreen()));


    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error while Logging In");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: Column(
            children: [
              SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.only(top: 18.0, bottom: 10.0),
                child: Container(
                  width: 280,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/main_logo.jpg"),
                      // fit: BoxFit.cover,
                      // colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(top: 18.0, bottom: 10.0),
                child: Text(
                  "Login As Driver".toUpperCase(),
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Form(
                  key: _formKey,
                  child: Center(
                    child: Column(

                      children: [
                        CustomTextField(
                          controller: emailController,
                          hintText: "Email*",
                          isObscure: false,
                        ),

                        CustomTextField(
                          controller: passwordController,
                          hintText: "Password*",
                          isObscure: true,
                        ),

                      ]

                    ),
                  )
              ),

              SizedBox(height: 30,),

              Center(
                child: Container(
                  height: 50,
                  width: 190,
                  child: TextButton(
                      child: Text(
                          "LOGIN".toUpperCase(),
                          style: TextStyle(fontSize: 18)
                      ),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(13)),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.orangeAccent),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(color: Colors.blue)
                              )
                          )
                      ),
                      onPressed: () {
                        validateForm();
                        // Navigator.push(context, MaterialPageRoute(builder: (c) => MainScreen()));
                      }
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c) => SignUpScreen()));

                },
                child: const Text(
                  "Don't Have an Account.? Register Here..",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
