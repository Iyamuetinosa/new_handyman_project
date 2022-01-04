import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:handyman/AllScreens/newServiceScreen.dart';
import 'package:handyman/Models/serviceDetails.dart';
import 'package:handyman/Services/assistantMethods.dart';
import 'package:handyman/configMaps.dart';

import '../main.dart';

class NotificationDialog extends StatelessWidget {
  // const NotificationDialog({Key key}) : super(key: key);

  final ServiceDetails serviceDetails;

  NotificationDialog({this.serviceDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30.0,),
            Image.asset("images/taxi.png", width: 120.0,),
            SizedBox(height: 18.0,),
            Text("New Service Request", style: TextStyle(fontFamily: "Brand Bold", fontSize: 18.0,color: Colors.blue),),
            SizedBox(height: 30.0,),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/pickicon.png", height: 16.0,width: 16.0,),
                      SizedBox(width: 20.0,),
                      Expanded(child: Container(child: Text(serviceDetails.pickup_address, maxLines: 3, style: TextStyle(fontSize: 18.0, color: Colors.green),))),
                    ],
                  ),

                  SizedBox(height: 15.0,),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/desticon.png", height: 16.0,width: 16.0,),
                      SizedBox(width: 20.0,),
                      Expanded(child: Container(child: Text(serviceDetails.dropoff_address, maxLines: 3, style: TextStyle(fontSize: 18.0, color: Colors.red),))),
                    ],
                  ),
                  SizedBox(height: 15.0,),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Divider(height: 2.0,color: Colors.blue,thickness: 2.0,),
            SizedBox(height: 8.0,),
            Padding(
                padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: ()
                      {
                        assetsAudioPlayer.stop();
                        Navigator.pop(context);
                      },
                      child: AutoSizeText(
                      "Cancel".toUpperCase(),
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontFamily: "Brand Bold",
                        ),
                      ),
                  ),
                  SizedBox(width: 10.0,),

                  ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          // side: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    child: AutoSizeText(
                      "Accept".toUpperCase(),
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Brand Bold",
                          color: Colors.white
                      ),
                    ),

                    onPressed: ()
                    {
                      assetsAudioPlayer.stop();
                      checkAvailabilityOfService(context);

                    },
                  ),

                ],
              ),
            )

          ],
        ),
      ),
    );
  }


  void checkAvailabilityOfService(context)
  {
    offerServiceRef.child(serviceDetails.databaseRefName).child(firebaseUser.uid).child("request").once().then((DataSnapshot dataSnapShot)
    {
      Navigator.pop(context);
      String theServiceId = "";
      if(dataSnapShot.value !=null)
      {
        theServiceId= dataSnapShot.value.toString();
      }
      else
      {
        buildShowToast("this service is no more available");
      }

      if(theServiceId==serviceDetails.service_request_id)
      {
        offerServiceRef.child(serviceDetails.databaseRefName).child(firebaseUser.uid).child("request").set("accepted");
        AssistantMethods.disableServiceLiveLocationUpdate();
        Navigator.push(context, MaterialPageRoute(builder: (context)=> NewServiceScreen(serviceDetails: serviceDetails)));
      }
      else if(theServiceId == "cancelled")
      {
        buildShowToast("Request cancelled");
      }
      else if(theServiceId == "timeout")
      {
        buildShowToast("Request Timed out");
      }
      else
      {
        buildShowToast("this service is no more available");
      }
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

