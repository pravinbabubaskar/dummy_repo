import 'package:barcode_scan_fix/barcode_scan.dart';
import 'package:feedthenead/constants.dart';
import 'package:feedthenead/helpers/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScanQR extends StatefulWidget {
  final String val;

  ScanQR(this.val);
  @override
  _ScanQRState createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  String qrCodeResult =
      "You are Successfully Verified..Thank you for Purchasing";

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
              'images/successful.gif',
              height: 200,
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "User",
              style: messageStyle,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              widget.val,
              style: supportStyle,
              textAlign: TextAlign.center,
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

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => qrCodeResult = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          qrCodeResult = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => qrCodeResult = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => qrCodeResult =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => qrCodeResult = 'Unknown error: $e');
    }
  }
}
