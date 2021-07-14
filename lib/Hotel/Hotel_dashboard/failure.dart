import 'package:feedthenead/constants.dart';
import 'package:feedthenead/helpers/style.dart';
import 'package:flutter/material.dart';

class Failure extends StatefulWidget {
  @override
  _FailureState createState() => _FailureState();
}

class _FailureState extends State<Failure> {
  String qrCodeResult = "You are Not Verified..Try Again!!!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Message displayed over here
            Image.asset(
              'images/wrong.png',
              height: 200,
            ),
            SizedBox(
              height: 20.0,
            ),

            Text(
              qrCodeResult,
              style: headingStyle,
              textAlign: TextAlign.center,
            ),

            //Button to scan QR code
            /*   FlatButton(
              padding: EdgeInsets.all(15),
              onPressed: () async {
                //scan();
                //   String codeSanner =
                //     await BarcodeScanner.scan(); //barcode scnner
                // setState(() {
                //   qrCodeResult = codeSanner;
                // });
              },
              child: Text(
                "Open Scanner",
                style: TextStyle(color: Colors.indigo[900]),
              ),
              //Button having rounded rectangle border
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.indigo[900]),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
