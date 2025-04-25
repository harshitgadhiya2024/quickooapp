import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickoo/Controller/update_user_data_controller.dart';
import 'package:quickoo/Controller/user_data_controller.dart';
import 'package:quickoo/Utills/profile_screen.dart';
import 'app_color.dart';

class ConfirmPhoneScreen extends StatefulWidget {
  const ConfirmPhoneScreen({super.key});

  @override
  State<ConfirmPhoneScreen> createState() => _ConfirmPhoneScreenState();
}

class _ConfirmPhoneScreenState extends State<ConfirmPhoneScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final UserDataController userDataController = Get.put(UserDataController());
  final UpdateUserDataController updateUserDataController = Get.put(UpdateUserDataController());
  final _formKey = GlobalKey<FormState>();

  String countryCode = "+91";
  bool otpSent = false;
  bool isLoading = false;
  String currentOtp = '';
  int countdown = 30;
  Timer? countdownTimer;
  bool canResend = false;

  @override
  void initState() {
    super.initState();
    currentOtp = generateOtp();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  String generateOtp() {
    return (Random().nextInt(900000) + 100000).toString();
  }

  void startCountdown() {
    setState(() {
      countdown = 30;
      canResend = false;
    });

    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown == 0) {
        timer.cancel();
        setState(() => canResend = true);
      } else {
        setState(() => countdown--);
      }
    });
  }

  bool isPhoneValid(String phone) {
    return RegExp(r'^[0-9]{10}$').hasMatch(phone);
  }

  void sendOtp() async {

    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      currentOtp = generateOtp();
      print("Generated OTP: $currentOtp");
      otpSent = true;
      isLoading = false;
      startCountdown();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP sent: $currentOtp")),
      );

      setState(() {});
    }
  }

  void resendOtp() {
    setState(() {
      currentOtp = generateOtp();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("OTP resent: $currentOtp")),
    );

    startCountdown();
  }

  void verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      if (otpController.text.trim() == currentOtp) {
        await updateUserDataController.UpdateuserData(phone: phoneController.text);
        await userDataController.fetchUserData();
        setState(() => isLoading = false);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (e)=> ProfileScreen()));

      } else {
        setState(() => isLoading = false);

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Invalid OTP"),
            content: const Text("The OTP you entered is incorrect."),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Call fetchUser() every time screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userDataController.fetchUserData();
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
      if (userDataController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      final user = userDataController.userModel.value!;
      var phonenumber = user.phoneNumber;
      List<String> parts = phonenumber.split(' ');
      phoneController.text = parts[1];
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Please verify your mobile number?",
                style: TextStyle(
                  fontSize: 25,
                  color: AppColor.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
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
                        value: parts[0],
                        dropdownColor: Colors.black,
                        items: ['+91', '+1', '+44', '+61']
                            .map((code) => DropdownMenuItem(
                          value: code,
                          child: Text(
                            code,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ))
                            .toList(),
                        onChanged: (value) => setState(() => countryCode = value!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        fillColor: AppColor.textfieldColor,
                        filled: true,
                        hintText: "Enter mobile number",
                        hintStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter phone number";
                        } else if (!isPhoneValid(value)) {
                          return "Enter 10-digit number";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.bottomcurveColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Send OTP", style: TextStyle(fontSize: 18,color: Colors.white)),
                ),
              ),
              const SizedBox(height: 60),
              if (otpSent) ...[
                const Text("Enter OTP", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 8),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.textfieldColor,
                    hintText: "------",
                    hintStyle: const TextStyle(color: Colors.white),
                    counterText: "",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "OTP is required";
                    } else if (value.length != 6) {
                      return "OTP must be 6 digits";
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: canResend ? resendOtp : null,
                      child: Text(
                        canResend ? "Resend OTP" : "Resend in $countdown s",
                        style: const TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: verifyOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.bottomcurveColor,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Submit", style: TextStyle(fontSize: 18,color: Colors.white)),
                  ),
                ),
              ],
            ],
          ),
        ),
      );})
    );
  }
}
