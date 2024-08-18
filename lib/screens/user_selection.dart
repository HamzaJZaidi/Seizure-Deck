import 'package:flutter/material.dart';
import 'package:seizure_deck/screens/doctor_regsitration/doctor_registration.dart';
import 'package:seizure_deck/screens/loginscreen/login_screen.dart';
import 'package:seizure_deck/screens/user_registration.dart';

class UserSelection extends StatelessWidget {
  const UserSelection({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Image.asset(
            "assets/images/logo.png",         
          ),
          
          Text(
            "Signup as a",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorRegistration()));
                },
                child: UserButton(txt: "Doctor")),
              SizedBox(width: 8.0),
              GestureDetector(
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => UserRegistration()));
                },
              child: UserButton(txt: "User"))
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Text(
              "Already have an account?",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                decoration: TextDecoration.underline  
              ),
            ),
          ),
          SizedBox(height: 20.0)
        ],
      ),
    );
  }
}

class UserButton extends StatelessWidget {
  final String txt;
  const UserButton({super.key, required this.txt});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width / 2.5,
      height: height / 4,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      alignment: Alignment.center,
      child: Text(
        txt,
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 15.0,
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}