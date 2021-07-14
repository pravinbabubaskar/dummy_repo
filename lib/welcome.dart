import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'constants.dart';
import 'load_data.dart';
import 'login.dart';
import 'sign_up.dart';
import'OTP.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  checkAuthentication()  {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser)  {
      print(firebaseUser);
      if (firebaseUser != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Load()));
      }
    });
  }


  static MediaQueryData _mediaQueryData;
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Let's make our surroundings hunger free ",
      "image": "images/welcome1.png"
    },
    {
      "text": "We're not getting younger. Today let's fight hunger!",
      "image": "images/welcome2.png"
    },
    {
      "text": " Today's wastage is tomorrow's shortage",
      "image": "images/welcome3.png"
    },
  ];

  navigateToLogin() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  navigateToRegister() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => otp()));//SignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(height: 50),
          Container(
            height: 450,
            child: PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              itemCount: splashData.length,
              itemBuilder: (context, index) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(splashData[index]['image']),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    splashData[index]['text'],
                    style: supportStyle,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              splashData.length,
              (index) => buildDot(index: index),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            'Welcome to ',textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway',
                color: Colors.black),
          ),
          Text(
            'Feed The Need',textAlign: TextAlign.center,
            style: headingStyle,
          ),
          SizedBox(height: 30.0),
          Container(
            margin: EdgeInsets.only(left: 30,right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        primary: Colors.teal.shade200, // background
                        onPrimary: Colors.white,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ) // foreground
                        ),
                    onPressed: navigateToLogin,
                    child: Text(
                      'LOGIN',
                      style: buttonStyle,
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        primary: Colors.teal.shade200, // background
                        onPrimary: Colors.white,

                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ) // foreground
                        ),
                    onPressed: navigateToRegister,
                    child: Text(
                      'REGISTER',
                      style: buttonStyle
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),

        ],
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.teal : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
