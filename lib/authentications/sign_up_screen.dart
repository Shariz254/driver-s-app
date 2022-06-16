import 'package:driver_app/authentications/car_info_screen.dart';
import 'package:driver_app/authentications/login_screen.dart';
import 'package:driver_app/global/global.dart';
import 'package:driver_app/widgets/custom_text_field.dart';
import 'package:driver_app/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  validateForm()
  {
    if(nameController.text.length < 3)
    {
      Fluttertoast.showToast(msg: "Name must be atleast 3 characters");
    }
    else if(!emailController.text.contains("@"))
    {
      Fluttertoast.showToast(msg: "Email is NOT valid");
    }
    else if(phoneController.text.isEmpty)
    {
      Fluttertoast.showToast(msg: "Enter Phone Number");
    }
    else if(passwordController.text.length < 6)
    {
      Fluttertoast.showToast(msg: "Password must be atleast 6 characters");
    }
    else
    {
      saveDriverInfo();
    }
  }

  //saving to Firebase db
  saveDriverInfo() async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message: "Registering, Please Wait ..",);
        }
    );

    final User? firebaseUser = (
        await fAuth.createUserWithEmailAndPassword(
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
      Map driversMap = {
        "id": firebaseUser.uid,
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
      };

      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).set(driversMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account created successfully");

      Navigator.push(context, MaterialPageRoute(builder: (c) => CarInfoScreen()));


    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has NOT been created");
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
              const Padding(
                padding: EdgeInsets.only(top: 18.0, bottom: 10.0),
                child: Text(
                  "REGISTER AS A DRIVER",
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),

              Form(
                  key: _formKey,
                  child: Center(
                    child: Column(

                        children: [
                          CustomTextField(
                            controller: nameController,
                            hintText: "Name*",
                            isObscure: false,
                          ),

                          CustomTextField(
                            controller: emailController,
                            hintText: "Email*",
                            isObscure: false,
                          ),

                          CustomTextField(
                            controller: phoneController,
                            hintText: "Phone*",
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
                          "REGISTER".toUpperCase(),
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
                        // Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
                      }
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
                },
                child: const Text(
                  "Already Have an Account.? Login Here..",
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
