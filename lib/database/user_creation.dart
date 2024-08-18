import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:seizure_deck/colors.dart';
import 'package:seizure_deck/globals.dart' as globals;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';


class UserCreation{

  Future<void> createUser (String name, String email, String password, DateTime dob, String location) async {
    final url = Uri.parse('${globals.dbstart_url}create_user.php');

    final Map<String, String> body = {
      'name': name,
      'email': email,
      'password': password,
      'dob': "${dob.toLocal()}".split(' ')[0],
      'location': location,
    };

    try {
    // Sending the POST request
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );

    // Checking the response status
    
      final responseBody = json.decode(response.body);
      if (responseBody == 'User created successfully') {
        Fluttertoast.showToast(
          msg: responseBody,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: primaryColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
      } else {
        Fluttertoast.showToast(
          msg: responseBody,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      }
    
  } catch (e) {
    
  }

  }

}