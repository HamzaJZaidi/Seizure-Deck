import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seizure_deck/providers/exercise_provider.dart';
import 'package:seizure_deck/providers/user_provider.dart';
import 'package:seizure_deck/screens/home_screen/exercise_list.dart';
import 'package:seizure_deck/screens/home_screen/generate_exercise_new.dart';

class exercise extends StatefulWidget {
  const exercise({super.key});

  @override
  State<StatefulWidget> createState() => _exerciseState();
}

class _exerciseState extends State<exercise> {
  @override
  Widget build(BuildContext context) {
    ExerciseProvider exerciseProvider = Provider.of<ExerciseProvider>(context);
    UserProvider userProvider =
    Provider.of<UserProvider>(context, listen: false);

    return  Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png'),
              const SizedBox(
                height: 10,
              ),
              const Text("Exercise Plan",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF454587),
                    minimumSize: Size(MediaQuery.of(context).size.width / 1.5,
                        MediaQuery.of(context).size.width / 11)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ExerciseListScreen()));
                },
                child: const Text("Repeat Last Exercise", style: TextStyle(color: Colors.white),),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF454587),
                      minimumSize: Size(MediaQuery.of(context).size.width / 1.5,
                          MediaQuery.of(context).size.width / 11)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const generate_exercise_plan_new()));
                  },
                  child: const Text("Generate Exercise Plan",style: TextStyle(
                    color: Colors.white
                  ),))
            ],
          ),
        ));

  }
}
