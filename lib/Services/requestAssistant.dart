import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;

import '../configMaps.dart';


class RequestAssistant
{
  static Future<dynamic> getRequest(Uri url) async
  {
    Position position;

    http.Response response = await http.get(url);

    try
    {
      if(response.statusCode == 200)
      {
        String jsonData = response.body;
        var decodeData = jsonDecode(jsonData);
        return decodeData;
      }
      else
      {
        return "failed";
      }
    }
    catch(exp)
    {
      return "failed";
    }
  }
}