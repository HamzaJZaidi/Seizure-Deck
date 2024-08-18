import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:seizure_deck/globals.dart' as globals;

class DoctorLogin {

  Future<Map<String, dynamic>> doctorLogin(String email, String password) async {
    final url = Uri.parse('${globals.dbstart_url}doctor_login.php?email=$email&password=$password');

    try {
      // Sending the GET request
      final response = await http.get(url);

      // Checking the response status
      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['status'] == 'success') {
          globals.doctor_name = responseBody['user']['name'];
          globals.doctor_email = responseBody['user']['email'];
          int uid = responseBody['user']['id'];
          return {
            'success': true,
            'uid': uid,
          };
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
          return {'success': false};
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
        return {'success': false};
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
      return {'success': false};
    }
  }
}
