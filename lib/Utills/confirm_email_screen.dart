
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'app_color.dart';

class ConfirmEmailScreen extends StatefulWidget {
  const ConfirmEmailScreen({super.key});

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {

  final TextEditingController emailController = TextEditingController();
  final List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(6, (index) => FocusNode());

  String generatedOtp = "";
  bool otpSent = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100,right: 20,left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("What's your email?",
                style: TextStyle(fontSize: 25, color: AppColor.textColor, fontWeight: FontWeight.bold)),
            SizedBox(height: 20,),

            TextFormField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                fillColor: AppColor.textfieldColor,
                filled: true,
                hintText: 'Enter email',
                prefixIcon: const Icon(Icons.email, color: Colors.white),
                hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter an email address';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Enter a valid email';
                return null;
              },
            ),
            SizedBox(height: 30,),
            Center(
              child: InkWell(
                onTap: sendOtp,
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.bottomcurveColor
                  ),
                  child: Text("Send otp",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                ),
              ),
            ),
            SizedBox(height: 30),
            if (otpSent) ...[
              const Text("Enter OTP", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SizedBox(
                      width: 45,
                      height: 50,
                      child: TextField(
                        controller: otpControllers[index],
                        focusNode: otpFocusNodes[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          counterText: "",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.blue, width: 2),
                          ),
                          filled: true,
                          fillColor: AppColor.textfieldColor,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            FocusScope.of(context).requestFocus(otpFocusNodes[index + 1]);
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).requestFocus(otpFocusNodes[index - 1]);
                          }
                        },
                      ),
                    ),
                  );
                }),
              ),

            ],
          ],
        ),
      ),
    );
  }
  void sendOtp() {
    setState(() {
      generatedOtp = "123456";
      otpSent = true;

      for(int i=0;i<6;i++){
        otpControllers[i].text = generatedOtp[i];
      }
    });
  }

  void validateOtp() {
     String enteredOtp = otpControllers.map((e) => e.text).join();

     if(enteredOtp == generatedOtp){
       Get.snackbar('Success', 'OTP Verified!', snackPosition: SnackPosition.BOTTOM);
     }
     else{
       Get.defaultDialog(
         title: 'Invalid OTP',
         middleText: 'The OTP entered is incorrect. Please try again.',
         onConfirm: () {
           Get.back();
         },
       );
     }
     Future.delayed(const Duration(seconds: 1), () {
       Navigator.pop(context);
     });
  }
}

