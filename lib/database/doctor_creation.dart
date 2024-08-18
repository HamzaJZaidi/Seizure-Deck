import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seizure_deck/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:seizure_deck/colors.dart';

class DoctorCreation {

  Future<void> createDoctor(
    String name, 
    String cnic, // Change to String for initial validation
    String pmdc_no, 
    String contact_no, 
    String email, 
    String password, 
    String availability_days, 
    String availability_time, 
    String working_address, 
    String optional_working_address,
    String specialization
  ) async {
    // Validate CNIC
    if (!RegExp(r'^\d{11}$').hasMatch(cnic)) {
      Fluttertoast.showToast(
        msg: 'CNIC must be a numeric value with exactly 11 digits.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
      return;
    }

    final url = Uri.parse('${globals.dbstart_url}create_doctor.php');

    final Map<String, String> body = {
      'name': name,
      'cnic': cnic, // Send as String
      'pmdc_no': pmdc_no,
      'contact_no': contact_no,
      'email': email,
      'password': password,
      'availability_days': availability_days,
      'availability_time': availability_time,
      'working_address': working_address,
      'optional_working_address': optional_working_address,
      'specialization': specialization
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
      if (responseBody['status'] == 'success') {
        Fluttertoast.showToast(
          msg: responseBody['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: primaryColor,
          textColor: Colors.white,
          fontSize: 16.0
        );
      } else {
        Fluttertoast.showToast(
          msg: responseBody['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
      }

    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An error occurred: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  }
}
