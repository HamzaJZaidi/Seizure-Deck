import 'package:flutter/material.dart';
import 'package:seizure_deck/globals.dart' as globals;
import 'package:seizure_deck/screens/home_screen/community.dart';
import 'package:seizure_deck/screens/home_screen/exercise.dart';
import 'package:seizure_deck/screens/home_screen/medication.dart';
import 'package:seizure_deck/screens/home_screen/noise_checker.dart';
import 'package:seizure_deck/screens/home_screen/seizureList.dart';
import 'package:seizure_deck/screens/home_screen/video_page.dart';
import 'package:seizure_deck/screens/loginscreen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final List<String> dashboardlists = [
    "Seizure Diary",
    !globals.isDoctorLogin ?  "Doctor \nAppointment" : "Scheduled\nAppointments",
    "Medication",
    "Exercise",
    "Community",
    "First Aid \nInstructions",
    "Water Reminder",
    "Noise Checker",
    "Ambulance"
  ];



  @override
  Widget build(BuildContext context) {

    Future<bool> showExitPopup() async {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Do you want to exit an App?'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences pref =
                  await SharedPreferences.getInstance();
                  await pref.remove('remember_me_user');
                  await pref.remove('remember_me_doctor');
                  await pref.clear();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: const Text('Logout')),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      ) ??
          false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 15.0,
            color: Color(0xFFFFFFFFF)
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                showExitPopup();
              },
              child: Icon(
                Icons.power_settings_new_outlined,
                color: Colors.white,
                size: 25.0,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 200.0,
                  width: 200,
                ),
              ),
              SizedBox(height: 15.0),
              GridView.builder(
                shrinkWrap: true,  // Add this to make GridView shrink to fit the content
                physics: NeverScrollableScrollPhysics(), // Disable GridView scrolling
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 10.0, // Spacing between columns
                  mainAxisSpacing: 10.0, // Spacing between rows
                ),
                itemCount: dashboardlists.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (dashboardlists[index] == "Noise Checker") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoiseChecker(),
                          ),
                        );
                      }
                      if (dashboardlists[index] == 'Community') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiscussionScreen(),
                          ),
                        );
                      }
                      if (dashboardlists[index] == 'Medication') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => medicationHomePage(),
                          ),
                        );
                      }
                      if (dashboardlists[index] == 'Exercise') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => exercise(),
                          ),
                        );
                      }
                      if (dashboardlists[index] == 'First Aid \nInstructions') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPage(),
                          ),
                        );
                      }
                      if (dashboardlists[index] == 'Seizure Diary') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeizureList(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center,
                      child: Center(
                        child: Text(
                          dashboardlists[index],
                          style: TextStyle(
                            color: Color(0xFFFFFFFF)
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}