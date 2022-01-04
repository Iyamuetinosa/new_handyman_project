import 'package:handyman/Models/nearbyAvailableServices.dart';

class GeoFireAssistant
{
  static List<NearbyAvailableServices> nearByAvailableServicesList = [];

  static void removeServiceFromList(String key)
  {
    int index = nearByAvailableServicesList.indexWhere((element) => element.key == key);
    nearByAvailableServicesList.removeAt(index);
  }

  static void updateServiceNearbyLocation(NearbyAvailableServices nearbyServices)
  {
    int index = nearByAvailableServicesList.indexWhere((element) => element.key == nearbyServices.key);

    nearByAvailableServicesList[index].latitude = nearbyServices.latitude;
    nearByAvailableServicesList[index].longitude = nearbyServices.longitude;
  }
}