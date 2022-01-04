import 'package:flutter/cupertino.dart';
import 'package:handyman/Models/realAddress.dart';

class AppData extends ChangeNotifier
{
  RealAddress pickUpLocation, dropOffLocation;

  void updatePickUpLocationAddress(RealAddress pickUpAddress)
  {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }


  void updateDropOffLocationAddress(RealAddress dropOffAddress)
  {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}