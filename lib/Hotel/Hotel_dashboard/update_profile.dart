import 'dart:io';
import 'package:feedthenead/Hotel/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedthenead/helpers/style.dart';
import 'package:feedthenead/widgets/custom_file_button.dart';
import 'package:feedthenead/widgets/custom_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';

class Update_profile extends StatefulWidget {
  final String _id;

  Update_profile(this._id);
  @override
  _Update_profileState createState() => _Update_profileState();
}

class _Update_profileState extends State<Update_profile> {
  final _key = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int dropdownValue = 1;

  String _name, _des, _price, _url, _pid, _phone, _email;
  File _image;
  final picker = ImagePicker();
  final _firebaseStorage = FirebaseStorage.instance;
  String imageUrl;
  CollectionReference users = FirebaseFirestore.instance.collection('hotel');
  bool ans = false;
  String e = "Profile updated Successfully..";

  update() {
    users
        .doc(widget._id)
        .update({
          "number": _phone,
          "email": _email,
        })
        .then((value) => print("profile Updated"))
        .catchError((error) => print("Failed to update image: $error"));
  }

  /* Future pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        ans = true;
        _image = File(pickedFile.path);
      });
    }
  }

  Future uploadImage() async {
    setState(() async {
      if (_image != null) {
        //Upload to Firebase

        var snapshot = await _firebaseStorage
            .ref()
            .child('Restaurent_img/${widget._id}')
            .putFile(_image)
            .whenComplete(() {});

        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downloadUrl;
          users
              .doc(widget._id)
              .update({
                "number": _phone,
                "email": _email,
              })
              .then((value) => print("Image Updated"))
              .catchError((error) => print("Failed to update image: $error"));
          print(imageUrl);
        });
      } else {
        print('No Image Path Received');
      }
    });
  }
*/
  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Done',
              style: errorStyle,
            ),
            content: Text(
              errormessage,
              style: messageStyle,
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home(widget._id)));
                    });
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  openLoadingDialog(BuildContext context, String text) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
          iconTheme: IconThemeData(color: black),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: white,
          title: Text(
            "Update Profile",
            style: TextStyle(color: black),
          )),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            /* Container(
              height: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: CustomFileUploadButton(
                      icon: Icons.image,
                      text: "Add image",
                      onTap: () async {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext bc) {
                              return Container(
                                child: new Wrap(
                                  children: <Widget>[
                                    new ListTile(
                                        leading: new Icon(Icons.image),
                                        title: new Text('From gallery'),
                                        onTap: () async {
                                          pickImage(ImageSource.gallery);

                                          Navigator.pop(context);
                                        }),
                                    new ListTile(
                                        leading: new Icon(Icons.camera_alt),
                                        title: new Text('Take a photo'),
                                        onTap: () async {
                                          pickImage(ImageSource.camera);

                                          Navigator.pop(context);
                                        }),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              child: FlatButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext bc) {
                          return Container(
                            child: new Wrap(
                              children: <Widget>[
                                new ListTile(
                                    leading: new Icon(Icons.image),
                                    title: new Text('From gallery'),
                                    onTap: () async {
                                      pickImage(ImageSource.gallery);

                                      Navigator.pop(context);
                                    }),
                                new ListTile(
                                    leading: new Icon(Icons.camera_alt),
                                    title: new Text('Take a photo'),
                                    onTap: () async {
                                      pickImage(ImageSource.camera);

                                      Navigator.pop(context);
                                    }),
                              ],
                            ),
                          );
                        });
                  },
                  child: CustomText(
                    text: "Change Image",
                    color: grey,
                    fontfamily: "poppin",
                    size: 16.0,
                  )),
            ),*/
            /*  Divider(),
            Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CustomText(
                      text: "featured Magazine",
                      color: black,
                      fontfamily: "sans",
                      size: 16.0,
                    )
                  ],
                )),*/
            /* Divider(),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CustomText(
                    text: "Quantity:",
                    color: grey,
                    weight: FontWeight.w300,
                  ),
                  DropdownButton<int>(
                    value: dropdownValue,
                    icon: Icon(Icons.filter_list),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (int newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <int>[
                      1,
                      2,
                      3,
                      4,
                      5,
                      6,
                      7,
                      8,
                      9,
                    ].map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  )
                ]),
                
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                    color: white,
                    border: Border.all(color: black, width: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: grey.withOpacity(0.5),
                          offset: Offset(2, 7),
                          blurRadius: 7)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: TextFormField(
                      validator: (input) {
                        if (input.isEmpty) return 'Enter product id';
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Product id",
                          hintStyle: TextStyle(
                              color: black,
                              fontFamily: "raleway",
                              fontSize: 18)),
                      onSaved: (input) => _pid = input),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                    color: white,
                    border: Border.all(color: black, width: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: grey.withOpacity(0.5),
                          offset: Offset(2, 7),
                          blurRadius: 7)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: TextFormField(
                      validator: (input) {
                        if (input.isEmpty) return 'Enter product Name';
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Product name",
                          hintStyle: TextStyle(
                              color: black,
                              fontFamily: "raleway",
                              fontSize: 18)),
                      onSaved: (input) => _name = input),
                ),
              ),
            ),
            */
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                    color: white,
                    border: Border.all(color: black, width: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: grey.withOpacity(0.5),
                          offset: Offset(2, 7),
                          blurRadius: 7)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: TextFormField(
                      validator: (input) {
                        if (input.isEmpty) return 'Enter Email-id';
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email id",
                          hintStyle: TextStyle(
                              color: black,
                              fontFamily: "raleway",
                              fontSize: 18)),
                      onSaved: (input) => _email = input),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                    color: white,
                    border: Border.all(color: black, width: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: grey.withOpacity(0.5),
                          offset: Offset(2, 7),
                          blurRadius: 7)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: TextFormField(
                      validator: (input) {
                        if (input.isEmpty) return 'Enter contact number';
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Contact Number",
                          hintStyle: TextStyle(
                              color: black,
                              fontFamily: "raleway",
                              fontSize: 18)),
                      onSaved: (input) => _phone = input),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Container(
                  decoration: BoxDecoration(
                      color: primary,
                      border: Border.all(color: black, width: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: grey.withOpacity(0.3),
                            offset: Offset(2, 7),
                            blurRadius: 4)
                      ]),
                  child: FlatButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        //  uploadImage();
                        update();
                        openLoadingDialog(context, "Updating...");
                        Future.delayed(const Duration(seconds: 2), () {
                          showError(e);
                        });
                      }
                    },
                    child: CustomText(
                      text: "update",
                      color: white,
                      fontfamily: "poppin",
                      size: 20.0,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
