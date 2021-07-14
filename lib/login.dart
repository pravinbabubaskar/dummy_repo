import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'load_data.dart';
import 'sign_up.dart';
import 'constants.dart';
import 'OTP.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _password;

  checkAuthentification() async {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        print(firebaseUser);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Load()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //this.checkAuthentification();
  }

  login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        final user = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        checkAuthentification();
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
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  navigateToSignUp() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => otp()));//SignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
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
            child: Text("Hello",
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
                  text: 'User',
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
                            if (input.isEmpty) return 'Enter Email';
                          },
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email, color: Colors.teal),
                          ),
                          onSaved: (input) => _email = input),
                    ),
                  ),
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
                      onPressed: login,
                      child: Text(
                        'LOGIN',
                        style: buttonStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          RichText(
            text: TextSpan(
                text: 'Don\'t have an account?',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                    text: ' Create One',
                    style: TextStyle(color: Colors.blue[300]),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        navigateToSignUp();
                      },
                  ),
                ]),
          )
        ],
      ),
    ));
  }
}
