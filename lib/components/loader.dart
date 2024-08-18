import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
          SpinKitRing(
            lineWidth: 3.0,
            color: Theme.of(context).primaryColor,
            size: 35.0,),
          Image.asset(
            "assets/images/logo.png",
            width: 25.0,
            height: 25.0,
          )
        ],),
      ),
    );
  }
}