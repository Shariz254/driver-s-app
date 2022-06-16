import 'package:driver_app/global/global.dart';
import 'package:driver_app/mainScreens/main_screen.dart';
import 'package:driver_app/splashScreens/driver_splash_screen.dart';
import 'package:driver_app/widgets/custom_text_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CarInfoScreen extends StatefulWidget
{
  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen>
{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController carModelController = TextEditingController();
  TextEditingController carNumberController = TextEditingController();
  TextEditingController carColorController = TextEditingController();

  List<String> carTypeList = ["uber-x", "uber-go", "bike"];
  String? selectedCarType;

  //save car info to Firebase db
  saveCarInfo()
  {
    Map driverCarInfoMap = {
      "car_color": carColorController.text.trim(),
      "car_number": carNumberController.text.trim(),
      "car_model": carModelController.text.trim(),
      "type": selectedCarType,
    };

    DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
    driversRef.child(currentFirebaseUser!.uid).child("car_details").set(driverCarInfoMap);

    Fluttertoast.showToast(msg: "Car details saved. Congratulations");

    Navigator.push(context, MaterialPageRoute(builder: (c) => const DriverSplashScreen()));

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.blueAccent,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 24,),
              Padding(
                padding: const EdgeInsets.only(top: 18.0, bottom: 10.0),
                child: Text(
                  "Car Details",
                  style: TextStyle(
                      fontSize: 26,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),

              const SizedBox(height: 14,),

              Form(
                  key: _formKey,
                  child: Center(
                    child: Column(

                        children: [
                          CustomTextField(
                            controller: carModelController,
                            hintText: "Car Model*",
                            isObscure: false,
                          ),

                          CustomTextField(
                            controller: carNumberController,
                            hintText: "Car Number*",
                            isObscure: false,
                          ),

                          CustomTextField(
                            controller: carColorController,
                            hintText: "Car Color*",
                            isObscure: false,
                          ),

                        ]

                    ),
                  )
              ),

              const SizedBox(height: 10,),
              DropdownButton(
                  iconSize:  20,
                  dropdownColor: Colors.white,
                  hint: const Text("Please Choose Car Type",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  ),
                  value: selectedCarType,
                  onChanged: (newValue){
                    setState(() {
                      selectedCarType = newValue.toString();
                    });
                  },

                items: carTypeList.map((car){
                  return DropdownMenuItem(
                      child: Text(
                        car,
                        style: const TextStyle(
                          color: Colors.black
                        ),
                      ),
                  value: car,
                  );
                }).toList(),
                  ),

              const SizedBox(height: 40,),

              ElevatedButton(
                  onPressed: ()
                  {
                    if(carColorController.text.isNotEmpty && carNumberController.text.isNotEmpty && carModelController.text.isNotEmpty && selectedCarType != null)
                      {
                        saveCarInfo();
                      }
                    // Navigator.push(context, MaterialPageRoute(builder: (c) => CarInfoScreen()));
                  },

                  style: ElevatedButton.styleFrom(
                      primary: Colors.lime
                  ),

                  child: const Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
