import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

String loc1 = 'Null';
User user1;
List<dynamic> address;
bool isNGOVerified = false;
List<dynamic> hotelData;

Position latlong;
List<dynamic> cartData = new List();
List<dynamic> finalCart = new List();
int totalValue = 0;
String hotelName;
String hotelId;
var barName;
int toto = 0;
int cost = 0;
