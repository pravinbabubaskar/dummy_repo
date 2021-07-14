import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedthenead/widgets/custom_text.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Restaurent extends StatefulWidget {
  final String _id;

  Restaurent(this._id);
  @override
  _RestaurentState createState() => _RestaurentState();
}

class _RestaurentState extends State<Restaurent> {
  String _type = "type";

  String _name = "name";
  String _imgurl;
  String _address = "address";
  String _count = "0";
  String _len = "0", _number = "0", _email = "@";
  //List<dynamic> pr;
  @override
  void initState() {
    super.initState();
    this.getData();
  }

  getData() {
    FirebaseFirestore.instance
        .collection('hotel')
        .doc(widget._id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        _name = documentSnapshot.data()['name'];
        _imgurl = documentSnapshot.data()['imageUrl'];
        _type = documentSnapshot.data()['type'];
        _address = documentSnapshot.data()['address'];
        _number = documentSnapshot.data()['number'];
        _email = documentSnapshot.data()['email'];

        print(_number);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(2),
              bottomRight: Radius.circular(2),
            ),
            child: _imgurl == null
                ? Image.asset(
                    "images/food.png",
                    height: 200.0,
                    width: 400.0,
                  )
                : Image.network(_imgurl, fit: BoxFit.fill),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Card(
                child: Container(
                  child: ListTile(
                      /*   leading: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset("images/delivery.png"),
                      ),*/
                      title: CustomText(
                        text: _name,
                        size: 24,
                      ),
                      subtitle: CustomText(
                        text: _type,
                        size: 18,
                      ),
                      trailing: Icon(
                        Icons.restaurant,
                        size: 50,
                      )),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Card(
                child: Container(
                  child: ListTile(
                      onTap: () {},
                      /*   leading: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset("images/delivery.png"),
                      ),*/
                      title: CustomText(
                        text: "Address",
                        size: 24,
                      ),
                      subtitle: CustomText(
                        text: _address,
                        size: 18,
                      ),
                      trailing: Icon(
                        Icons.location_on,
                        size: 50,
                      )),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Card(
                child: Container(
                  child: ListTile(
                      onTap: () {},
                      /*   leading: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset("images/delivery.png"),
                      ),*/
                      title: CustomText(
                        text: "Contact Number",
                        size: 24,
                      ),
                      subtitle: CustomText(
                        text: _number,
                        size: 18,
                      ),
                      trailing: Icon(
                        Icons.call,
                        size: 50,
                      )),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Card(
                child: Container(
                  child: ListTile(
                      onTap: () {},
                      /*   leading: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset("images/delivery.png"),
                      ),*/
                      title: CustomText(
                        text: "Gmail",
                        size: 24,
                      ),
                      subtitle: CustomText(
                        text: _email,
                        size: 18,
                      ),
                      trailing: Icon(
                        Icons.mail,
                        size: 50,
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
