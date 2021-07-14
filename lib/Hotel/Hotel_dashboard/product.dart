import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedthenead/Hotel/delete_product.dart';
import 'package:feedthenead/Hotel/home.dart';
import 'package:feedthenead/helpers/style.dart';
import 'package:feedthenead/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Product extends StatelessWidget {
  final String _id;

  Product(this._id);
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('hotel');
    DocumentReference docref = users.doc(_id);
//Stream collectionStream = FirebaseFirestore.instance.collection('users').snapshots();
    // Stream documentStream =  FirebaseFirestore.instance.collection('hotel').doc(_id).snapshots();
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: black),
          backgroundColor: white,
          elevation: 0.0,
          title: CustomText(
            text: "products",
            size: 20,
          ),
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Home(_id)));
              }),
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: users.doc(_id).snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              var product = snapshot.data['product'];
              if (snapshot.hasError)
                return Center(child: new Text('Error: ${snapshot.error}'));
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.data['product'].length < 1) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/product.png',
                      height: 150,
                    ),
                    Text(
                      'No Products Updated..',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        letterSpacing: -1,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "Add new one",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Sans",
                        letterSpacing: -1,
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ));
              } else
                return AnimationLimiter(
                  child: ListView.builder(
                      itemCount: product != null ? product.length : 0,
                      itemBuilder: (_, int index) {
                        print(product[index]['name']);

                        return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 2000),
                            child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onLongPress: () {
                                      //  print(product[index]);
                                      //  del_product(context, Product,index,docref);
                                      return showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Are you sure want to delete ${product[index]['name']} from this List?'),
                                              actions: <Widget>[
                                                new FlatButton(
                                                  child: new Text('Yes'),
                                                  onPressed: () async {
                                                    docref.update({
                                                      'product': FieldValue
                                                          .arrayRemove(
                                                              [product[index]])
                                                    }).then((value) {
                                                      Future.delayed(
                                                          const Duration(
                                                              seconds: 1), () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    });
                                                  },
                                                ),
                                                new FlatButton(
                                                  child: new Text('No'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4,
                                          right: 4,
                                          top: 4,
                                          bottom: 10),
                                      child: Container(
                                        height: 110,
                                        decoration: BoxDecoration(
                                            color: white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey[300],
                                                  offset: Offset(-2, -1),
                                                  blurRadius: 5),
                                            ]),
//          height: 160,
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 140,
                                              height: 120,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(20),
                                                  topLeft: Radius.circular(20),
                                                ),
                                                child: Image.network(
                                                  product[index]['p_url'],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: CustomText(
                                                          text: product[index]
                                                              ['name'],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 25,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4),
                                                    child: Row(
                                                      children: <Widget>[
                                                        CustomText(
                                                          text: product[index]
                                                                  ['quantity']
                                                              .toString(),
                                                          color: primary,
                                                          weight:
                                                              FontWeight.w300,
                                                          size: 14,
                                                        ),
                                                        SizedBox(
                                                          width: 2,
                                                        ),
                                                        CustomText(
                                                          text: 'quantity',
                                                          color: primary,
                                                          weight:
                                                              FontWeight.w300,
                                                          size: 14,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2),
                                                            child: Icon(
                                                              Icons.star,
                                                              color: red,
                                                              size: 20,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 2,
                                                          ),
                                                          GestureDetector(
                                                              onTap:
                                                                  () async {},
                                                              child: CustomText(
                                                                text: product[
                                                                        index][
                                                                    'description'],
                                                                color: primary,
                                                                weight:
                                                                    FontWeight
                                                                        .w300,
                                                                size: 14,
                                                              )),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 8.0),
                                                        child: CustomText(
                                                          text:
                                                              "price : ${product[index]['price']}",
                                                          weight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )));
                      }),
                );
            }));
  }
}
