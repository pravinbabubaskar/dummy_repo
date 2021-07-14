import 'dart:math';
import 'package:feedthenead/donate.dart';
import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedthenead/data.dart';
import 'home.dart';
class UpiPayment extends StatefulWidget {
  //static const routeName = '/upipayment';
  // string to store the UPI id of the NGO;
  String payid;
  String name;
  int val=0;
  // getting UPI id
  UpiPayment(this.payid,this.name,this.val);

  @override
  UpiPaymentState createState() => UpiPaymentState();
}

class UpiPaymentState extends State<UpiPayment> {
  // used for storing errors.
  String upiError;
  final _store = FirebaseFirestore.instance;
  // used to store the UPI ID and the donation amount
  TextEditingController upicontrol = TextEditingController();
  TextEditingController donationamountControl = TextEditingController();

  // used for showing list of UPI apps installed in current device
  Future<List<ApplicationMeta>> paymentapps;

  @override
  void initState() {
    super.initState();

    // PId data to donate money
    upicontrol.text = "dummy@okicici"; //.toString();

    // stores the list of payment apps installed in mobile phone
    paymentapps = UpiPay.getInstalledUpiApplications();
  }

  @override
  void dispose() {
    // dispose the donation amount and pid fields after use.
    upicontrol.dispose();
    donationamountControl.dispose();
    super.dispose();
  }


  showAlertFail(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>donate()
            ));
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Payment status"),
      content: Text("Failed!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertSuccess(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
       // _store.collection('NGO').doc(widget.name).update({'donation':(widget.val+int.parse(donationamountControl.text))/*.toString()*/});
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>HomePage(
                  location: loc1,
                )
            ));
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Payment status"),
      content: Text("Success!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertSubmitted(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>HomePage(
                  location: loc1,
                )
            ));
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Payment status"),
      content: Text("Submitted"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //  opens user selected Payment app.
  Future<void> openpaymentapp(ApplicationMeta app) async {
    final err = validatePID(upicontrol.text);
    if (err != null) {
      setState(() {
        upiError = err;
      });
      return;
    }


    setState(() {
      upiError = null;
    });

    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    print("Starting transaction with PID $transactionRef");

    // to start payment transaction.
    final paymentdata = await UpiPay.initiateTransaction(
      amount: donationamountControl.text.toString(),
      app: app.upiApplication,
      receiverName: 'NGO',
      receiverUpiAddress: upicontrol.text,
      transactionRef: transactionRef,
      merchantCode: '7372',
    );
    String s=paymentdata.status.toString();
    print(s);
    if(s=="UpiTransactionStatus.failure") {
      showAlertFail(context);
      return;
    }
    if(s=="UpiTransactionStatus.success") {
      _store.collection('NGO').doc(widget.name).update({'donation':(widget.val+int.parse(donationamountControl.text))/*.toString()*/});
      showAlertSuccess(context);
      return;
    }

      showAlertSubmitted(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.white,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Payment',
              style: TextStyle(color: Colors.black, fontFamily: 'Sans'),
            ),
            backgroundColor: Colors.teal[100],
          ),
          body: SafeArea(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 32),
                  child: Row(
                    children: <Widget>[
                  Expanded(
                  child: Theme(
                    data: new ThemeData(
                    primaryColor: Colors.black,
                    //primaryColor: Colors.grey,
                    primaryColorDark: Colors.grey,
                  ),

                        child: TextFormField(
                          controller: upicontrol,
                          enabled: true,//false,
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'OpenSans',
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter the valid PID',
                            labelText: 'UPI ID',
                            labelStyle: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Sans',
                                color: Colors.black),
                          ),
                        ),
          ),
                      ),
                    ],
                  ),
                ),
                if (upiError != null)
                  Container(
                    margin: EdgeInsets.only(top: 4, left: 12),
                    child: Text(
                      upiError,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                Container(
                  margin: EdgeInsets.only(top: 32),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Theme(
                          data: new ThemeData(
                            primaryColor: Colors.black,
                            //primaryColor: Colors.grey,
                            primaryColorDark: Colors.grey,
                          ),
                          child: TextField(
                            controller: donationamountControl,
                            enabled: true,
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Sans',
                                color: Colors.black),
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide: new BorderSide(
                                      color: Colors.black, width: 10)),
                              labelText: 'Donation Amount',
                              labelStyle: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Sans',
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 35),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("  Payment Via",
                        style: TextStyle(
                            fontSize: 25, fontFamily: 'Sans', color: Colors.black,fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 40, bottom: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: Text(
                          'Apps',
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Sans',
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ),
                      FutureBuilder<List<ApplicationMeta>>(
                        future: paymentapps,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return Container();
                          }

                          return GridView.count(
                            crossAxisCount: 1,
                            shrinkWrap: true,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 2.0,

                            physics: NeverScrollableScrollPhysics(),
                            children: snapshot.data.map((i) => Material(
                              key: ObjectKey(i.upiApplication),
                              color: Colors.teal[50],
                              child: InkWell(
                                onTap: () => openpaymentapp(i),
                                child: Column(
                                  // mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.memory(
                                      i.icon,
                                      width: 80,
                                      height: 70,
                                    ),

                                    Container(
                                      margin: EdgeInsets.only(top: 4),
                                      child: Text(
                                        i.upiApplication.getAppName(),
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                                .toList(),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
        ));
  }
}

String validatePID(String value) {
  if (value.isEmpty) {
    return 'Enter UPI Address.';
  }

  if (!UpiPay.checkIfUpiAddressIsValid(value)) {
    print('             **Invalid UPI ID.**                ');
    return 'Invalid UPI ID.';
  }

  return null;
}

