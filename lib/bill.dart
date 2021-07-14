import 'package:feedthenead/data.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'success.dart';
import 'data.dart';

String tID;

class bill extends StatefulWidget {
  double pay;
  @override
  bill(this.pay, String id) {
    tID = id;
  }
  billState createState() => new billState();
}

class billState extends State<bill> {
  int count;
  Timer _t;
  final _store = FirebaseFirestore.instance;
  void _startTimer() {
    count = 10;
    if (_t != null) {
      _t.cancel();
    }
    _t = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (count > 0) {
          count--;
        } else {
          _t.cancel();
          cartData.clear();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Success()),
              (Route<dynamic> route) => false);
          _store
              .collection('orders')
              .doc(user1.email)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              _store.collection('orders').doc(user1.email).update({
                'Transaction': FieldValue.arrayUnion([
                  {
                    'transaction id': tID,
                    'result': 'Confirmed',
                    'status': 'Active',
                    'Cost': totalValue,
                    'items': finalCart,
                    'Hotel': hotelName
                  }
                ])
              });
              _store.collection('QrCode').doc(user1.email).update({
                'data': FieldValue.arrayUnion([
                  {
                    'result': "active",
                    'transaction id': tID,
                    'user id': user1.email,
                    'user name': user1.displayName,
                    'Cost': totalValue,
                  }
                ])
              });
            } else {
              print("doc does not exist");
            }
          });

          _store.collection('hotel').doc(hotelId).update({
            'order': FieldValue.arrayUnion([
              {
                'user name': user1.displayName,
                'user id': user1.email,
                'transaction id': tID,
                'Cost': totalValue,
                'items': finalCart,
                'Hotel': hotelName
              }
            ])
          });

          _store.collection('hotel').doc(hotelId).update({
            'qr_data': FieldValue.arrayUnion([
              {
                'result': "active",
                'transaction id': tID,
                'user id': user1.email,
                'user name': user1.displayName,
                'Cost': totalValue,
              }
            ])
          });
        }
      });
    });
  }

  cancelOrder() async{
    ShowAlertCancel(context);
    cartData.clear();

    /* _store.collection(user1.email).doc(tID).set({
      'transaction id': tID,
      'result': 'Canceled',
      'Cost': totalValue,
      'items': finalCart,
      'Hotel': hotelName
    });*/

    await _store
        .collection('orders')
        .doc(user1.email)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        _store.collection('orders').doc(user1.email).update({
          'Transaction': FieldValue.arrayUnion([
            {
              'transaction id': tID,
              'result': 'Canceled',
              'status': 'Active',
              'Cost': totalValue,
              'items': finalCart,
              'Hotel': hotelName
            }
          ])
        });
      } else {
        print("doc does not exist");
      }
    });
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        HomePage()), (Route<dynamic> route) => false);
  }

  ShowAlertCancel(BuildContext context) {
    // Create button
    Widget cancel = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog a = AlertDialog(
      title: Text("Cancel"),
      content: Text("Your Order Cancelled."),
      actions: [
        cancel,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return a;
      },
    );
  }

  @override
  void initState() {
    _startTimer();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Stack(
        children: [
          Container(
            child: Image.asset('images/confirm.png'),
            height: 300.0,
            width: double.infinity,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "CONFIRMING ORDER",
              style: TextStyle(
                fontFamily: 'Impress',
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          Text(
            "Please wait...",
            style: TextStyle(
              fontFamily: 'Sans',
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            '$count',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 48,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () => cancelOrder(), //openSuccessPage,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                color: Colors.red,
              ),
              child: Text(
                "Cancel",
                style: TextStyle(
                    fontFamily: 'Sans',
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
          )
        ],
      ),
    );

    throw UnimplementedError();
  }
//@override

}
