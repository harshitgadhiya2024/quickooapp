import 'dart:math';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickoo/Controller/mobile_otp_controller.dart';

import '../Controller/signup_controller.dart';
import '../widgets/custom_widgets.dart';
import 'app_color.dart';
import 'bottom_navigation_bar_screen.dart';
import 'mobileotp_screen.dart';

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({super.key});

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  final _phoneKeyForm = GlobalKey<FormState>();
  bool phoneCheckbox = false;
  final TextEditingController mobileNumberController = TextEditingController();
  final SignupController signupController = Get.put(SignupController());
  String countryCode = "+91";
  bool isLoading = false;
  final MobileOtpController mobileOtpController = Get.put(MobileOtpController());

  String generateOtp() {
    Random random = Random();
    int otp = random.nextInt(900000) + 100000; // Generate 6-digit OTP
    return otp.toString();
  }

  void sendOtp() async{
    if (_phoneKeyForm.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      String otp = generateOtp();
       print("otp in mobile number ${otp}");
      String phone = "$countryCode ${mobileNumberController.text.trim()}";
      // var response = await mobileOtpController.sendOtpToPhone(phone);
      setState(() {
        isLoading = false;
      });

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MobileOtpScreen(
            phoneNumber: phone, sendOtp: otp,)));

    }
  }
  void skipPhone() async {
    setState(() {
      isLoading = true;
    });
    mobileNumberController.clear();
    signupController.savePhoneNumber("");
    var response = await signupController.SignupData();
    setState(() {
      isLoading = false;
    });

    if (response["status"] == 200) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => BottomNavigationBarScreen()),
            (Route<dynamic> route) => false,
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          titlePadding: EdgeInsets.zero,
          title: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Text(
              "Notification",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          content: Text(
            response["message"].toString(),
            style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("OK",
                  style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      CustomScaffold(
      showBackArrow: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Center(
          child: Form(
            key: _phoneKeyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    "Please verify your mobile number",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.textColor),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: Row(
                    children: [
                      Container(
                        height: 55,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColor.textfieldColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            menuMaxHeight: 300,
                            dropdownColor: Color(0xff333333),
                            value: countryCode,
                            items: ['+1', '+91', '+44', '+61', '+81', "+92", "+221", "+112", "+71"]
                                .map((String code) {
                              return DropdownMenuItem<String>(
                                alignment: Alignment.center,
                                value: code,
                                child: Text(code, style: const TextStyle(color:Colors.white,fontSize: 16)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                countryCode = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: mobileNumberController,
                          keyboardType: TextInputType.phone,

                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            fillColor: AppColor.textfieldColor,
                            filled: true,
                            hintText: "Enter mobile number",
                            hintStyle:
                            const TextStyle(color: Colors.white, fontSize: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a valid phone number";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 20),
                  child: Row(
                    children: [
                      Checkbox(
                          value: phoneCheckbox,
                          onChanged: (bool? value) {
                            setState(() {
                              phoneCheckbox = value!;
                            });
                          }),
                      const Expanded(
                        child: Text(
                          "I don't want to receive special offers and personalized recommendations via text messages or calls",
                          style: TextStyle(fontSize: 15, color: Color(0xff777777)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(
                  thickness: 1,
                  endIndent: 20,
                  indent: 20,
                  color: Color(0xff777777),
                ),
                const SizedBox(height: 20,),
                InkWell(
                  onTap: isLoading ? null :skipPhone,
                  child: Row(
                    children: [
                      const SizedBox(width: 20,),
                      Text("I'II do it later",style: TextStyle(color: AppColor.textColor,fontSize: 15)),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios_rounded,color: AppColor.textColor,size: 17,),
                      const SizedBox(width: 20,),
                    ],
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
                        onTap: isLoading ? null : sendOtp,
                        child: const Row(
                          children: [
                            SizedBox(width: 30,),
                            Text(
                              "Next",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8,),
                            Icon(Icons.arrow_forward_ios_rounded, size: 18,
                              color: Colors.white,)
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
    ),
        if(isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child:  const Center(child: CircularProgressIndicator(color: Colors.white,)),
          ),
      ],
    );
  }
}
