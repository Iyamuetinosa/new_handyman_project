import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handyman/Datahandler/appData.dart';
import 'package:handyman/Models/allUsers.dart';
import 'package:handyman/Models/realAddress.dart';
import 'package:handyman/Models/directionDetails.dart';
import 'package:handyman/Services/requestAssistant.dart';
import 'package:provider/provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../configMaps.dart';
import 'auth_service.dart';

class AssistantMethods
{
  static Future<String> searchCoordinateAddress(Position position, context) async
  {
    String placeAddress = "";
    String st1, st2,st3,st4;
    var url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    
    var response = await RequestAssistant.getRequest(Uri.parse(url));

    if(response != 'failed')
    {
      // placeAddress = response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][0]["long_name"];
      st2 = response["results"][0]["address_components"][1]["long_name"];
      st3 = response["results"][0]["address_components"][2]["long_name"];
      st4 = response["results"][0]["address_components"][3]["long_name"];
      placeAddress = st1 + ", " + st2 + ", " + st3 ;

      RealAddress userPickerUpAddress  = new RealAddress();

      userPickerUpAddress.latitude = position.latitude;
      userPickerUpAddress.longitude = position.longitude;
      userPickerUpAddress.placeName = placeAddress;
      
      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickerUpAddress);
    }

    return placeAddress;
  }


  static Future<DirectionDetails> obtainPlaceDirectionDetails(LatLng initialPosition, LatLng finalPosition) async
  {
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(Uri.parse(directionUrl));

    if(res =="failed")
    {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();

    directionDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;

  }

  static int calculateFares(DirectionDetails directionDetails)
  {
    double timeTraveledFare = (directionDetails.distanceValue / 60) * 0.020;
    double distanceTraveledFare = (directionDetails.distanceValue / 1000) * 0.02;
    double distanceTraveled = (directionDetails.distanceValue / 1000);
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;
    double totalFareNaira = totalFareAmount * 411.46;

    return totalFareNaira.truncate();
  }
  
  
  static void getCurrentOnlineUserInfo()async
  {
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;
    DatabaseReference reference = FirebaseDatabase.instance.reference().child("users").child(userId);

    reference.once().then((DataSnapshot dataSnapshot)
    {
      if(dataSnapshot.value != null)
      {
        userCurrentInfo = Users.fromSnapshot(dataSnapshot);
      }
    });
  }

  static double createRandomNumber(int num)
  {
    var random = Random();
    int radNumber = random.nextInt(num);
    return radNumber.toDouble();
  }
  static void disableServiceLiveLocationUpdate()
  {
    homeTabPageStreamSubscription.pause();
    Geofire.removeLocation(firebaseUser.uid);
  }

  static void enableServiceLiveLocationUpdate()
  {
    homeTabPageStreamSubscription.resume();
    Geofire.setLocation(firebaseUser.uid, currentPosition.latitude, currentPosition.longitude);
  }
}

