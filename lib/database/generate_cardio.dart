import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../data/exercise_data.dart';
import '../providers/exercise_provider.dart';
import '../providers/user_provider.dart';
import 'package:seizure_deck/globals.dart' as globals;


Future<void> generateCardioExercise(
    BuildContext context,
    bool shoulder,
    bool chest,
    bool back,
    bool arms,
    bool abs,
    bool legs,
    int numOfExercises,
    String difficulty,
    // int duration,
    // int numOfExercises
    ) async {

  ExerciseProvider exerciseProvider =
  Provider.of<ExerciseProvider>(context, listen: false);

  UserProvider userProvider = Provider.of(context,listen: false);
  int? uid = userProvider.uid;

  String url = '${globals.dbstart_url}cardio.php';


  // 'numExercises' : numOfExercises.toString()
  final response = await http.post(
    Uri.parse(url),
    body: {
      'uid': uid.toString(),
      // 'type': type,
      'shoulder': boolToInt(shoulder).toString(),
      'chest' : boolToInt(chest).toString(),
      'back' : boolToInt(back).toString(),
      'arms' : boolToInt(arms).toString(),
      'abs' : boolToInt(abs).toString(),
      'legs' : boolToInt(legs).toString(),
      'numExercises' : numOfExercises.toString(),
      'difficulty' : difficulty
      // 'timeAvailable': duration.toString(),
      // 'numExercises' : numOfExercises.toString()
    },
  );
  print(response.body);

  if (response.statusCode == 200) {
    final dynamic responseData = json.decode(response.body);

    if (responseData is List) {
      // Convert the dynamic list to a list of Exercise
      List<Exercise> exercises =
      responseData.map((data) => Exercise.fromJson(data)).toList();

      exerciseProvider.setExercises(exercises);
    } else if (responseData is Map && responseData.containsKey('message')) {
      // Handle the case when no exercises are found
      print(responseData['message']);
      // You can display the message as needed, for example, show a SnackBar
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(responseData['message']),
      //   ),
      // );
    }
  } else {
    print(
        "Failed to connect to the server. Status Code: ${response.statusCode}");
  }
}

int boolToInt(bool abc){
  if(abc = true){
    return 1;
  }
  else {
    return 0;
  }
}
