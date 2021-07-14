import 'package:feedthenead/Hotel/home.dart';
import 'package:feedthenead/Hotel/loc_autosearch.dart';
import 'package:feedthenead/Hotel/login.dart';
import 'package:feedthenead/helpers/alert.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedthenead/Hotel/address_search.dart';
import 'package:feedthenead/Hotel/place_service.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';
import 'dart:core';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_webservice/places.dart';
import '../constants.dart';

const kGoogleApiKey = "AIzaSyChMRxmcfqCAvdTQMPUzi1Lu4hnIrJpAFk";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class Sign_up extends StatefulWidget {
  @override
  _Sign_upState createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> {
  String _name, _id, _password, _address = "Address", _type, _district;
  double lat, lon;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  navigateLogIn() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p == null) {
      print("please select any place...");
    }
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;

      setState(() {
        _controller.text = p.description;
        lat = detail.result.geometry.location.lat;
        _address = detail.result.formattedAddress;
        lon = detail.result.geometry.location.lng;
      });
      print(detail.result.formattedAddress);
      print(p.description);
      var address = await Geocoder.local.findAddressesFromQuery(p.description);
      final coordinates = new Coordinates(lat, lon);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;

      print(
          ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea}');
      _district = first.subAdminArea;
      print(_district);
      print(lat);
      print(lon);
    }
  }

  /*openLoadingDialog(BuildContext context, String text) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              content: Row(children: <Widget>[
                SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                        strokeWidth: 1,
                        valueColor: AlwaysStoppedAnimation(Colors.black))),
                SizedBox(width: 10),
                Text(text)
              ]),
            ));
  }*/

  void initState() {
    super.initState();
  }

  final _controller = TextEditingController();
  //String _streetNumber = '';
  //String _street = '';
  //String _city = '';
  //String _zipCode = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('hotel');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .doc(_id)
          .set({
            'name': _name,
            'id': _id,
            'password': _password,
            'type': _type,
            'latitue': lat,
            'revenue': 0,
            'longitude': lon,
            'address': _address,
            'district': _district,
            'email': "none",
            'number': "none",
            'r': "3",
            'completed_orders': [],
            'order': [],
            'qr_data': [],
            'product': [],
            'net-quantity': [],
            'imageUrl':
                'https://firebasestorage.googleapis.com/v0/b/feedtheneed-ad7d0.appspot.com/o/food.png?alt=media&token=b594a56c-fadc-4399-9900-a233bd61d802',
          })
          .then((value) => print("Document Added"))
          .catchError((error) => print("Failed to add document: $error"));
    }

    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Container(
              margin: EdgeInsets.only(left: 40),
              alignment: Alignment.topLeft,
              child: Text("create",
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                    //fontWeight: FontWeight.bold
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 40),
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                  text: 'New ID',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 40,
                    color: Colors.black,
                    //    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.grey,
                        ),
                        child: TextFormField(
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                fontSize: 20),
                            // ignore: missing_return
                            validator: (input) {
                              if (input.isEmpty) return 'Enter Name';
                            },
                            decoration: InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.email, color: Colors.teal),
                            ),
                            onSaved: (input) => _name = input[0].toUpperCase() +
                                input.substring(1).toLowerCase()),
                      ),
                    ),
                    Container(
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.grey,
                        ),
                        child: TextFormField(
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                fontSize: 20),
                            // ignore: missing_return
                            validator: (input) {
                              if (input.isEmpty) return 'Enter new_id';
                            },
                            decoration: InputDecoration(
                              labelText: 'New_id',
                              prefixIcon: Icon(Icons.account_circle,
                                  color: Colors.teal),
                            ),
                            onSaved: (input) => _id = input),
                      ),
                    ),
                    Container(
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.grey,
                        ),
                        child: TextFormField(
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                fontSize: 20),
                            // ignore: missing_return
                            validator: (input) {
                              if (input.length < 6)
                                return 'Provide Minimum 6 Character';
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock, color: Colors.teal),
                            ),
                            obscureText: true,
                            onSaved: (input) => _password = input),
                      ),
                    ),
                    Container(
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.grey,
                        ),
                        child: TextFormField(
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                fontSize: 20),
                            // ignore: missing_return
                            validator: (input) {
                              if (input.length < 3)
                                return 'Provide type of restaurent';
                            },
                            decoration: InputDecoration(
                              labelText: 'Type',
                              prefixIcon:
                                  Icon(Icons.no_drinks, color: Colors.teal),
                            ),
                            onSaved: (input) => _type = input[0].toUpperCase() +
                                input.substring(1).toLowerCase()),
                      ),
                    ),
                    Container(
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.grey,
                        ),
                        child: TextFormField(
                          controller: _controller,
                          style: TextStyle(
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              fontSize: 20),
                          // ignore: missing_return
                          validator: (input) {
                            if (input.length < 1) return 'Pick any location';
                          },
                          onTap: () async {
                            // show input autocomplete with selected mode
                            // then get the Prediction selected
                            Prediction p = await PlacesAutocomplete.show(
                                context: context, apiKey: kGoogleApiKey);
                            displayPrediction(p);
                          },
                          decoration: InputDecoration(
                            labelText: 'Address',
                            prefixIcon: Icon(Icons.home, color: Colors.teal),
                          ),
                        ),
                      ),
                    ),
                    /*  Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                fontSize: 20),
                                  validator: (input){
                              if (input.length < 1)
                                return 'Please select loation';
                                  },
                            controller: _controller,
                            readOnly: true,
                            onTap: () async {
                              // show input autocomplete with selected mode
                              // then get the Prediction selected
                              Prediction p = await PlacesAutocomplete.show(
                                  context: context, apiKey: kGoogleApiKey);
                              displayPrediction(p);
                              /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AutoSearch()));
                              // generate a new token here
                              final sessionToken = Uuid().v4();
                              final Suggestion result = await showSearch(
                                context: context,
                                delegate: AddressSearch(sessionToken),
                              );
                              // This will change the text displayed in the TextField
                              if (result != null) {
                                final placeDetails =
                                    await PlaceApiProvider(sessionToken)
                                        .getPlaceDetailFromId(result.placeId);
                                setState(() {
                                  _controller.text = result.description;
                                  _streetNumber = placeDetails.streetNumber;
                                  _street = placeDetails.street;
                                  _city = placeDetails.city;
                                  _zipCode = placeDetails.zipCode;
                                });
                              }*/
                            },
                            decoration: InputDecoration(
                              labelText: 'Address',
                              prefixIcon: Icon(Icons.home, color: Colors.teal),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          //Text('Street Number: $_streetNumber'),
                          //Text('Street: $_street'),
                          //Text('City: $_city'),
                          //Text('ZIP Code: $_zipCode'),
                        ],
                      ),
                    ), */
                    SizedBox(height: 30),
                    Container(
                      width: 175,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            primary: Colors.teal.shade200, // background
                            onPrimary: Colors.white,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ) // foreground
                            ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            addUser();
                            openLoadingDialog(context, "signing in...");
                            Future.delayed(const Duration(seconds: 2), () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home(_id)));
                            });
                          }
                        },
                        child: Text(
                          'Create',
                          style: buttonStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Already have an account?',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Log-in',
                              style: TextStyle(color: Colors.teal[300]),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  navigateLogIn();
                                },
                            ),
                          ]),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
