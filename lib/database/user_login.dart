import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:seizure_deck/data/user.dart';
import 'package:seizure_deck/globals.dart' as globals;
import 'package:seizure_deck/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLogin {
  Future<Map<String, dynamic>> userLogin(String email, String password) async {
    final url = Uri.parse('${globals.dbstart_url}user_login.php?email=$email&password=$password');

    try {
      // Sending the GET request
      final response = await http.get(url);

      // Checking the response status
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['status'] == 'success') {
          globals.username = responseBody['user']['name'];
          globals.user_email = responseBody['user']['email'];
          int uid = int.parse(responseBody['user']['uid']);

          // Returning success status and the uid
          return {'success': true, 'uid': uid};
        } else {
          Fluttertoast.showToast(
            msg: responseBody['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return {'success': false, 'uid': null};
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Error: Failed to connect to the server.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return {'success': false, 'uid': null};
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Exception: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return {'success': false, 'uid': null};
    }
  }
}
