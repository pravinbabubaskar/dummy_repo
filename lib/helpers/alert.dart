import 'package:flutter/material.dart';

import '../constants.dart';

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

showError(String errormessage, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ERROR',
            style: errorStyle,
          ),
          content: Text(
            errormessage,
            style: messageStyle,
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'))
          ],
        );
      });
}
