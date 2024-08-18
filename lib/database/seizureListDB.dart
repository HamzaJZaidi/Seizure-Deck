
import 'package:seizure_deck/data/seizure_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seizure_deck/globals.dart' as globals;

Future<List<SeizureDetection>> fetchSeizureData(int userId) async {
  // Assuming you're using http package for API calls
  // Make sure to replace this with your actual API endpoint
  final response = await http.post(
    Uri.parse('${globals.dbstart_url}seizureList.php'),
    body: {'userid': userId.toString()},
  );

  if (response.statusCode == 200) {
    // Parse the JSON response and return a list of SeizureDetection objects
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => SeizureDetection.fromJson(json)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // throw an exception.
    throw Exception('Failed to load seizure data');
  }
}
