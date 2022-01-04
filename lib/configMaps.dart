import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:handyman/Models/allUsers.dart';

import 'Models/services.dart';

String mapKey = "AIzaSyCOoOb5IvMouujIlb2QQbhVy57VagS7gFI";

User firebaseUser;
User currentFirebaseUser;

Users userCurrentInfo;

StreamSubscription<Position> homeTabPageStreamSubscription;
StreamSubscription<Position> serviceStreamSubscription;

final assetsAudioPlayer = AssetsAudioPlayer();

Position currentPosition;

Services servicesInformation;