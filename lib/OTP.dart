import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
import 'constants.dart';
import 'sign_up.dart';
import 'package:flutter/gestures.dart';
import 'login.dart';
class otp extends StatefulWidget {

  @override
  otpState createState() => otpState();

}

class otpState extends State<otp> {
  final TextEditingController Usermail = TextEditingController();
  final TextEditingController otpvalue = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  showAlertOTPsent(BuildContext context) {

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("OTP Sent to"),
      content: Text(Usermail.text),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertOTPerror(BuildContext context) {

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Error On Sending OTP"),
      content: Text("try again"),

    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  showAlertverificationFailed(BuildContext context) {

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Verification Failed!!"),
      content: Text("try again"),

    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  navigateLogIn() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  void verify() {
    bool result=EmailAuth.validate(
        receiverMail: Usermail.value.text, userOTP: otpvalue.value.text);
    if(result)
    {
      print(Usermail.value.text);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignUp(Usermail.value.text),
          ));
    }
  else {
      showAlertverificationFailed(context);
    }
  }

  void sendotp() async {
    EmailAuth.sessionName = "FEED THE NEED";
    bool result = await EmailAuth.sendOtp(receiverMail: Usermail.value.text);
    if (result) {
      showAlertOTPsent(context);
      print("<<<<-----SUCCESS----->>>>");
     }
    else {
      showAlertOTPerror(context);
      print("<<<<-----FAILED----->>>>");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.teal[100],
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ListView(children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Text("Join Us", textAlign: TextAlign.center, style: headingStyle),
            Text("Let's Create A Hunger Free Surrounding",
                textAlign: TextAlign.center, style: headingStyle),
            SizedBox(
              height: 80,
            ),
            Container(
              margin: EdgeInsets.only(top: 32),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Theme(
                      data: new ThemeData(
                        primaryColor: Colors.black,
                        primaryColorDark: Colors.grey,
                      ),
                      child: TextFormField(
                        controller: Usermail,
                        enabled: true,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'OpenSans',
                            color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter the valid Email ID',
                          labelText: 'Email ID',
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
            Container(
              margin: EdgeInsets.only(top: 22),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Theme(
                      data: new ThemeData(
                        primaryColor: Colors.black,
                        primaryColorDark: Colors.grey,
                      ),
                      child: TextField(
                        controller: otpvalue,
                        enabled: true,
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Sans',
                            color: Colors.black),
                        decoration: InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(
                                  color: Colors.black, width: 10)),
                          labelText: 'OTP',
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
            SizedBox(height: 20),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.only(top: 15, bottom: 15),
                              primary: Colors.teal.shade200, // background
                              onPrimary: Colors.white,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ) // foreground
                          ),
                          onPressed: sendotp,
                          child: Text(
                            'Send OTP',
                            style: buttonStyle,
                          ),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.only(top: 15, bottom: 15),
                              primary: Colors.teal.shade200, // background
                              onPrimary: Colors.white,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ) // foreground
                          ),
                          onPressed: verify,
                          child: Text(
                            'Verify',
                            style: buttonStyle,
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
            SizedBox(height: 20),
            RichText(
              text: TextSpan(
                  text: '      Already have an account?',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold),
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
            )
          ]),
        ),
      ),
      // ),
    );
  }
}
