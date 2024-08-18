import 'package:get/get.dart';
import 'package:flutter/material.dart';

class DoctorRegistrationController extends GetxController {
  // TextEditingController instances
  final doctorNameController = TextEditingController();
  final doctorCnicController = TextEditingController();
  final doctorPmdcController = TextEditingController();
  final contactNoController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final specialization = TextEditingController();
  final availabilityDayController = TextEditingController();
  final availabilityTimeController = TextEditingController();
  final workingAddressController = TextEditingController();
  final optionalWorkingAddressController = TextEditingController();

  // Dispose controllers when not needed
  @override
  void onClose() {
    doctorNameController.dispose();
    doctorCnicController.dispose();
    doctorPmdcController.dispose();
    contactNoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    specialization.dispose();
    availabilityDayController.dispose();
    availabilityTimeController.dispose();
    workingAddressController.dispose();
    optionalWorkingAddressController.dispose();
    super.onClose();
  }
}
