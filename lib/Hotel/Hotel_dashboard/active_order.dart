import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedthenead/Hotel/Hotel_dashboard/failure.dart';
import 'package:feedthenead/Hotel/Hotel_dashboard/order.dart';
import 'package:feedthenead/Hotel/Hotel_dashboard/order_details.dart';
import 'package:feedthenead/Hotel/home.dart';
import 'package:feedthenead/Hotel/qr_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ActiveR extends StatefulWidget {
  const ActiveR({Key key}) : super(key: key);

  @override
  _ActiveState createState() => _ActiveState();
}

class _ActiveState extends State<ActiveR> {
  String qrCodeResult;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('hotel');
    DocumentReference docref = users.doc(d_id);
    CollectionReference ord_col =
        FirebaseFirestore.instance.collection('orders');
    return StreamBuilder<DocumentSnapshot>(
        stream: users.doc(d_id).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          var order = snapshot.data['order'];

          if (snapshot.hasError)
            return Center(child: new Text('Error: ${snapshot.error}'));
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data['order'].length < 1) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/order.jpg',
                  height: 150,
                ),
                Text(
                  'No Orders Till now..',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    letterSpacing: -1,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Wait for new  one",
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
                  itemCount: order != null ? order.length : 0,
                  itemBuilder: (_, int index) {
                    return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 2000),
                        child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () async {
                                          String codeSanner =
                                              await BarcodeScanner.scan()
                                                  .then((value) {
                                            print((value));
                                            if (value ==
                                                order[index]['user id']) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ScanQR(value)));

                                              docref.update({
                                                'completed_orders':
                                                    FieldValue.arrayUnion([
                                                  {
                                                    'user name': order[index]
                                                        ['user name'],
                                                    'user id': order[index]
                                                        ['user id'],
                                                    'transaction id':
                                                        order[index]
                                                            ['transaction id'],
                                                    'result': 'Completed',
                                                    'Cost': order[index]
                                                        ['Cost'],
                                                    'items': order[index]
                                                        ['items'],
                                                    'Hotel': order[index]
                                                        ['Hotel']
                                                  }
                                                ])
                                              });

                                              docref.update({
                                                'order': FieldValue.arrayRemove(
                                                    [order[index]])
                                              });

                                              DocumentReference ord_doc =
                                                  ord_col.doc(
                                                      order[index]['user id']);
                                              ord_doc.update({
                                                'completed':
                                                    FieldValue.arrayUnion([
                                                  {
                                                    'transaction id':
                                                        order[index]
                                                            ['transaction id'],
                                                    'result': 'Completed',
                                                    'Cost': order[index]
                                                        ['Cost'],
                                                    'items': order[index]
                                                        ['items'],
                                                    'Hotel': order[index]
                                                        ['Hotel']
                                                  }
                                                ])
                                              });

                                              ord_doc.update({
                                                'Transaction':
                                                    FieldValue.arrayRemove([
                                                  {
                                                    'transaction id':
                                                        order[index]
                                                            ['transaction id'],
                                                    'result': 'Confirmed',
                                                    'Cost': order[index]
                                                        ['Cost'],
                                                    'items': order[index]
                                                        ['items'],
                                                    'Hotel': order[index]
                                                        ['Hotel'],
                                                    'status': "Active",
                                                  }
                                                ])
                                              });
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Failure()));
                                            }
                                          });
                                          setState(() {
                                            qrCodeResult = codeSanner;
                                          });
                                          /* Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ScanQR()));*/
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          child: Image.asset(
                                            'images/qrscan.jpg',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            order[index]['user name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "₹ " +
                                                    order[index]['Cost']
                                                        .toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  var temp =
                                                      order[index]['items'];
                                                  var r = order[index]['Cost'];
                                                  var n =
                                                      order[index]['user name'];
                                                  var i =
                                                      order[index]['user id'];

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Order_detail(temp,
                                                                  r, i, n)));
                                                },
                                                child: Text(
                                                  "view Details",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 20,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )));
                  }),
            );
        });
  }
}
