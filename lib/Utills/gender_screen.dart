

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickoo/Utills/password_screen.dart';

import '../Controller/signup_controller.dart';
import '../widgets/custom_widgets.dart';
import 'app_color.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen(
      {super.key});


  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  final _genderformkey = GlobalKey<FormState>();

  final SignupController signupController = Get.put(SignupController());

  String? selectedGender;

  void navigateToPasswordScreen() {
    Navigator.of(context).push(MaterialPageRoute(
          builder: (e) => const PasswordScreen(
          )));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showBackArrow: false,
      child: Padding(
        padding: EdgeInsets.only(top: 60),
        child: Center(
          child: Form(
            key: _genderformkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 28),
                  child: Text(
                    "What's your gender?",
                    style: TextStyle(
                        fontSize: 25,
                        color: AppColor.textColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                genderOption(
                    "Male", Icons.male),
                const SizedBox(
                  height: 20,
                ),
                genderOption(
                    "Female", Icons.female),
                const SizedBox(
                  height: 20,
                ),
                genderOption(
                    "Other",Icons.transgender),
                const SizedBox(
                  height: 20,
                ),
                const Spacer(),
                Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                    color: AppColor.bottomcurveColor,
                  ),
                  child:  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: const Row(
                      children: [
                        SizedBox(width: 54,),
                        Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Back",
                          style: TextStyle(
                              fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget genderOption(String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          signupController.gender = label;
        });
        navigateToPasswordScreen();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          alignment: Alignment.center,
          height: 60,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColor.textfieldColor,
            border: Border.all(
              // color: signUpController.gender == label ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColor.backGroundColor,
                  ),
                  child: Icon(icon, color: Colors.black, size: 33),
                ),
                const SizedBox(width: 20),
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
