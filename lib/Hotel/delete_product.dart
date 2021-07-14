import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedthenead/Hotel/Hotel_dashboard/product.dart';
import 'package:flutter/cupertino.dart';
/*import 'package:flutter/material.dart';

Future del_product(
    BuildContext context, var Prod, int index, DocumentReference docref) {
  var product = Prod;
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
                  'product': FieldValue.arrayRemove([product[index]])
                }).then((value) {
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.of(context).pop();
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
}
*/
