import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seller/auth/auth_screen.dart';
import 'package:seller/global/global.dart';
import 'package:seller/mainSceens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 1), () async {
      if (firebaseAuth.currentUser !=null) {
         Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      }
      else{
         Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => const AuthScreen()));
      }
     
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/splash.jpg"),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                "sell food",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 40,
                  fontFamily: "signatra",
                  letterSpacing: 3,
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
