import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handyman/Models/serviceDetails.dart';
import 'package:handyman/Services/assistantMethods.dart';
import 'package:handyman/Services/mapKitAssistant.dart';
import 'package:handyman/configMaps.dart';
import 'package:handyman/widgets/CollectFareDialog.dart';
import 'package:handyman/widgets/progressDialog.dart';

import '../main.dart';

class NewServiceScreen extends StatefulWidget {
  final ServiceDetails serviceDetails;
   NewServiceScreen({this.serviceDetails});


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  @override
  _NewServiceScreenState createState() => _NewServiceScreenState();
}

class _NewServiceScreenState extends State<NewServiceScreen>
{
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newServiceGoogleMapController;

  Set<Marker> markersSet = Set<Marker>();
  Set<Circle> circlesSet = Set<Circle>();
  Set<Polyline> polyLinesSet = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double mapPaddingFromBottom = 0;
  var geoLocator = Geolocator();
  var locationOptions = LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
  BitmapDescriptor animatingMarkerIcon;
  Position myPosition;
  String status = "accepted";
  String durationRide = "";
  bool isRequestingDirection = false;
  String btnTitle = "Arrived";
  Color btnColor = Colors.blue;
  Timer timer;
  int durationCounter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    acceptServiceRequest();
  }

  void createIconMarker() {
    if (animatingMarkerIcon == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(
          context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car_android.png")
          .then((value) {
        animatingMarkerIcon = value;
      });
    }
  }

  void getServiceLiveLocationUpdates()
  {
    LatLng oldPos = LatLng(0, 0);

    serviceStreamSubscription = Geolocator.getPositionStream().listen((Position position)
    {
      currentPosition = position;
      myPosition = position;
      LatLng mPosition = LatLng(position.latitude, position.longitude);

      var rot = MapKitAssistant.getMarkerRotation(oldPos.latitude, oldPos.longitude, myPosition.latitude, myPosition.longitude);

      Marker animatingMarker = Marker(
        markerId: MarkerId("animating"),
        position: mPosition,
        icon: animatingMarkerIcon,
        rotation: rot,
        infoWindow: InfoWindow(title: "Current Location"),
      );

      setState(() {
        CameraPosition cameraPosition = new CameraPosition(target: mPosition, zoom: 17);
        newServiceGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        markersSet.removeWhere((marker) => marker.markerId.value == "animating");
        markersSet.add(animatingMarker);
      });

      oldPos = mPosition;
      updateServiceDetails();


      String serviceRequestId = widget.serviceDetails.service_request_id;
      String spDbRef = widget.serviceDetails.databaseRefName;

      Map locMap =
      {
        "latitude": currentPosition.latitude.toString(),
        "longitude": currentPosition.longitude.toString(),
      };
      newServiceRequestRef.child(spDbRef).child(serviceRequestId).child("sp_location").set(locMap);
    });
  }


  @override
  Widget build(BuildContext context)
  {
    createIconMarker();
    return Scaffold(
      appBar: AppBar(
        title: Text("New Service"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPaddingFromBottom),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: NewServiceScreen._kGooglePlex,
            mapToolbarEnabled: true,
            myLocationEnabled: true,
            circles: circlesSet,
            markers: markersSet,
            polylines: polyLinesSet,

            onMapCreated: (GoogleMapController controller) async
            {
              _controllerGoogleMap.complete(controller);
              newServiceGoogleMapController = controller;

              setState(() {
                mapPaddingFromBottom = 265.0;
              });

              var currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
              var pickUpLatLng = widget.serviceDetails.pickup;

              await getPlaceDirection(currentLatLng, pickUpLatLng);

              getServiceLiveLocationUpdates();

            },

          ),

          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(16.0), topEnd: Radius.circular(16.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 16.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7,0.7),
                )
              ]
            ),
              height: 270.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                child: Column(
                  children: [
                    Text(
                      durationRide,
                      style: TextStyle(fontSize: 14.0, fontFamily: "Brand Bold", color: Colors.blue),
                    ),
                    SizedBox(height: 6.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.serviceDetails.user_name, style: TextStyle(fontFamily: "Brand Bold", fontSize: 24.0),),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.phone),

                        )
                      ],
                    ),
                    SizedBox(height: 26.0,),
                    Row(
                      children: [
                        Image.asset("images/pickicon.png", height: 16.0, width: 16.0,),
                        SizedBox(width: 18.0,),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.serviceDetails.pickup_address,
                              style: TextStyle(fontSize: 18.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0,),
                    Row(
                      children: [
                        Image.asset("images/desticon.png", height: 16.0, width: 16.0,),
                        SizedBox(width: 18.0,),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.serviceDetails.dropoff_address,
                              style: TextStyle(fontSize: 18.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 26.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(btnColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              // side: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(btnTitle,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Brand Bold",
                                  color: Colors.white
                              )
                            ),
                            Icon(Icons.directions_car, color: Colors.white,size: 26.0,)
                          ],
                        ),

                        onPressed: ()
                        async {
                          if(status == "accepted")
                          {
                            status = "arrived";
                            String serviceRequestId = widget.serviceDetails.service_request_id;
                            String spDbRef = widget.serviceDetails.databaseRefName;


                            newServiceRequestRef.child(spDbRef).child(serviceRequestId).child("status").set(status);

                            setState(() {
                              btnTitle = "Start Trip";
                              btnColor = Colors.green;
                            });

                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context)=> ProgressDialog(message: "Drop-off Route Loading",));

                            await getPlaceDirection(widget.serviceDetails.pickup, widget.serviceDetails.dropoff);

                            Navigator.pop(context);
                          }
                          else if(status == "arrived")
                          {
                            status = "ontrip";
                            String serviceRequestId = widget.serviceDetails.service_request_id;
                            String spDbRef = widget.serviceDetails.databaseRefName;


                            newServiceRequestRef.child(spDbRef).child(serviceRequestId).child("status").set(status);

                            setState(() {
                              btnTitle = "End Trip";
                              btnColor = Colors.red;
                            });

                            initTimer();
                          }
                          else if(status == "ontrip")
                          {
                            endTheTrip();
                          }
                        }
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }



  Future<void> getPlaceDirection(LatLng pickUpLatLng, LatLng dropOffLatLng) async
  {

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(message: "Please wait...",)
    );

    var details = await AssistantMethods.obtainPlaceDirectionDetails(pickUpLatLng, dropOffLatLng);


    Navigator.pop(context);

    print("this is Encoded Points::");
    print(details.encodedPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePintsResult = polylinePoints.decodePolyline(details.encodedPoints);

    polylineCoordinates.clear();
    if(decodedPolyLinePintsResult.isNotEmpty)
    {
      decodedPolyLinePintsResult.forEach((PointLatLng pointLatLng)
      {
        polylineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polyLinesSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.blue,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polylineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLinesSet.add(polyline);
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

    newServiceGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds,70));

    Marker pickUpLocationMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        // infoWindow: InfoWindow(title: initialPos.placeName, snippet: "my location",),
        position: pickUpLatLng,
        markerId: MarkerId("pickUpId")
    );

    Marker dropOffLocationMarker = Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        // infoWindow: InfoWindow(title: finalPos.placeName, snippet: "Drop off Location",),
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


  void acceptServiceRequest()
  {
    String serviceRequestId = widget.serviceDetails.service_request_id;
    String spDbRef = widget.serviceDetails.databaseRefName;
    newServiceRequestRef.child(spDbRef).child(serviceRequestId).child("status").set("accepted");
    newServiceRequestRef.child(spDbRef).child(serviceRequestId).child("sp_name").set(servicesInformation.serviceUsername);
    newServiceRequestRef.child(spDbRef).child(serviceRequestId).child("sp_phone").set(servicesInformation.serviceUserPhone);
    newServiceRequestRef.child(spDbRef).child(serviceRequestId).child("sp_id").set(servicesInformation.id);
    newServiceRequestRef.child(spDbRef).child(serviceRequestId).child("sp_bizName").set(servicesInformation.bizName);
    newServiceRequestRef.child(spDbRef).child(serviceRequestId).child("sp_regNum").set(servicesInformation.regNumber);
    newServiceRequestRef.child(spDbRef).child(serviceRequestId).child("sp_details").set('${servicesInformation.serviceColour} - ${servicesInformation.serviceModel}');

    Map locMap =
    {
      "latitude": currentPosition.latitude.toString(),
      "longitude": currentPosition.longitude.toString(),
    };
    newServiceRequestRef.child(spDbRef).child(serviceRequestId).child("sp_location").set(locMap);

    usersRef.child(firebaseUser.uid).child("history").child(serviceRequestId).set(true);
  }

  void updateServiceDetails() async
  {
    if(isRequestingDirection == false)
    {
      isRequestingDirection = true;


      if(myPosition == null)
      {
        return;
      }

      var posLatLng = LatLng(myPosition.latitude, myPosition.longitude);
      LatLng destinationLatLng;

      if(status == "accepted")
      {
        destinationLatLng = widget.serviceDetails.pickup;
      }
      else
      {
        destinationLatLng = widget.serviceDetails.dropoff;
      }

      var directionDetails = await AssistantMethods.obtainPlaceDirectionDetails(posLatLng, destinationLatLng);
      if(directionDetails != null)
      {
        setState(() {
          durationRide= directionDetails.durationText;
        });

      }

      isRequestingDirection = false;
    }


  }
  void initTimer()
  {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter = durationCounter + 1;
    });
  }

  void endTheTrip() async
  {
    timer.cancel();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)=> ProgressDialog(message: "please wait",)
    );

    var currentLatLng = LatLng(myPosition.latitude, myPosition.longitude);

    var directionalDetails = await AssistantMethods.obtainPlaceDirectionDetails(widget.serviceDetails.pickup, currentLatLng);

    Navigator.pop(context);

    int fareAmount = AssistantMethods.calculateFares(directionalDetails);

    String serviceRequestId = widget.serviceDetails.service_request_id;
    String spDbRef = widget.serviceDetails.databaseRefName;

    // usersRef.child(firebaseUser.uid).child(spDbRef).child("fares").set(fareAmount.toString());
    newServiceRequestRef.child(spDbRef).child(serviceRequestId).child("earnings").set(fareAmount.toString());
    newServiceRequestRef.child(spDbRef).child(serviceRequestId).child("status").set("ended");
    // moneyEarnedRef.child(firebaseUser.uid).child(spDbRef).child("fares").set(fareAmount.toString());

    serviceStreamSubscription.cancel();


    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)=> CollectFareDialog(paymentMethod: widget.serviceDetails.serviceName,fareAmount: fareAmount,)
    );

    saveEarnings(fareAmount);


  }

  void saveEarnings(int fareAmount)
  {

    usersRef.child(firebaseUser.uid).child("earnings").child(widget.serviceDetails.databaseRefName).once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value != null)
      {
        double oldEarnings = double.parse(dataSnapshot.value.toString());
        double totalEarnings = fareAmount + oldEarnings;
        usersRef.child(firebaseUser.uid).child("earnings").child(widget.serviceDetails.databaseRefName).set(totalEarnings.toStringAsFixed(2));

      }
      else
      {
        double totalEarnings = fareAmount.toDouble();
        usersRef.child(firebaseUser.uid).child("earnings").child(widget.serviceDetails.databaseRefName).set(totalEarnings.toStringAsFixed(2));

      }
    });

  }

}


