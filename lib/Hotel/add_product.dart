import 'dart:io';
import 'package:feedthenead/Hotel/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedthenead/helpers/style.dart';
import 'package:feedthenead/widgets/custom_file_button.dart';
import 'package:feedthenead/widgets/custom_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';

class addProduct extends StatefulWidget {
  final String _id;

  addProduct(this._id);
  @override
  _addProductState createState() => _addProductState();
}

class _addProductState extends State<addProduct> {
  final _key = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int dropdownValue = 1;
  int quantity = 1;

  String _name, _des, _price, _pid;
  File _image;
  final picker = ImagePicker();
  final _firebaseStorage = FirebaseStorage.instance;
  String imageUrl;
  CollectionReference users = FirebaseFirestore.instance.collection('hotel');

  String e = "Product Addedd Successfully..";
  Future pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
  }

  Future uploadImage() async {
    setState(() async {
      if (_image != null) {
        //Upload to Firebase

        var snapshot = await _firebaseStorage
            .ref()
            .child('Product_img/${widget._id}/${_name}')
            .putFile(_image)
            .whenComplete(() {});

        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downloadUrl;
          users.doc(widget._id).update({
            "product": FieldValue.arrayUnion([
              {
                "name": _name,
                "price": _price,
                "description": _des,
                "p_id": _pid,
                "p_url": imageUrl,
                "quantity": quantity,
              },
            ]),
          }).then((value) {
            print("product Updated");

            Timestamp sec_date = Timestamp.now();

            FirebaseFirestore.instance
                .collection('quantity')
                .doc('date')
                .get()
                .then((DocumentSnapshot documentSnapshot) {
              Timestamp fir_date = documentSnapshot.data()['fir_date'];
              int data_quantity = documentSnapshot.data()['data_quantity'];

              int fir_datee = fir_date.toDate().day;
              int sec_datee = sec_date.toDate().day;
              print("firt date=${fir_date.toDate().day}");
              print("second date=${sec_date.toDate().day}");

              if (fir_datee != sec_datee) {
                data_quantity = 0 + quantity;
                FirebaseFirestore.instance
                    .collection('quantity')
                    .doc('date')
                    .update({
                  'fir_date': sec_date,
                  'data_quantity': data_quantity,
                });
                var d = sec_date.toDate().day.toString();
                if (d.length == 1) {
                  d = '0' + d;
                }
                var m = sec_date.toDate().month.toString();
                var y = sec_date.toDate().year.toString();
                String res = d + '-' + m + '-' + y;
                FirebaseFirestore.instance
                    .collection('quantity')
                    .doc('data')
                    .update({
                  '$res': data_quantity,
                });
                FirebaseFirestore.instance
                    .collection('hotel')
                    .doc(widget._id)
                    .get()
                    .then((DocumentSnapshot documentSnapshot) {
                  List nq_list = documentSnapshot.data()['net-quantity'];
                  nq_list.add(data_quantity);

                  FirebaseFirestore.instance
                      .collection('hotel')
                      .doc(widget._id)
                      .update({
                    'net-quantity': nq_list,
                  });
                });
              } else {
                data_quantity += quantity;

                FirebaseFirestore.instance
                    .collection('hotel')
                    .doc(widget._id)
                    .get()
                    .then((DocumentSnapshot documentSnapshot) {
                  List nq_list = documentSnapshot.data()['net-quantity'];
                  if (nq_list.isEmpty)
                    nq_list.add(quantity);
                  else {
                    nq_list[nq_list.length - 1] = (nq_list.last) + quantity;
                  }

                  FirebaseFirestore.instance
                      .collection('hotel')
                      .doc(widget._id)
                      .update({
                    'net-quantity': nq_list,
                  });
                });
                var d = sec_date.toDate().day.toString();
                if (d.length == 1) {
                  d = '0' + d;
                }
                var m = sec_date.toDate().month.toString();
                var y = sec_date.toDate().year.toString();
                String res = d + '-' + m + '-' + y;

                FirebaseFirestore.instance
                    .collection('quantity')
                    .doc('data')
                    .update({
                  '$res': data_quantity,
                });
                FirebaseFirestore.instance
                    .collection('quantity')
                    .doc('date')
                    .update({
                  'data_quantity': data_quantity,
                });
              }
              // var diff = sec_date.toDate().difference(fir_date.toDate());
              //print(diff.inDays);
            });
          }).catchError((error) => print("Failed to update image: $error"));
          print(imageUrl);
        });
      } else {
        print('No Image Path Received');
      }
    });
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Upload',
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
            "Add Product",
            style: TextStyle(color: black),
          )),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
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
            ),
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
            Divider(),
            /* Row(
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
                ]),*/
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    icon: Icon(
                      Icons.remove,
                      size: 36,
                    ),
                    onPressed: () {
                      if (quantity != 1) {
                        setState(() {
                          quantity -= 1;
                        });
                      }
                    }),
              ),
              GestureDetector(
                onTap: () async {},
                child: Container(
                  decoration: BoxDecoration(
                      color: primary, borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 12, 28, 12),
                    child: CustomText(
                      text: "Add $quantity quantity",
                      color: white,
                      size: 22,
                      weight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 36,
                      color: red,
                    ),
                    onPressed: () {
                      setState(() {
                        quantity += 1;
                      });
                    }),
              ),
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
                      onSaved: (input) => _name = input[0].toUpperCase() +
                          input.substring(1).toLowerCase()),
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
                        if (input.isEmpty) return 'Enter product Description';
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Product description",
                          hintStyle: TextStyle(
                              color: black,
                              fontFamily: "raleway",
                              fontSize: 18)),
                      onSaved: (input) => _des = input[0].toUpperCase() +
                          input.substring(1).toLowerCase()),
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
                        if (input.isEmpty) return 'Enter product price';
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Price",
                          hintStyle: TextStyle(
                              color: black,
                              fontFamily: "raleway",
                              fontSize: 18)),
                      onSaved: (input) => _price = input),
                ),
              ),
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
                        uploadImage();
                        openLoadingDialog(context, "Uploading...");
                        Future.delayed(const Duration(seconds: 2), () {
                          showError(e);
                        });
                      }
                    },
                    child: CustomText(
                      text: "Post",
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
