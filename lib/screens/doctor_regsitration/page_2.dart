import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seizure_deck/components/txt_field.dart';
import 'package:seizure_deck/screens/doctor_regsitration/contrller.dart';


class Page2 extends StatelessWidget {
  final PageController controller;
  final DoctorRegistrationController registrationController = Get.find();
  Page2({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Container(
          height:  300.0, // Adjust height accordingly
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TxtField(controller: registrationController.contactNoController, label: "Contact No"),
              TxtField(controller: registrationController.emailController, label: "Email"),
              TxtField(controller: registrationController.passwordController, label: "Password"),
              TxtField(controller: registrationController.specialization, label: "Specialization"),
              Spacer(),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                        onTap: () {
                          controller.previousPage(duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xFFFFFFFFF),
                            size: 25.0,
                          ),
                        ),
                      ),
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
                  
              
              SizedBox(height: 15,)
            ],
          ),
        ),
      ),
    );
  }
}
