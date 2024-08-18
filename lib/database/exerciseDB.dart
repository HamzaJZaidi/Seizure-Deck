import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seizure_deck/data/exercise_data.dart';
import 'package:seizure_deck/globals.dart' as globals;


class ExerciseService {
  static String apiUrl = '${globals.dbstart_url}get_exercise.php';

  static Future<List<Exercise>> getExercisesForUser(int uid) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?uid=$uid'), // Pass uid as a query parameter
      );
      print(" RESPONSE IS ${response.body}");

      final dynamic responseData = json.decode(response.body);

      if (responseData is List) {
        print(responseData);
        return responseData.map((data) => Exercise.fromJson(data)).toList();
      } else {
        // Handle other response scenarios if needed
        print("Invalid JSON response");
        return [];
      }
    } catch (e) {
      print("Exception: $e"); // Print the exception details
      print("here3");

      // Handle exceptions
      return [];
    }
  }
}
