import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seizure_deck/components/loader.dart';
import 'package:seizure_deck/data/user.dart';
import 'package:seizure_deck/providers/user_provider.dart';
import 'package:seizure_deck/screens/home_screen/main_home.dart';
import 'package:seizure_deck/screens/loginscreen/doctor_tab_login.dart';
import 'package:seizure_deck/screens/loginscreen/user_tab_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seizure_deck/globals.dart' as globals;


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  late SharedPreferences prefs;

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    prefs = await SharedPreferences.getInstance();
    int? userUid = prefs.getInt("remember_me_user");
    int? doctorUid = prefs.getInt("remember_me_doctor");

    if (userUid != null) {
      globals.isDoctorLogin = false;
      _autoLogin(userUid);
    } else if (doctorUid != null) {
      globals.isDoctorLogin = true;
      _autoLogin(doctorUid);
    }
  }

  void _autoLogin(int uid) {
    // Create a User object with the retrieved uid
    User user = User(uid: uid);

    // Update the UserProvider with the new User object
    Provider.of<UserProvider>(context, listen: false).setUser(user);

    // Navigate to Dashboard
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Specify the number of tabs
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                ),
                SizedBox(height: 5.0),
                TabBar(
                  labelColor: Theme.of(context).primaryColor,
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerHeight: 0,
                  tabs: [
                    Tab(
                      text: "User",
                    ),
                    Tab(
                      text: "Doctor",
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      UserTabLogin(toggleLoading: toggleLoading),
                      DoctorTabLogin(toggleLoading: toggleLoading),
                    ],
                  ),
                ),
              ],
            ),
            if (isLoading)
              Center(
                child: Loader(),
              ),
          ],
        ),
      ),
    );
  }
}
