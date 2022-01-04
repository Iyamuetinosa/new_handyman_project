import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handyman/AllScreens/serviceSelectionScreen.dart';
import 'package:handyman/Models/serviceDetails.dart';
import 'package:handyman/Models/services.dart';
import 'package:handyman/Notifications/local_notification_service.dart';
import 'package:handyman/Notifications/notificationDialog.dart';
import 'package:handyman/Services/assistantMethods.dart';
import 'package:handyman/configMaps.dart';
import 'package:handyman/main.dart';
import 'package:handyman/widgets/Divider.dart';

class  ServiceProviderMapScreen extends StatefulWidget {
  // const ({Key? key}) : super(key: key);
  static const String idScreen = "serviceProviderMapScreen";
  final String serviceName;
  final String serviceDbRef;
  final String serviceRequestId;
  ServiceProviderMapScreen({this.serviceName, this.serviceDbRef, this.serviceRequestId});

  @override
  _ServiceProviderMapScreenState createState() => _ServiceProviderMapScreenState();
  bool serviceProvider;
}

class _ServiceProviderMapScreenState extends State<ServiceProviderMapScreen> with SingleTickerProviderStateMixin
{
  // TabController tabController;

  Completer<GoogleMapController> _sPControllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //
  //   tabController = TabController(length: 4, vsync: this);
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   tabController.dispose();
  // }

  static final CameraPosition  _sPkGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  var geoLocator = Geolocator();

  String serviceProviderStatusText = "Offline";
  Color serviceProviderStatusColor = Colors.red;
  Color serviceProviderButtonTextColor = Colors.red;
  bool isServiceAvailable = false;

  @override
  void initState()
  {
    super.initState();
    getCurrentServiceProviderInfo();
    retrieveServiceRequestId(context);

  }
  User currentfirebaseUser;


  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    // String address = await AssistantMethods.searchCoordinateAddress(position, context);
    //
    // print("This is your address :: " + address);

  }
  
  void getCurrentServiceProviderInfo()async
  {
    currentfirebaseUser = FirebaseAuth.instance.currentUser;
    offerServiceRef.child(widget.serviceDbRef).child(currentfirebaseUser.uid).once()
        .then((DataSnapshot dataSnapshot)
    {
      if(dataSnapshot.value!=null)
      {
        servicesInformation = Services.fromSnapshot(dataSnapshot);
      }
    });
    // LocalNotificationService localNotificationService = LocalNotificationService();
    // LocalNotificationService.initialize(context);
    // localNotificationService.getSPToken();
    
  }

  void retrieveServiceRequestId(BuildContext context)async
  {
    if(widget.serviceRequestId!=null)
    {
      newServiceRequestRef.child(widget.serviceDbRef??null).child(widget.serviceRequestId??null).once()
          .then((DataSnapshot dataSnapshot)
      {
        if(dataSnapshot.value !=null)
        {
          double pickUpLocationLat = double.parse(dataSnapshot.value['pickup']['latitude'].toString());
          double pickUpLocationLng = double.parse(dataSnapshot.value['pickup']['longitude'].toString());
          String pickUpAddress =dataSnapshot.value['pickup_address'].toString();

          double dropOffLocationLat = double.parse(dataSnapshot.value['dropoff']['latitude'].toString());
          double dropOffLocationLng = double.parse(dataSnapshot.value['dropoff']['longitude'].toString());
          String dropOffAddress =dataSnapshot.value['dropoff_address'].toString();
          String ridersName = dataSnapshot.value['user_name'].toString();
          String riderPhone = dataSnapshot.value['user_phone'].toString();




          ServiceDetails serviceDetails = ServiceDetails();
          serviceDetails.service_request_id = widget.serviceRequestId;
          serviceDetails.pickup_address = pickUpAddress;
          serviceDetails.dropoff_address = dropOffAddress;
          serviceDetails.pickup = LatLng(pickUpLocationLat, pickUpLocationLng);
          serviceDetails.dropoff = LatLng(dropOffLocationLat, dropOffLocationLng);
          serviceDetails.user_phone = riderPhone;
          serviceDetails.user_name = ridersName;
          serviceDetails.databaseRefName = widget.serviceDbRef;
          serviceDetails.serviceName = widget.serviceName;


          print("this is your information::");
          print("this is your pick up address:: " +serviceDetails.pickup_address);
          print("this is your drop off address:: "+ serviceDetails.dropoff_address);
          print(serviceDetails.service_request_id);

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => NotificationDialog(serviceDetails: serviceDetails,),
          );

        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // retrieveServiceRequestId(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serviceName??"Services"),
      ),
        drawer: Container(
          color: Colors.white,
          width: 255.0,
          child: Drawer(
            child: ListView(
              children: [
                //Drawer Header
                Container(
                  height: 165.0,
                  child: DrawerHeader(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      children: [
                        Image.asset("images/user_icon.png", height: 65.0, width: 65.0,),
                        SizedBox(width: 16.0,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Profile Name", style: TextStyle(fontSize: 16.0, fontFamily: "Brand-Bold"),),
                            SizedBox(height: 6.0,),
                            Text("View Profile"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                DividerWidget(),
                SizedBox(height: 12.0,),

                //Drawer Body controllers

                ListTile(
                  leading: Icon(Icons.history, color: Colors.blueAccent),
                  title: Text("History", style: TextStyle(fontSize: 15.0, ),),
                ),
                ListTile(
                  leading: Icon(Icons.person, color: Colors.blueAccent),
                  title: Text("View Profile", style: TextStyle(fontSize: 15.0, ),),
                ),
                ListTile(
                  leading: Icon(Icons.star, color: Colors.blueAccent),
                  title: Text("Rating", style: TextStyle(fontSize: 15.0, ),),
                ),
                GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceSelectionScreen(serviceProvider: false)));
                  },
                  child: ListTile(
                    leading: Icon(Icons.person_search_rounded, color: Colors.blueAccent),
                    title: Text("Request Service", style: TextStyle(fontSize: 15.0, ),),
                  ),
                ),
                GestureDetector(
                  onTap: ()
                  {
                    // FirebaseAuth.instance.signOut();
                    // Navigator.pushNamedAndRemoveUntil(context, , (route) => false);
                  },
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.red),
                    title: Text("Sign Out", style: TextStyle(fontSize: 15.0, ),),
                  ),
                ),


              ],
            ),
          ),
        ),
      body: Stack(
        children: [
          GoogleMap(
            // padding: EdgeInsets.only(bottom: bottomPaddingOfMAp),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _sPkGooglePlex,
            mapToolbarEnabled: true,

            myLocationEnabled: true,
            // zoomGesturesEnabled: true,
            // zoomControlsEnabled: true,
            //

            onMapCreated: (GoogleMapController controller)
            {
              _sPControllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              locatePosition();

            },

          ),

          //online offline service container
          Container(
            height: 110.0,
            width: double.infinity,
            // color: Colors.black54,

          ),
          Positioned(
            top: 30.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child:  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: serviceProviderStatusColor,

                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 14.0, top: 10.0, bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(serviceProviderStatusText, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),),
                                Icon(Icons.phone_android, color: Colors.white,size: 26.0,),
                              ],
                            ),
                          )
                        ],
                      ),
                      onPressed: ()
                      {

                        if(isServiceAvailable != true)
                        {
                          makeServiceProviderOnlineNow();
                          getLocationLiveUpdates();
                          setState(() {
                            serviceProviderStatusColor= Colors.green;
                            serviceProviderStatusText = "Online";
                            isServiceAvailable = true;
                          });

                          buildShowToast("you are now online", Colors.green);

                        }
                        else
                        {
                          makeServiceOfflineNow();
                        }
                      },
                  ),
                ),
              ],
            ),
          )

          //Drawer Button

        ],
      ),

    );
  }

  void makeServiceOfflineNow() async {
    // retrieveServiceRequestId();

    Geofire.removeLocation(firebaseUser.uid);
    offerServiceRef.child(widget.serviceDbRef??"services").child(firebaseUser.uid).child("request").remove();
    // offerServiceRef.child(widget.serviceDbRef??"services").child(firebaseUser.uid).child("new_request") = null;
    buildShowToast("you are now offline", Colors.red);

    setState(() {
      serviceProviderStatusColor= Colors.red;
      // serviceProviderButtonTextColor = Colors.white;
      serviceProviderStatusText = "Offline";
      isServiceAvailable = false;
    });
  }

  Future<bool> buildShowToast(String message, Color bgColor) {

    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 20.0,
    );
  }

  
  void makeServiceProviderOnlineNow() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availableServices");
    Geofire.setLocation(firebaseUser.uid, currentPosition.latitude, currentPosition.longitude);

    // serviceRequestRef.child(widget.serviceDbRef??"services").set("available");
    offerServiceRef.child(widget.serviceDbRef).child(firebaseUser.uid).child("request").set("waiting");

    offerServiceRef.child(widget.serviceDbRef??"services").onValue.listen((event) { });



  }

  void getLocationLiveUpdates()
  {

    homeTabPageStreamSubscription = Geolocator.getPositionStream().listen((Position position)
    {
      currentPosition = position;
      if(isServiceAvailable == true)
      {
        Geofire.setLocation(firebaseUser.uid, position.latitude, position.longitude);
      }
      LatLng latLng = LatLng(position.latitude, position.longitude);
      newGoogleMapController.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }
}
