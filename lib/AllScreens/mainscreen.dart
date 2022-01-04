import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handyman/AllScreens/searchScreen.dart';
import 'package:handyman/AllScreens/serviceSelectionScreen.dart';
import 'package:handyman/AllScreens/subLoginScreen.dart';
import 'package:handyman/Datahandler/appData.dart';
import 'package:handyman/Models/directionDetails.dart';
import 'package:handyman/Models/nearbyAvailableServices.dart';
import 'package:handyman/Services/assistantMethods.dart';
import 'package:handyman/Services/geoFireAssistant.dart';
import 'package:handyman/configMaps.dart';
import 'package:handyman/widgets/Divider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:handyman/widgets/noServiceAvailableDialog.dart';
import 'package:handyman/widgets/progressDialog.dart';
import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'serviceProviderRegScreen.dart';

class MainScreen extends StatefulWidget
{
  final String name;
  final String dbRef;
  MainScreen({this.name, this.dbRef});
  static const String idScreen = "mainScreen";
  @override
  _MainScreenState createState() => _MainScreenState();

  bool serviceProvider;
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin
{
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  DirectionDetails tripDirectionDetails;

  List<LatLng> pLineCoordinates = [];
  Set<Polyline> ploylineSet = {};


  var geoLocator = Geolocator();
  double bottomPaddingOfMAp = 0;
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  double rideDetailsContainerHeight = 0;
  double requestRideContainerHeight = 0;
  double searchContainerHeight = 300.0;

  bool drawerOpen = true;
  bool nearByAvailableServicesKeysLoaded = false;

  DatabaseReference serviceRequestRef;

  BitmapDescriptor nearByIcon;

  List<NearbyAvailableServices> availableServices;
  StreamSubscription _subscription;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssistantMethods.getCurrentOnlineUserInfo();
    activateListeners();
  }



  void saveServiceRequest()
  {
    serviceRequestRef = FirebaseDatabase.instance.reference().child("Service Requests").child(widget.dbRef?? 'services').push();

    var pickup = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;

    Map pickUpLocMap =
    {
      "latitude": pickup.latitude.toString(),
      "longitude": pickup.longitude.toString(),
    };

    Map dropOffLocMap =
    {
      "latitude": dropOff.latitude.toString(),
      "longitude": dropOff.longitude.toString(),
    };

    Map serviceInfoMap =
    {
      "service_provider_id": "waiting",
      "rating" : "3 stars",
      "pickup" : pickUpLocMap,
      "dropoff": dropOffLocMap,
      "created": DateTime.now().toString(),
      "user_name": userCurrentInfo.firstName ,
      "user_phone": userCurrentInfo.phone,
      "pickup_address": pickup.placeName,
      "dropoff_address": dropOff.placeName,
    };

    serviceRequestRef.set(serviceInfoMap);
  }

  void cancelServiceRequest()
  {
    serviceRequestRef.remove();
  }

  void displayRequestRideContainer()
  {
    setState(() {
      requestRideContainerHeight = 250.0;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMAp = 230.0;
      drawerOpen = true;
    });

    saveServiceRequest();
  }

  resetApp()
  {
    setState(() {
      searchContainerHeight = 300.0;
      rideDetailsContainerHeight = 0;
      requestRideContainerHeight = 0;
      bottomPaddingOfMAp = 230.0;
      drawerOpen = true;

      ploylineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      pLineCoordinates.clear();

    });

    locatePosition();
  }

  void displayRideDetailsContainer()async
  {
    await getPlaceDirection();

    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 250.0;
      bottomPaddingOfMAp = 230.0;
      drawerOpen = false;
    });
  }

  void locatePosition() async
  {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethods.searchCoordinateAddress(position, context);

    print("This is your address :: " + address);


    // initGeoFireListener();

  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    createIconMarker();
    return Scaffold(
      key: scaffoldKey,

      appBar: AppBar(
        title: Text(widget.name?? 'Service Map'),
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
                leading: Icon(Icons.info, color: Colors.blueAccent),
                title: Text("About", style: TextStyle(fontSize: 15.0, ),),
              ),
              GestureDetector(
                onTap: ()
                {
                  serviceRequestRef.remove();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceSelectionScreen(serviceProvider: true)));
                },
                child: ListTile(
                  leading: Icon(Icons.hardware, color: Colors.blueAccent),
                  title: Text("Offer Service", style: TextStyle(fontSize: 15.0, ),),
                ),
              ),
              GestureDetector(
                onTap: ()
                {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(context, SubLoginScreen.idScreen, (route) => false);
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
            padding: EdgeInsets.only(bottom: bottomPaddingOfMAp),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            mapToolbarEnabled: true,

            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: ploylineSet,
            markers: markersSet,
            circles: circlesSet,

            onMapCreated: (GoogleMapController controller)
            {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMAp = 300.0;
              });

              locatePosition();
            },

          ),

          //Drawer Button
          Positioned(
            top: 35.0,
            left: 22.0,
            child: GestureDetector(
              onTap: ()
              {
                if(drawerOpen)
                {
                  scaffoldKey.currentState.openDrawer();
                }
                else
                {
                  resetApp();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7,0.7),
                    )
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon((drawerOpen)?Icons.menu : Icons.close, color: Colors.black,),
                  radius: 20.0,
                ),
              ),
            ),
          ),

          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: searchContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6.0),
                      Text("Hi there", style: TextStyle(fontSize: 12.0),),
                      Text("where to?", style: TextStyle(fontSize: 20.0, fontFamily: "Brand-Bold"),),
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () async
                        {
                          var res = await Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchScreen()));
                          if(res == "obtainDirection")
                          {
                            displayRideDetailsContainer();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(Icons.search,color: Colors.blueAccent,),
                                SizedBox(width: 10.0,),
                                Text("Search Drop off"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0,),
                      Row(
                        children: [
                          Icon(Icons.home, color: Colors.grey,),
                          SizedBox(width: 12.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Provider.of<AppData>(context).pickUpLocation != null
                                    ?Provider.of<AppData>(context).pickUpLocation.placeName
                                    : "Add Home"
                              ),
                              SizedBox(height: 4.0,),
                              Text("Home Address", style: TextStyle(color: Colors.black54, fontSize: 12.0),)
                            ],
                          )
                        ],
                      ),

                      SizedBox(height: 10.0,),

                      DividerWidget(),

                      SizedBox(height: 16.0),

                      Row(
                        children: [
                          Icon(Icons.work, color: Colors.grey,),
                          SizedBox(width: 12.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Add Work"),
                              SizedBox(height: 4.0,),
                              Text("Work/Office Address", style: TextStyle(color: Colors.black54, fontSize: 12.0),)
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: AnimatedSize(
                vsync: this,
                curve: Curves.bounceIn,
                duration: new Duration(milliseconds: 160),
                child: Container(
                  height: rideDetailsContainerHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 17.0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.tealAccent[100],
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Image.asset("images/taxi.png", height: 70.0, width: 80.0,),
                                SizedBox(width: 16.0,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Car", style: TextStyle(fontSize: 18.0, fontFamily: "Brand-Bold"),
                                    ),
                                    Text(
                                      ((tripDirectionDetails != null) ? tripDirectionDetails.distanceText : ''), style: TextStyle(fontSize: 16.0, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Expanded(child: Container()),

                                Text(
                                  ((tripDirectionDetails != null) ? '\$${AssistantMethods.calculateFares(tripDirectionDetails)}' : ''), style: TextStyle(fontSize: 18.0, fontFamily: "Brand-Bold"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.moneyCheckAlt, size: 18.0, color: Colors.black54,),
                              SizedBox(width: 16.0,),
                              Text("Cash"),
                              SizedBox(width: 6.0,),
                              Icon(Icons.keyboard_arrow_down, color: Colors.black54, size: 16.0,),

                            ],
                          ),
                        ),
                        SizedBox(height: 24.0,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: ElevatedButton(
                            onPressed:()
                            {
                              displayRequestRideContainer();
                              availableServices = GeoFireAssistant.nearByAvailableServicesList;
                              searchNearestServices();

                            },
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).accentColor,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(17.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Request", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),),
                                  Icon(FontAwesomeIcons.taxi, color: Colors.white,size: 26.0,)
                                ],
                              )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),

          //special text positioned
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    spreadRadius:0.5,
                  blurRadius: 16.0,
                  color: Colors.black54,
                  offset: Offset(0.7,0.7)),
                ],
              ),
              height: requestRideContainerHeight,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    SizedBox(height: 12.0,),
                    SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.blueAccent,
                              fontFamily: 'Agne',

                            ),

                            child: AnimatedTextKit(

                              animatedTexts: [
                                TypewriterAnimatedText('Requesting a Service..'),
                                TypewriterAnimatedText('Please wait...'),
                                TypewriterAnimatedText('connecting you to the nearest ${widget.name?? 'Service Map'} in this area'),
                                TypewriterAnimatedText('Loading...'),
                              ],


                              onTap: () {
                              print("Tap Event");
                              },
                            ),
                          ),
                        ),
                    ),
                    SizedBox(height: 30.0,),
                    GestureDetector(
                      onTap: ()
                      {
                        cancelServiceRequest();
                        resetApp();
                      },
                      child: Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(26.0),
                          border: Border.all(width: 2.0, color: Colors.red)
                        ),
                        child: Icon(Icons.close, size: 26.0, color: Colors.red,),
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Container(
                      width: double.infinity,
                      child: Text("Cancel Request", textAlign: TextAlign.center, style: TextStyle(fontSize: 12.0, color: Colors.red),),
                    ),

                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async
  {
    var initialPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLng = LatLng(finalPos.latitude, finalPos.longitude);


    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
    );

    var details = await AssistantMethods.obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);
    setState(() {
      tripDirectionDetails = details;
    });

    Navigator.pop(context);

    print("this is Encoded Points::");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePintsResult = polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();
    if(decodedPolyLinePintsResult.isNotEmpty)
    {
      decodedPolyLinePintsResult.forEach((PointLatLng pointLatLng)
      {
        pLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    ploylineSet.clear();
    setState(() {
       Polyline polyline = Polyline(
         color: Colors.blue,
         polylineId: PolylineId("PolylineID"),
         jointType: JointType.round,
         points: pLineCoordinates,
         width: 5,
         startCap: Cap.roundCap,
         endCap: Cap.roundCap,
         geodesic: true,
       );

     ploylineSet.add(polyline);
   });


    LatLngBounds latLngBounds;
    if(pickUpLatLng.latitude > dropOffLatLng.latitude && pickUpLatLng.longitude > dropOffLatLng.longitude)
    {
      latLngBounds = LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    }
    else if(pickUpLatLng.longitude > dropOffLatLng.longitude)
    {
      latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude), northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    }
    else if(pickUpLatLng.latitude > dropOffLatLng.latitude)
    {
      latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude), northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    }
    else
    {
      latLngBounds = LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds,70));

    Marker pickUpLocationMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: InfoWindow(title: initialPos.placeName, snippet: "my location",),
        position: pickUpLatLng,
        markerId: MarkerId("pickUpId")
    );

    Marker dropOffLocationMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: finalPos.placeName, snippet: "Drop off Location",),
        position: dropOffLatLng,
        markerId: MarkerId("dropOffId")
    );

    setState(() {
      markersSet.add(pickUpLocationMarker);
      markersSet.add(dropOffLocationMarker);
    });

    Circle pickUpLocationCircle = Circle(
        fillColor: Colors.green,
        center: pickUpLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.green[100],
        circleId: CircleId("pickUpId")
    );

    Circle dropOffLocationCircle = Circle(
        fillColor: Colors.blue,
        center: dropOffLatLng,
        radius: 12,
        strokeWidth: 4,
        strokeColor: Colors.purpleAccent,
        circleId: CircleId("dropOffId")
    );

    setState(() {
      circlesSet.add(pickUpLocationCircle);
      circlesSet.add(dropOffLocationCircle);
    });


  }

  void initGeoFireListener()
  {
    Geofire.initialize("availableServices");
    //starting
    Geofire.queryAtLocation(currentPosition.latitude, currentPosition.longitude, 15).listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];

        //latitude will be retrieved from map['latitude']
        //longitude will be retrieved from map['longitude']

        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyAvailableServices nearbyAvailableServices = NearbyAvailableServices();
            nearbyAvailableServices.key = map['key'];
            nearbyAvailableServices.latitude = map['latitude'];
            nearbyAvailableServices.longitude = map['longitude'];
            GeoFireAssistant.nearByAvailableServicesList.add(nearbyAvailableServices);
            if(nearByAvailableServicesKeysLoaded)
            {
              updateAvailableServicesOnMap();
            }
            break;

          case Geofire.onKeyExited:
            GeoFireAssistant.removeServiceFromList(map['key']);
            updateAvailableServicesOnMap();
            break;

          case Geofire.onKeyMoved:

            NearbyAvailableServices nearbyAvailableServices = NearbyAvailableServices();
            nearbyAvailableServices.key = map['key'];
            nearbyAvailableServices.latitude = map['latitude'];
            nearbyAvailableServices.longitude = map['longitude'];
            GeoFireAssistant.updateServiceNearbyLocation(nearbyAvailableServices);
            updateAvailableServicesOnMap();
            break;

          case Geofire.onGeoQueryReady:

            updateAvailableServicesOnMap();
            break;
        }
      }

      setState(() {});
    });
    //ending
  }


  void activateListeners()
  {
    final DatabaseReference _reference = FirebaseDatabase.instance.reference().child("offered_services").child(widget.dbRef??"services");
    _subscription=
    _reference.onValue.listen((event) {
      if(event.snapshot.value != null)
      {
        initGeoFireListener();
      }
      else
      {
        noServiceFound();
        // buildShowToast("this service is not available right now, please try again later");
      }
    });
  }

  void updateAvailableServicesOnMap()
  {
    setState(() {
      markersSet.clear();
    });

    Set<Marker> tMakers = Set<Marker>();
    for(NearbyAvailableServices nearByServices in GeoFireAssistant.nearByAvailableServicesList)
    {

      LatLng serviceAvailablePosition = LatLng(nearByServices.latitude, nearByServices.longitude);




            Marker marker = Marker(
              markerId: MarkerId('services${nearByServices.key}'),
              position: serviceAvailablePosition,
              icon: nearByIcon,
              rotation: AssistantMethods.createRandomNumber(306),
            );
            tMakers.add(marker);



      // reference.once().then((DataSnapshot dataSnapshot)
      // {
      //   if(dataSnapshot.value != null)
      //   {
      //     Marker marker = Marker(
      //       markerId: MarkerId('services${nearByServices.key}'),
      //       position: serviceAvailablePosition,
      //       icon: nearByIcon,
      //       rotation: AssistantMethods.createRandomNumber(306),
      //     );
      //
      //     tMakers.add(marker);
      //   }
      //   else
      //   {
      //     noServiceFound();
      //     // buildShowToast("this service is not available right now, please try again later");
      //     markersSet.clear();
      //     // Geofire.stopListener();
      //
      //   }
      // });



    }

    setState(() {
      markersSet = tMakers;
    });
  }

  void createIconMarker()
  {
    if(nearByIcon == null)
    {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2,2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car_ios.png")
          .then((value)
      {
        nearByIcon = value;
      });
    }
  }

  void noServiceFound()
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => noServiceAvailableDialog()
    );
  }

  void searchNearestServices()
  {
    if(availableServices.length == 0)
    {
      cancelServiceRequest();
      noServiceFound();
      resetApp();
      return;
    }
    var SProvider = availableServices[0];
    availableServices.removeAt(0);
  }






  Future<bool> buildShowToast(String message) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.greenAccent,
      textColor: Colors.white,
      fontSize: 20.0,
    );
  }


  @override
  void deactivate() {
    // TODO: implement deactivate
    _subscription.cancel();
    super.deactivate();
  }



  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   markersSet.clear();
  //   Geofire.stopListener();
  //   markersSet.clear();
  // }

}


