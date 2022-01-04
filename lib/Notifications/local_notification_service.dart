

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:handyman/AllScreens/ServiceProviderMapScreen.dart';
import '../configMaps.dart';
import '../main.dart';


class LocalNotificationService
{
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context){
    final InitializationSettings initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher')
    );

    _notificationsPlugin.initialize(initializationSettings, onSelectNotification: (route) async
    {
      if(route !=null)
      {
        if(route == "services")
        {

        }
        // Navigator.of(context).pushNamed(route);
      }
    });


  }

  static void display(RemoteMessage message) async
  {
  try {
    final id = DateTime.now().millisecondsSinceEpoch ~/1000;
    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        "handyman app",
        "handyman channel",
        "handyman services channel",
        importance: Importance.max,
        priority: Priority.high
      )
    );


      await _notificationsPlugin.show(
          id,
          message.notification.title,
          message.notification.body,
          notificationDetails,
          payload: message.data["route"],

      );
    // String serviceName = message.data["service_name"];
    // final serviceDbRef = message.data["db_ref"];
    // final serviceRequestId = message.data["service_request_id"];
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderMapScreen(serviceName: serviceName, serviceDbRef:serviceDbRef, serviceRequestId:serviceRequestId)));
  } on Exception catch (e) {
    print(e);
  }
  }


  Future<String> getSPToken() async
  {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String token = await firebaseMessaging.getToken();
    print("this is your token::");
    print(token);
    usersRef.child(firebaseUser.uid).child("token").set(token);

    firebaseMessaging.subscribeToTopic("serviceproviders");
    firebaseMessaging.subscribeToTopic("servicerequests");
    // return token;
  }
  //
  // void retrieveServiceRequestId(BuildContext context)async
  // {
  //   newServiceRequestRef.child(widget.serviceDbRef).child(widget.serviceRequestId??null).once()
  //       .then((DataSnapshot dataSnapshot)
  //   {
  //     if(dataSnapshot.value !=null)
  //     {
  //       double pickUpLocationLat = double.parse(dataSnapshot.value['pickup']['latitude'].toString());
  //       double pickUpLocationLng = double.parse(dataSnapshot.value['pickup']['longitude'].toString());
  //       String pickUpAddress =dataSnapshot.value['pickup_address'].toString();
  //
  //       double dropOffLocationLat = double.parse(dataSnapshot.value['dropoff']['latitude'].toString());
  //       double dropOffLocationLng = double.parse(dataSnapshot.value['dropoff']['longitude'].toString());
  //       String dropOffAddress =dataSnapshot.value['dropoff_address'].toString();
  //
  //       ServiceDetails serviceDetails = ServiceDetails();
  //       serviceDetails.service_request_id = widget.serviceRequestId;
  //       serviceDetails.pickup_address = pickUpAddress;
  //       serviceDetails.dropoff_address = dropOffAddress;
  //       serviceDetails.pickup = LatLng(pickUpLocationLat, pickUpLocationLng);
  //       serviceDetails.dropoff = LatLng(dropOffLocationLat, dropOffLocationLng);
  //       // serviceDetails.user_phone = widget.serviceRequestId;
  //       // serviceDetails.user_name = widget.serviceRequestId;
  //
  //       print("this is your information::");
  //       print("this is your pick up address:: " +serviceDetails.pickup_address);
  //       print("this is your drop off address:: "+ serviceDetails.dropoff_address);
  //       print(serviceDetails.service_request_id);
  //
  //       showDialog(
  //         context: context,
  //         barrierDismissible: false,
  //         builder: (BuildContext context) => NotificationDialog(serviceDetails: serviceDetails,),
  //       );
  //
  //     }
  //   });
  // }


// String getServiceRequestId(RemoteMessage message)
// {
//   String serviceRequestId = "",serviceName = "", serviceDdRef="";
//
//   if(message!=null)
//   {
//     serviceRequestId = message.data['service_request_id'];
//     serviceName = message.data['service_name'];
//     serviceDdRef = message.data['db_ref'];
//   }
//   return serviceRequestId;
// }




}