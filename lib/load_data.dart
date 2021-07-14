import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data.dart';
import 'home.dart';


class Load extends StatefulWidget {
  @override
  _LoadState createState() => _LoadState();
}

class _LoadState extends State<Load> {
  Position loc;
  String Userdistrict;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  User user;
  String _key = "AIzaSyChMRxmcfqCAvdTQMPUzi1Lu4hnIrJpAFk";
  List<dynamic> data = List<dynamic>();

  double lat, long;
  bool isloggedin = false;
  void initState() {
    super.initState();
    getLocation();
    hideScreen();
    getUser();
    getData();
  }

  getData() async {
    final snapshots = await _store.collection("hotel").get();

    for (var m in snapshots.docs) {
      var t = m.data();
      data.add(t);
    }
    setState(() {
      hotelData = data;
    });
  }

  Future getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    loc = position;
    lat = loc.latitude;
    long = loc.longitude;
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      Userdistrict = first.subAdminArea;
      loc1 = Userdistrict;
      latlong = position;
    });
  }

  getUser() async {
    User firebaseUser = await _auth.currentUser;
    firebaseUser = await _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
        user1 = user;
        isNGOVerified = user1.photoURL == null ? false : true;
      });
    }
  }

  ///hide your splash screen
  Future<void> hideScreen() async {
    Future.delayed(Duration(milliseconds: 5600), () {
      FlutterSplashScreen.hide();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(location: Userdistrict)),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Feed \n The \n Need',
                textStyle:TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 50,
                  color: Colors.teal
                ),
              ),
            ],
            onTap: () {
              print("Tap Event");
            },
          ),
        ),
      ),
    );
  }
}
