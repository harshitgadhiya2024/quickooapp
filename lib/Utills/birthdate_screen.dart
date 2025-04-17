import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quickoo/Utills/app_color.dart';

import '../Controller/signup_controller.dart';
import '../widgets/custom_widgets.dart';
import 'gender_screen.dart';

class BirthDateScreen extends StatefulWidget {
  const BirthDateScreen({super.key});


  @override
  State<BirthDateScreen> createState() => _BirthDateScreenState();
}

class _BirthDateScreenState extends State<BirthDateScreen> {
  final TextEditingController birthDateController = TextEditingController();

  final _birthformkey = GlobalKey<FormState>();
  final SignupController signupController = Get.put(SignupController());

  Future<void> selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: today,
        firstDate: DateTime(1900),
        lastDate: today
    );
    if(picked != null){
      setState(() {
        birthDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showBackArrow: false,
      child: Padding(
        padding:  EdgeInsets.only(top: 60),
        child: Center(
          child: Form(
            key: _birthformkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("What's your birthdate?", style: TextStyle(
                      fontSize: 25,
                      color: AppColor.textColor,
                      fontWeight: FontWeight.bold),),
                ),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: birthDateController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      fillColor: AppColor.textfieldColor,
                      filled: true,
                      hintText: "Date of Birth",
                      prefixIcon: Icon(Icons.calendar_today, color: Colors.white,),
                      hintStyle:  TextStyle(
                          color: Colors.white, fontSize: 15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a birthdate';
                      }
                      return null;
                    },
                    onTap: (){
                      selectDate(context);
                    },
                    readOnly: true,
                  ),
                ),
                const Spacer(),
                Container(
                  height: 120,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                    color: AppColor.bottomcurveColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.arrow_back_ios_new, size: 18,
                              color: Colors.white,),
                            SizedBox(width: 8,),
                            Text("Back", style: TextStyle(
                                fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (_birthformkey.currentState!.validate()) {
                          signupController.dob = birthDateController.text.trim();
                           Navigator.of(context).push(MaterialPageRoute(builder: (e) => const GenderScreen()));
                          }
                        },
                        child: const Row(
                          children: [
                            SizedBox(width: 30,),
                            Text(
                              "Next",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8,),
                            Icon(Icons.arrow_forward_ios_rounded,size: 18,color: Colors.white,)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


