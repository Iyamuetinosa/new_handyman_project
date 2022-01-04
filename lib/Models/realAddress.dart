import 'package:geocoder/model.dart';

class RealAddress
{
  String placeFormattedAddress;
  String placeName;
  String placeId;
  double latitude;
  double longitude;

  RealAddress(
      {this.placeFormattedAddress,
      this.placeName,
      this.placeId,
      this.latitude,
      this.longitude});
}