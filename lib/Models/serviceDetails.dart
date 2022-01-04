import 'package:google_maps_flutter/google_maps_flutter.dart';

class ServiceDetails
{
  String pickup_address;
  String databaseRefName;
  String serviceName;

  String dropoff_address;
  String service_request_id;
  String user_name;
  String user_phone;
  LatLng pickup;
  LatLng dropoff;

  ServiceDetails(
      {this.pickup_address,
      this.dropoff_address,
      this.service_request_id,
      this.user_name,
      this.user_phone,
      this.pickup,
      this.dropoff,
      this.serviceName,
      this.databaseRefName,
      });
}