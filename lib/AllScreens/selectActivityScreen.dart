import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:handyman/AllScreens/serviceSelectionScreen.dart';
import 'package:handyman/Services/auth_service.dart';
import 'package:handyman/widgets/custom_dialog.dart';
import 'package:handyman/main.dart';

import '../configMaps.dart';


class SelectActivityScreen extends StatelessWidget
{
  bool serviceProvider = true;


  static const String idScreen = "selectActivityScreen";
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        automaticallyImplyLeading: true,
        title: Text("Select An Activity", style: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                try{
                  AuthService auth = Provider.of(context).auth;
                  await auth.signOut();
                  print("Signed Out");
                }
                catch(e)
                {
                  print(e);
                }
              },
              icon: Icon(Icons.exit_to_app)
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  
                  SizedBox(height: 40.0,),
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => CustomDialog(
                              title: ("Searching for a Handyman"),
                              description: ("Please take your time to read through reviews and ratings before you engage services"),
                              primaryButtonText: ("Find a Handyman"),
                              primaryButtonRoute: ("/ServiceSelectionScreen"),
                              serviceProvider : false,

                          )
                      );
                      // Navigator.pushNamedAndRemoveUntil(context, ServiceSelectionScreen.idScreen, (route) => false);
                    },
                    icon: Icon(Icons.person_search_rounded, color: Colors.red, size: 50.0,),
                    label: Text(
                      "Click here\nto search\nfor any\nhandyman \nservice\nof your \nchoice",
                      style: TextStyle(fontFamily: "Brand Bold", fontSize: 25.0),
                    ),
                  ),

                  SizedBox(height: 45.0,),
                  TextButton.icon(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => CustomDialog(
                              title: ("Wish to render Handyman Services?"),
                              description: ("Please Properly Elaborate on your precise expertise, because your services will be rated for feature review"),
                              primaryButtonText: ("Provide Handyman Service"),
                              primaryButtonRoute: ("/ServiceSelectionScreen"),
                              serviceProvider: true,
                          )
                      );
                      // Navigator.pushNamedAndRemoveUntil(context, ServiceSelectionScreen.idScreen, (route) => false);
                    },
                    icon: Icon(Icons.hardware, color: Colors.red, size: 50.0,),
                    label: Text(
                      "Click here \nto provide \nhandyman \nservices",
                      style: TextStyle(fontFamily: "Brand Bold", fontSize: 25.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    
  }



    
}
