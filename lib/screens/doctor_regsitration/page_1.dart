import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:seizure_deck/components/txt_field.dart';
import 'package:seizure_deck/screens/doctor_regsitration/contrller.dart';

class Page1 extends StatelessWidget {
  final PageController controller;
  final DoctorRegistrationController registrationController = Get.find();
  Page1({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TxtField(controller: registrationController.doctorNameController, label: "Doctor's Name"),
              TxtField(controller: registrationController.doctorCnicController, label: "Doctor's CNIC"),
              TxtField(controller: registrationController.doctorPmdcController, label: "Doctor's PMDC No#"),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.nextPage(duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle
                      ),
                      child: Transform.rotate(
                        angle: 180 * (22 / 7) / 180,
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Color(0xFFFFFFFFF),
                          size: 25.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0,)
            ],
          ),
        ),
      ),
    );
  }
}
