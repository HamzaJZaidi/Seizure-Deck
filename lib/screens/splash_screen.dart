import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seizure_deck/screens/loginscreen/login_screen.dart';
import 'package:seizure_deck/screens/user_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  bool alreadyVisitedUserSelection = false;
  
  @override
  void initState() {
    super.initState();
    checkFirstVisit();
    // Navigate after 3 seconds
    Timer(
      Duration(seconds: 3),
      () {
        if (!alreadyVisitedUserSelection) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UserSelection()),
          );
        } else {
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      },
    );
  }

  Future<void> checkFirstVisit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool visited = prefs.getBool('visitedUserSelection') ?? false;
    if (visited) {
      setState(() {
        alreadyVisitedUserSelection = true;
      });
    } else {
      await prefs.setBool('visitedUserSelection', true);
    }
  }
  
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      color: Colors.white,
      child: Center(
        child: Image.asset(
          "assets/images/logo.png"
        ),
      ),
    );
  }
}