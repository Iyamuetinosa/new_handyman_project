import 'package:firebase_database/firebase_database.dart';

class Services
{
  String bizName;
  String regNumber;
  String serviceBrand;
  String serviceColour;
  String serviceModel;
  String id;
  String serviceUserAddress;
  String serviceUserPhone;
  String serviceUsername;


  Services(
      {this.bizName,
      this.regNumber,
      this.serviceBrand,
      this.serviceColour,
      this.serviceModel,
      this.id,
      this.serviceUserAddress,
      this.serviceUserPhone,
      this.serviceUsername});

  Services.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id = dataSnapshot.key;
    bizName = dataSnapshot.value["bizName"];
    regNumber = dataSnapshot.value["regNumber"];
    serviceBrand = dataSnapshot.value["serviceBrand"];
    serviceModel = dataSnapshot.value["serviceModel"];
    serviceUserAddress = dataSnapshot.value["serviceUserAddress"];
    serviceUserPhone = dataSnapshot.value["serviceUserPhone"];
    serviceUsername = dataSnapshot.value["serviceUsername"];
    serviceColour = dataSnapshot.value["serviceColour"];

  }
}