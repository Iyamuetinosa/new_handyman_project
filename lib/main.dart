import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:handyman/AllScreens/loginScreen.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:handyman/AllScreens/mainscreen.dart';
import 'package:handyman/AllScreens/ServiceProviderMapScreen.dart';
import 'package:handyman/AllScreens/selectActivityScreen.dart';
import 'package:handyman/AllScreens/serviceSelectionScreen.dart';
import 'package:handyman/AllScreens/sign_up_view.dart';
import 'package:handyman/AllScreens/subLoginScreen.dart';
import 'package:handyman/Datahandler/appData.dart';
import 'package:handyman/Services/auth_service.dart';
import 'package:handyman/configMaps.dart';
import 'package:provider/provider.dart';
import 'Models/serviceDetails.dart';
import 'Notifications/local_notification_service.dart';
import 'Notifications/notificationDialog.dart';

//on works when app is in background
Future<void>backgroundHandler(RemoteMessage message) async{
  print (message.data.toString());
  print (message.notification.title);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  firebaseUser = FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");
DatabaseReference amountEarnedRef = FirebaseDatabase.instance.reference().child("earnings");
DatabaseReference userChkRef = FirebaseDatabase.instance.reference().child("availableServices");
DatabaseReference offerServiceRef = FirebaseDatabase.instance.reference().child("offered_services");
DatabaseReference moneyEarnedRef = FirebaseDatabase.instance.reference().child("earning");
DatabaseReference newServiceRequestRef = FirebaseDatabase.instance.reference().child("Service Requests");
DatabaseReference serviceRequestRef = FirebaseDatabase.instance.reference().child("offered_services").child(firebaseUser.uid).child("new_request");

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override


  

  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: ChangeNotifierProvider(
        create: (context)=> AppData(),
        child: MaterialApp(
          title: 'Handyman App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home:HomeController(),
          // initialRoute:  ServiceProviderMapScreen.idScreen,
          routes:<String, WidgetBuilder>
          {
            '/ServiceSelectionScreen':(BuildContext context)=>ServiceSelectionScreen(),
            LoginScreen.idScreen:(context)=>LoginScreen(),
            SubLoginScreen.idScreen:(context)=>SubLoginScreen(),
            SelectActivityScreen.idScreen:(context)=>SelectActivityScreen(),
            ServiceProviderMapScreen.idScreen:(context)=>ServiceProviderMapScreen(),
            '/SelectActivityScreen':(BuildContext context) =>SelectActivityScreen(),
            // MainScreen.idScreen:(context)=>MainScreen(),
            '/signUp': (BuildContext context) => SignUpView(authFormType: AuthFormType.signUp),
            '/signIn': (BuildContext context) => SignUpView(authFormType: AuthFormType.signIn),
            '/back': (BuildContext context) => HomeController(),
            'services':(BuildContext context) => ServiceProviderMapScreen(),
            'request':(BuildContext context)=> MainScreen(),
            // OtpScreen.idScreen:(context)=>OtpScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class HomeController extends StatefulWidget {
  const HomeController({Key key}) : super(key: key);

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {

  void initState() {
    // TODO: implement initState
    super.initState();
    LocalNotificationService.initialize(context);
    LocalNotificationService localNotificationService = LocalNotificationService();
    localNotificationService.getSPToken();

    // this gets notification from app terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message)
    {
      if(message !=null)
      {
        onNotificationResult(message);
        print("From Terminated state...");
      }
    });

    //notification for app in foreground only
    FirebaseMessaging.onMessage.listen((message)
    {
      if(message.notification !=null)
      {
        print(message.notification.body);
        print(message.notification.title);

        assetsAudioPlayer.open(Audio("sounds/alert.mp3"));
        assetsAudioPlayer.play();
        onNotificationResult(message);

      }
      LocalNotificationService.display(message);

    });
    //notification for only app opened but in the background and user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message)
    {
      onNotificationResult(message);

    });

  }

  void onNotificationResult(RemoteMessage message) {
    final routeFromMessage = message.data["route"];
    final serviceName = message.data["service_name"];
    final serviceDbRef = message.data["db_ref"];
    final serviceRequestId = message.data["service_request_id"];
    assetsAudioPlayer.open(Audio("sounds/alert.mp3"));
    assetsAudioPlayer.play();

    // if(routeFromMessage=="services")
    // {
    //   newServiceRequestRef.child(serviceDbRef).child(serviceRequestId).once()
    //       .then((DataSnapshot dataSnapshot)
    //   {
    //     if(dataSnapshot.value !=null)
    //     {
    //       double pickUpLocationLat = double.parse(dataSnapshot.value['pickup']['latitude'].toString());
    //       double pickUpLocationLng = double.parse(dataSnapshot.value['pickup']['longitude'].toString());
    //       String pickUpAddress =dataSnapshot.value['pickup_address'].toString();
    //
    //       double dropOffLocationLat = double.parse(dataSnapshot.value['dropoff']['latitude'].toString());
    //       double dropOffLocationLng = double.parse(dataSnapshot.value['dropoff']['longitude'].toString());
    //       String dropOffAddress =dataSnapshot.value['dropoff_address'].toString();
    //
    //       ServiceDetails serviceDetails = ServiceDetails();
    //       serviceDetails.service_request_id = serviceRequestId;
    //       serviceDetails.pickup_address = pickUpAddress;
    //       serviceDetails.dropoff_address = dropOffAddress;
    //       serviceDetails.pickup = LatLng(pickUpLocationLat, pickUpLocationLng);
    //       serviceDetails.dropoff = LatLng(dropOffLocationLat, dropOffLocationLng);
    //       // serviceDetails.user_phone = widget.serviceRequestId;
    //       // serviceDetails.user_name = widget.serviceRequestId;
    //
    //       print("this is your information::");
    //       print("this is your pick up address:: " +serviceDetails.pickup_address);
    //       print("this is your drop off address:: "+ serviceDetails.dropoff_address);
    //       print(serviceDetails.service_request_id);
    //
    //       showDialog(
    //         context: context,
    //         barrierDismissible: false,
    //         builder: (BuildContext context) => NotificationDialog(serviceDetails: serviceDetails,),
    //       );
    //
    //     }
    //   });
    // }



    // Navigator.of(context).pushNamed(routeFromMessage);

    Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceProviderMapScreen(serviceName: serviceName, serviceDbRef:serviceDbRef,serviceRequestId:serviceRequestId)));

  }






  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot)
      {
        if(snapshot.connectionState == ConnectionState.active)
        {
          final bool signedIn = snapshot.hasData;
          return signedIn ? SelectActivityScreen() : SubLoginScreen();
        }
        return CircularProgressIndicator();
      },
    );
  }
}




class Provider extends InheritedWidget {
  final AuthService auth;
  Provider({Key key, Widget child, this.auth}) : super(key: key, child: child );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget)
  {
    return true;
  }

  static Provider of(BuildContext context) =>context.dependOnInheritedWidgetOfExactType<Provider>();
}