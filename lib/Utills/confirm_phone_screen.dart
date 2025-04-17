
import 'package:flutter/material.dart';

import 'app_color.dart';

class ConfirmPhoneScreen extends StatefulWidget {
  const ConfirmPhoneScreen({super.key});

  @override
  State<ConfirmPhoneScreen> createState() => _ConfirmPhoneScreenState();
}

class _ConfirmPhoneScreenState extends State<ConfirmPhoneScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());
  String countryCode = "+91";
  String generateOtp = "";
  bool otpSend = false;

  final _formKey = GlobalKey<FormState>();

  bool isPhoneValid(String phone) {
    final phoneRegExp = RegExp(r'^[0-9]{10}$');
    return phoneRegExp.hasMatch(phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100, right: 20, left: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Please verify your mobile number?",
                  style: TextStyle(fontSize: 25,
                      color: AppColor.textColor,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20,),
              Row(
                children: [
                  Container(
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
                        items: [
                          '+1',
                          '+91',
                          '+44',
                          '+61',
                          '+81',
                          "+92",
                          "+221",
                          "+112",
                          "+71"
                        ]
                            .map((String code) {
                          return DropdownMenuItem<String>(
                            alignment: Alignment.center,
                            value: code,
                            child: Text(code, style: const TextStyle(
                                color: Colors.white, fontSize: 16)),
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
                      controller: phoneController,
                      keyboardType: TextInputType.phone,

                      style: const TextStyle(color: Colors.white),
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
                        if (!isPhoneValid(value)) {
                          return "Please enter a valid 10-digit phone number";
                        }
                        return null; // Return null if valid
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40,),
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
                    child: Text("Send otp", style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),),
                  ),
                ),
              ),
              SizedBox(height: 60,),

              if (otpSend) ...[
                const Text("Enter OTP", style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SizedBox(
                        width: 45,
                        height: 50,
                        child: TextFormField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white,
                              fontSize: 20,
                              letterSpacing: 8),
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
                              return "Enter a valid OTP";
                            }

                            return null;
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
      ),
    );
  }

  void sendOtp() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        generateOtp = "123456";
        otpSend = true;
      });
    }
  }
}
