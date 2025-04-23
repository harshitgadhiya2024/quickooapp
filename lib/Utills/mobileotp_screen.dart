import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Controller/signup_controller.dart';
import '../widgets/custom_widgets.dart';
import 'app_color.dart';
import 'bottom_navigation_bar_screen.dart';


class MobileOtpScreen extends StatefulWidget {
  const MobileOtpScreen({super.key, required this.phoneNumber, required this.sendOtp});
  final String phoneNumber;
  final String sendOtp;

  @override
  State<MobileOtpScreen> createState() => _MobileOtpScreenState();
}


class _MobileOtpScreenState extends State<MobileOtpScreen> {
  final List<FocusNode> otpFocusNodes = List.generate(6, (index) => FocusNode());
  final TextEditingController otpController = TextEditingController();
  final SignupController signupController = Get.find<SignupController>();

  final _mobileotpFormKey = GlobalKey<FormState>();
  bool canResend = false;
  int countdown = 30;
  Timer? countdownTimer;
  bool lastOtpFailed = false;
  bool isLoading = false;

  late String generatedOtp;
  late String currentOtp;

  @override
  void initState() {
    super.initState();
    currentOtp = widget.sendOtp;
    startCountdown();
  }


  void startCountdown() {
    setState(() {
      canResend = false;
      countdown = 30;
    });

    countdownTimer?.cancel();

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown == 0) {
        timer.cancel();
        setState(() {
          canResend = true;
        });
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

  void showOtpInfo(String otp){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP send to ${widget.phoneNumber}: $otp")));
  }

  void verifyOtp() async {
    if (_mobileotpFormKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      if (otpController.text == currentOtp) {
        signupController.savePhoneNumber(widget.phoneNumber);
        var response = await signupController.SignupData();
        setState(() {
          isLoading = false;
        });
        if (response["status"]==200) {
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
                  "Notifications",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              content: Text(
                response["message"].toString(),
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
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
                  child: const Text("OK", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        }

      } else {
        setState(() {
          isLoading = false;
          canResend = true;
          lastOtpFailed = true;
        });

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
                "Invalid OTP",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            content: const Text(
              "The OTP you entered is incorrect. Please try again.",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
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
                child: const Text("OK", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          ),

        );
      }
    }
  }

  void ResendOtp() async {

    setState(() => isLoading = true);

    String otp = (Random().nextInt(900000) + 100000).toString();
    print("new otp for mobile number: ${otp}");
    setState(() {
      currentOtp = otp;
      isLoading = false;
    });
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
            color: Colors.green,
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
        content:  Text(
          "Otp sent successfully...",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
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
            child: const Text("OK", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    // if (result["status"] == 200) {
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //       backgroundColor: Colors.white,
    //       titlePadding: EdgeInsets.zero,
    //       title: Container(
    //         width: double.infinity,
    //         padding: const EdgeInsets.all(16),
    //         decoration: const BoxDecoration(
    //           color: Colors.green,
    //           borderRadius: BorderRadius.only(
    //             topLeft: Radius.circular(12),
    //             topRight: Radius.circular(12),
    //           ),
    //         ),
    //         child: const Text(
    //           "Notification",
    //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    //         ),
    //       ),
    //       content:  Text(
    //         result["message"].toString(),
    //         style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
    //       ),
    //       actions: [
    //         ElevatedButton(
    //           onPressed: () => Navigator.of(context).pop(),
    //           style: ElevatedButton.styleFrom(
    //             backgroundColor: Colors.white,
    //             foregroundColor: Colors.black,
    //             side: const BorderSide(color: Colors.black),
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(10),
    //             ),
    //           ),
    //           child: const Text("OK", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    //         ),
    //       ],
    //     ),
    //   );
    //   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["message"].toString())));
    //   for(var controller in otpControllers){
    //     controller.clear();
    //   }
    //   lastOtpFailed = false;
    //   startCountdown();
    // } else {
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //       backgroundColor: Colors.white,
    //       titlePadding: EdgeInsets.zero,
    //       title: Container(
    //         width: double.infinity,
    //         padding: const EdgeInsets.all(16),
    //         decoration: const BoxDecoration(
    //           color: Colors.red,
    //           borderRadius: BorderRadius.only(
    //             topLeft: Radius.circular(12),
    //             topRight: Radius.circular(12),
    //           ),
    //         ),
    //         child: const Text(
    //           "Notification",
    //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    //         ),
    //       ),
    //       content:  Text(
    //         result["message"].toString(),
    //         style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
    //       ),
    //       actions: [
    //         ElevatedButton(
    //           onPressed: () => Navigator.of(context).pop(),
    //           style: ElevatedButton.styleFrom(
    //             backgroundColor: Colors.white,
    //             foregroundColor: Colors.black,
    //             side: const BorderSide(color: Colors.black),
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(10),
    //             ),
    //           ),
    //           child: const Text("OK", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
    //         ),
    //       ],
    //     ),
    //   );
    //   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["message"].toString())));
    // }
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      CustomScaffold(
      showBackArrow: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Form(
          key: _mobileotpFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "Verify Mobile Number",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 22, right: 22),
                child: Text(
                  "Enter the 6-digit OTP sent to ${widget.phoneNumber}",
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color:Colors.white,fontSize: 20, letterSpacing: 8),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.textfieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: "------",
                    hintStyle: TextStyle(color: Color(0xffffffff)),
                    counterText: "",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "OTP is required";
                    }
                    if (value.length != 6) {
                      return "OTP must be 6 digits";
                    }
                    return null;
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: canResend && !isLoading ? ResendOtp : null,
                    child:  Text(
                      canResend ? "Resend OTP" : "Resend in $countdown s",
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                  SizedBox(width: 25,),
                ],
              ),
              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: isLoading ? null : verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.bottomcurveColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
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
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Back",
                        style: TextStyle(
                            fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
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
        if(isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child:  const Center(child: CircularProgressIndicator(color: Colors.white,)),
          ),
      ],
    );
  }
}
