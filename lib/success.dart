import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'home.dart';

class Success extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
            duration: 3000,
            splash: Container(
                height: double.infinity,
                width: double.infinity,
                child: FittedBox(child: Image.asset("images/ConfirmFinal.png"),
                    fit: BoxFit.cover)
            ),

            nextScreen: HomePage(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.blue
        )
    );
  }
}

