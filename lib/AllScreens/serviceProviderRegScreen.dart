import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:handyman/AllScreens/ServiceProviderMapScreen.dart';
import 'package:handyman/Services/assistantMethods.dart';
import 'package:handyman/configMaps.dart';

import '../main.dart';

class ServiceProviderRegScreen extends StatefulWidget {
  // const ServiceProviderRegScreen({Key? key}) : super(key: key);

  final String name;
  final String dbRef;
  ServiceProviderRegScreen({this.name, this.dbRef});

  @override
  _ServiceProviderRegScreenState createState() => _ServiceProviderRegScreenState();
}

class _ServiceProviderRegScreenState extends State<ServiceProviderRegScreen>
{


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssistantMethods.getCurrentOnlineUserInfo();
  }

  TextEditingController businessNameTextEditingController = TextEditingController();
  TextEditingController vehicleTypeTextEditingController = TextEditingController();
  TextEditingController vehicleModelTextEditingController = TextEditingController();
  TextEditingController vehicleNumberTextEditingController = TextEditingController();
  TextEditingController vehicleColorTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name + " Registration"?? 'Service Map'),
      ),
      backgroundColor: Colors.blueAccent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 22.0,),
              Image.asset("images/logo.png", width: 390.0,height: 250.0,),
              Padding(
                padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                child: Column(
                  children: [
                    SizedBox(height: 12.0,),
                    Text("Enter Business Details", style: TextStyle(fontFamily: "Brand-Bold", fontSize: 24.0),),

                    SizedBox(height: 26.0,),

                    TextField(
                      controller: businessNameTextEditingController,
                      decoration: buildBizRegInputDecoration("Business Name"),
                      style: TextStyle(fontSize: 15.0),
                    ),

                    SizedBox(height: 10.0,),

                    TextField(
                      controller: vehicleTypeTextEditingController,
                      decoration: buildBizRegInputDecoration("Vehicle/Service Type"),
                      style: TextStyle(fontSize: 15.0),
                    ),

                    SizedBox(height: 10.0,),

                    TextField(
                      controller: vehicleModelTextEditingController,
                      decoration: buildBizRegInputDecoration("Vehicle/Service Model"),
                      style: TextStyle(fontSize: 15.0),
                    ),

                    SizedBox(height: 10.0,),

                    TextField(
                      controller: vehicleColorTextEditingController,
                      decoration: buildBizRegInputDecoration("Vehicle Colour/Service Description"),
                      style: TextStyle(fontSize: 15.0),
                    ),

                    SizedBox(height: 10.0,),

                    TextField(
                      controller: vehicleNumberTextEditingController,
                      decoration: buildBizRegInputDecoration("Vehicle Number"),
                      style: TextStyle(fontSize: 15.0),
                    ),

                    SizedBox(height: 26.0,),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child:  ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: TextStyle(color: Colors.white),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.arrow_forward),
                              Padding(
                                padding: const EdgeInsets.only(left: 14.0, top: 10.0, bottom: 10.0),
                                child: Text("NEXT", style: TextStyle(fontSize: 18.0),),
                              )
                            ],
                          ),
                          onPressed: ()
                          {
                            if(businessNameTextEditingController.text.isEmpty)
                            {
                              buildShowToast("You must enter a business name..");
                            }
                            else if(vehicleTypeTextEditingController.text.isEmpty)
                            {
                              buildShowToast("You must enter a vehicle type..");
                            }
                            else if(vehicleModelTextEditingController.text.isEmpty)
                            {
                              buildShowToast("You must enter your vehicle model..");
                            }
                            else if(vehicleColorTextEditingController.text.isEmpty)
                            {
                              buildShowToast("You must enter your vehicle colour..");
                            }
                            else if(vehicleNumberTextEditingController.text.isEmpty)
                            {
                              buildShowToast("You must your vehicle number..");
                            }
                            else
                            {
                              saveBusinessInfo();
                            }
                          }
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration buildBizRegInputDecoration(String hint)
  {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 0.0)),
      contentPadding: const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
    );
  }

  void saveBusinessInfo()
  {
    String bizUserId = firebaseUser.uid;
    String bizUserName = "";
    String bizUserPhone = "";
    String bizUserHomeAd = "";

    usersRef.child(bizUserId).once().then((DataSnapshot dataSnapShot)
    {
      if(dataSnapShot.value != null)
      {
        bizUserName = dataSnapShot.value["firstName"] + " " + dataSnapShot.value["lastName"];
        bizUserHomeAd = dataSnapShot.value["address"];
        bizUserPhone = dataSnapShot.value["phone"];

      }

      Map bizInfoMap =
      {
        "bizName": businessNameTextEditingController.text.trim(),
        "serviceModel": vehicleTypeTextEditingController.text.trim(),
        "serviceBrand": vehicleModelTextEditingController.text.trim(),
        "serviceColour": vehicleColorTextEditingController.text.trim(),
        "regNumber": vehicleNumberTextEditingController.text.trim(),
        "serviceReg": widget.name,
        "serviceUsername": bizUserName,
        "serviceUserPhone": bizUserPhone,
        "serviceUserAddress": bizUserHomeAd,

      };
      String serviceName = widget.name??"Service";
      String serviceDbRef = widget.dbRef??"";

      offerServiceRef.child(widget.dbRef).child(bizUserId).set(bizInfoMap);
      usersRef.child(bizUserId).child("service_ref").set(serviceDbRef);
      usersRef.child(bizUserId).child("service_name").set(serviceName);
      // Navigator.pushNamedAndRemoveUntil(context, ServiceProviderMapScreen.idScreen, (route) => false);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderMapScreen(serviceName: serviceName, serviceDbRef:serviceDbRef)));
    });





  }

  Future<bool> buildShowToast(String message) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 20.0,
    );
  }


}

