import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seizure_deck/components/txt_field.dart';
import 'package:seizure_deck/data/user.dart';
import 'package:seizure_deck/database/user_login.dart';
import 'package:seizure_deck/globals.dart' as globals;
import 'package:seizure_deck/providers/user_provider.dart';
import 'package:seizure_deck/screens/home_screen/main_home.dart';
import 'package:seizure_deck/screens/user_registration.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserTabLogin extends StatefulWidget {
  final Function toggleLoading;
  const UserTabLogin({required this.toggleLoading, super.key});

  @override
  State<UserTabLogin> createState() => _UserTabLoginState();
}

class _UserTabLoginState extends State<UserTabLogin> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool checkbox = false;
  UserLogin login = UserLogin();
  late SharedPreferences prefs;


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            TxtField(
              controller: usernameController,
              label: "Email",
            ),
            TxtField(
              controller: passwordController,
              label: "Password",
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Checkbox(
                  value: checkbox,
                  activeColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0),
                    side: BorderSide(width: 0.05),
                  ),
                  onChanged: (value) {
                    setState(() {
                      checkbox = !checkbox;
                    });
                  },
                ),
                Text(
                  "Remember Me",
                  style: TextStyle(
                    color: Color(0xFF000000),
                  ),
                )
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () async {
                  widget.toggleLoading();
                  final result = await login.userLogin(usernameController.text, passwordController.text);

                  if (result['success']) {
                    int uid = result['uid'];
                    prefs = await SharedPreferences.getInstance();
                    prefs.setInt("uid", uid);

                    // Create a User object with the retrieved uid
                    User user = User(uid: uid);

                    // Update the UserProvider with the new User object
                    Provider.of<UserProvider>(context, listen: false).setUser(user);

                    if (checkbox == true) {
                      prefs.setInt("remember_me_user", user.uid);
                      print("Shared Preferences Working : ${prefs.getInt("remember_me_user")}");
                    }

                    setState(() {
                      globals.isDoctorLogin = false; // Ensure this is updated correctly
                    });

                    Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
                  } else {
                    widget.toggleLoading();
                  }

                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserRegistration()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  "Signup as User",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
