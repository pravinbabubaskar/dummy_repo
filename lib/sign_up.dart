import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'login.dart';
import 'load_data.dart';
import 'constants.dart';
import 'package:email_auth/email_auth.dart';

class SignUp extends StatefulWidget {
  String email;
  @override
  SignUp(this.email);
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name, _password;
  String _email;

  checkAuthentication() async {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser != null) {
        addOrders();
        addQR();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Load()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _email = widget.email;
    this.checkAuthentication();
  }

  navigateLogIn() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  signUp() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        print(_email);
        print("fdbgfbngf");
        final user = await _auth.createUserWithEmailAndPassword(
            email: _email.toString(), password: _password);

        if (user != null) {
          await FirebaseAuth.instance.currentUser
              .updateProfile(displayName: _name);

          checkAuthentication();
        }
      } catch (e) {
        showError(e.message);
        print(e);
      }
    }
  }

  showError(String errormessage) {
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
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  CollectionReference users = FirebaseFirestore.instance.collection('orders');
  CollectionReference qr = FirebaseFirestore.instance.collection('QrCode');

  Future<void> addOrders() {
    return users
        .doc(_email)
        .set({
          'Transaction': [],
          'completed': [],
        })
        .then((value) => print("Document Added"))
        .catchError((error) => print("Failed to add document: $error"));
  }

  Future<void> addQR() {
    return qr
        .doc(_email)
        .set({
          'data': [],
        })
        .then((value) => print("Document Added"))
        .catchError((error) => print("Failed to add document: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Container(
              height: 250,
              child: Image(
                image: AssetImage("images/logo.png"),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 40),
              alignment: Alignment.topLeft,
              child: Text("Journey",
                  style: TextStyle(
                      fontSize: 50,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              margin: EdgeInsets.only(left: 40),
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                    text: 'Starts',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 50,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: '  .',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 50,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold))
                    ]),
              ),
            ),
            Container(
              margin: EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.grey,
                        ),
                        child: TextFormField(
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                fontSize: 20),
                            // ignore: missing_return
                            validator: (input) {
                              if (input.isEmpty) return 'Enter Name';
                            },
                            decoration: InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.account_circle,
                                  color: Colors.teal),
                            ),
                            onSaved: (input) => _name = input),
                      ),
                    ),
                    /*Container(
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.grey,
                        ),
                        child: TextFormField(
                            style: TextStyle(fontFamily:'Raleway',fontWeight: FontWeight.bold,letterSpacing: 1,fontSize: 20),
                            // ignore: missing_return
                            validator: (input) {
                              if (input.isEmpty)
                                return 'Enter Email';
                            },
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email,color: Colors.teal),),
                            onSaved: (input) => _email = input),
                      ),
                    ),*/
                    Container(
                      child: Theme(
                        data: new ThemeData(
                          primaryColor: Colors.grey,
                        ),
                        child: TextFormField(
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                fontSize: 20),
                            // ignore: missing_return
                            validator: (input) {
                              if (input.length < 6)
                                return 'Provide Minimum 6 Character';
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock, color: Colors.teal),
                            ),
                            obscureText: true,
                            onSaved: (input) => _password = input),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 175,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            primary: Colors.teal.shade200, // background
                            onPrimary: Colors.white,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ) // foreground
                            ),
                        onPressed: signUp,
                        child: Text(
                          'Sign-up',
                          style: buttonStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    /*RichText(
                      text: TextSpan(
                          text: 'Already have an account?',
                          style: TextStyle(
                              color: Colors.black, fontSize: 18,fontFamily: 'Raleway',fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text: ' Log-In',
                              style: TextStyle(color: Colors.blue[300]),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                navigateLogIn();
                              },
                            ),
                          ]
                      ),
                    )*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
