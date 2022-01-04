

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:handyman/AllScreens/mainscreen.dart';
import 'package:handyman/AllScreens/serviceProviderRegScreen.dart';
import 'package:handyman/configMaps.dart';

import '../main.dart';
import 'ServiceProviderMapScreen.dart';

class ServiceSelectionScreen extends StatefulWidget
{
  static const String idScreen = "serviceSelectionScreen";
  bool serviceProvider;
  ServiceSelectionScreen({this.serviceProvider});

  @override
  _ServiceSelectionScreenState createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {

  StreamSubscription _pCheck;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageCheck();
  }



  void pageCheck()async {

    if(widget.serviceProvider == true) {
      _pCheck =
          usersRef
              .child(firebaseUser.uid)
              .onValue
              .listen((event) {
            final data = new Map<String, dynamic>.from(event.snapshot.value);
            final serviceDbRef = data['service_ref'] as String;
            final serviceName = data["service_name"] as String;
            userChkRef
                .child(firebaseUser.uid)
                .onValue
                .listen((event) {
              if (event.snapshot.value != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    ServiceProviderMapScreen(
                        serviceName: serviceName, serviceDbRef: serviceDbRef)));
              }
            });
          });
    }

    // usersRef.child(firebaseUser.uid).once().then((DataSnapshot dataSnapshot)
    // {
    //   if(dataSnapshot != null)
    //   {
    //     serviceDbRef = dataSnapshot.value['service_ref'];
    //     serviceName = dataSnapshot.value["service_name"];
    //   }
    //   Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderMapScreen(serviceName: serviceName, serviceDbRef: serviceDbRef)));
    //
    // });
  }
  @override
  Widget build(BuildContext context) {
    String name, dbRef, appBarTitle;
    if(widget.serviceProvider != true)
    {appBarTitle = "Services Selection Panel";}
    else
    { appBarTitle = "Offer Services Panel";}
    //widget.name?? 'Service Map'

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.grey[600],

        title: Text(
          appBarTitle,
          style: TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/babysitter.jpg"),
                        iconSize: 60.0,
                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Baby Sitter";
                            dbRef = "babysitter";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Baby Sitter";
                            dbRef = "babysitter";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }

                          },
                      ),
                      Text(
                        "Baby Sitter\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),

                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/beautician.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Beautician";
                            dbRef = "beautician";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Beautician";
                            dbRef = "beautician";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Beautician\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),
                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/cab_icon.jpg"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Cab Services";
                            dbRef = "cab_services";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Cab Services";
                            dbRef = "cab_services";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }

                        },
                      ),
                      Text(
                        "Cab\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),
                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/canopyRentals.jpg"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Canopy Rentals";
                            dbRef = "canopy_rentals";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Canopy Rentals";
                            dbRef = "canopy_rentals";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }

                        },
                      ),
                      Text(
                        "Canopy\nRentals",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),

              Divider(
                height: 30.0,
                color: Colors.grey[800],
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/car_hire.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Car Hire";
                            dbRef = "car_hire";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Car Hire";
                            dbRef = "car_hire";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Car Hire\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),

                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/carpentry.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Carpentry Services";
                            dbRef = "carpentry";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Carpentry Services";
                            dbRef = "carpentry";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }

                        },
                      ),
                      Text(
                        "Carpentry\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),
                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/cobbler.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Cobbler Services";
                            dbRef = "cobbler";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Cobbler Services";
                            dbRef = "cobbler";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }

                        },
                      ),
                      Text(
                        "Cobbler\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),
                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/dry_cleaner.jpg"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Dry Cleaner";
                            dbRef = "dry_cleaner";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Dry Cleaner";
                            dbRef = "dry_cleaner";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Dry Cleaning\nRentals",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),

                      ),
                    ],
                  ),
                ],
              ),

              Divider(
                height: 30.0,
                color: Colors.grey[800],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/electrician.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Electricians";
                            dbRef = "electrician";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Electricians";
                            dbRef = "electrician";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Electrician\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),

                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/electronic_repairs.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Electronic Repairers";
                            dbRef = "electronic_repairs";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Electronic Repairers";
                            dbRef = "electronic_repairs";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Electronic\nRepairs\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),
                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/errand_runner.jpg"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Errand Runner";
                            dbRef = "errand_runner";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Errand Runner";
                            dbRef = "errand_runner";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Errand\nRunner\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),
                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/fashion_and_assessories.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Fashion/Accessories";
                            dbRef = "fashion_accessories";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Fashion/Accessories";
                            dbRef = "fashion_accessories";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Fashion\nAnd\nAccessories",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),

                      ),
                    ],
                  ),
                ],
              ),

              Divider(
                height: 30.0,
                color: Colors.grey[800],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/food_and_kitchen.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Food & Kitchen";
                            dbRef = "food_kitchen";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Food & Kitchen";
                            dbRef = "food_kitchen";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Food\nAnd\nKitchen",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),

                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/hairdressing.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Hair Dressers";
                            dbRef = "hair_dressing";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Hair Dressers";
                            dbRef = "hair_dressing";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Hair\nCut/Dressing\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Image.asset("images/home_tutor.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Home Tutor";
                            dbRef = "home_tutor";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Home Tutor";
                            dbRef = "home_tutor";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }

                        },
                      ),
                      Text(
                        "Home\nTutor\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Image.asset("images/housekeeping.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "House Keepers";
                            dbRef = "house_keeping";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "House Keepers";
                            dbRef = "house_keeping";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "House\nKeeping\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),

                      ),
                    ],
                  ),
                ],
              ),

              Divider(
                height: 30.0,
                color: Colors.grey[800],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/mechanic.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Mechanic";
                            dbRef = "mechanic";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Mechanic";
                            dbRef = "mechanic";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }

                          Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));

                        },
                      ),
                      Text(
                        "Mechanic\nService",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),

                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/painter.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Painters";
                            dbRef = "painter";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Painters";
                            dbRef = "painter";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Painter\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Image.asset("images/cake_and_pastries.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Pastries";
                            dbRef = "pastries";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Pastries";
                            dbRef = "pastries";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Pastries\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Image.asset("images/parker_and_movers.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Movers";
                            dbRef = "packer_movers";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Movers";
                            dbRef = "packer_movers";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Packers\nand\nMovers",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),

                      ),
                    ],
                  ),
                ],
              ),

              Divider(
                height: 30.0,
                color: Colors.grey[800],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/photographer.jpg"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Photographer";
                            dbRef = "photographer";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Photographer";
                            dbRef = "photographer";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Photography\nService",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),

                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/plumber.png"),
                        iconSize: 65.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Plumber";
                            dbRef = "plumber";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Plumber";
                            dbRef = "plumber";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "PLumber\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Image.asset("images/property_agent.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Property Agent";
                            dbRef = "property_agent";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Property Agent";
                            dbRef = "property_agent";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Property\nAgent\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Image.asset("images/tailoring.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Tailor";
                            dbRef = "tailor";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Tailor";
                            dbRef = "tailor";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Tailoring\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),

                      ),
                    ],
                  ),
                ],
              ),

              Divider(
                height: 30.0,
                color: Colors.grey[800],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/tow_serivice.jpg"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Tow Services";
                            dbRef = "tow_services";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Tow Services";
                            dbRef = "tow_services";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Tow Truck\nService",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),

                  Column(
                    children: [

                      IconButton(
                        icon: Image.asset("images/tricycle_services.jpg"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Tricycle";
                            dbRef = "tricycle";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Tricycle";
                            dbRef = "tricycle";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Tricycle\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Image.asset("images/trucks_and_pickup_hiring.png"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Trucks Hire";
                            dbRef = "trucks_pickup";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Trucks Hire";
                            dbRef = "trucks_pickup";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Truck\nHire\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Image.asset("images/welding_services.jpg"),
                        iconSize: 60.0,

                        onPressed: ()
                        {
                          if(widget.serviceProvider != true)
                          {
                            name = "Welders";
                            dbRef = "welders";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen(name: name, dbRef: dbRef)));
                          }
                          else
                          {
                            name = "Welders";
                            dbRef = "welders";
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderRegScreen(name: name, dbRef: dbRef)));
                          }
                        },
                      ),
                      Text(
                        "Welding\nServices",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0, fontFamily: "Brand Bold", color: Colors.red),

                      ),
                    ],
                  ),
                ],
              ),

              Divider(
                height: 30.0,
                color: Colors.grey[800],
              ),


            ],
          ),

        ),
      ),

    );


  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    _pCheck.cancel();
    super.deactivate();
  }

}
