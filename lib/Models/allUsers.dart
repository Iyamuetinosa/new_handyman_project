import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Users
{
  String id;
  String address;
  String email;
  String firstName;
  String lastName;
  String phone;

  Users(
      {this.id,
      this.address,
      this.email,
      this.firstName,
      this.lastName,
      this.phone});

  Users.fromSnapshot(DataSnapshot dataSnapshot)
  {
    id = dataSnapshot.key;
    email = dataSnapshot.value["email"];
    firstName = dataSnapshot.value["firstName"];
    lastName = dataSnapshot.value["lastName"];
    phone = dataSnapshot.value["phone"];
    address = dataSnapshot.value["address"];
  }
}
