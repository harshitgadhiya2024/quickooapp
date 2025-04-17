
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custom_widgets.dart';
import 'app_color.dart';
import 'bottom_navigation_bar_screen.dart';
import 'firstname_screen.dart';
import 'google_signin_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();

}

class _SignUpScreenState extends State<SignUpScreen> {
  final GoogleSignInService _googleSignInService = GoogleSignInService();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showBackArrow: true,
        child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
          children: [
            SizedBox(height: 20,),
        const Text(
          "How do you want to sign up ?",
          style: TextStyle(fontSize: 30, color: AppColor.textColor),
        ),
        const SizedBox(
          height: 20,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (e) => const FirstNameScreen()));
          },
          child: Container(
              alignment: Alignment.center,
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor.textfieldColor),
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/gmail.png",
                      width: 22,
                      height: 22,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "Sign up with email",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ],
                ),
              )),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
            alignment: Alignment.center,
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.textfieldColor),
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: InkWell(
                onTap: () async{
                  final user = await _googleSignInService.signInWithGoogle();
                  if (user != null) {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool('isLoggedIn', true);

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) =>  BottomNavigationBarScreen(userData: user),
                      ),
                          (route) => false,
                    );
                  }
                  else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google sign-in failed. Please try again.')));
                  }
                  },
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/search.png",
                      width: 22,
                      height: 22,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "Sign up with google",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(
          height: 15,
        ),
        Container(
            alignment: Alignment.center,
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.textfieldColor),
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/apple.png",
                    width: 28,
                    height: 28,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Text(
                    "Sign up with apple",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ],
              ),
            )),
       Spacer(),
        const Text.rich(TextSpan(
            text: "By signing up, you accept our ",
            style: TextStyle(
                color: Color(0xff333333),
                fontSize: 13,
                fontWeight: FontWeight.w300),
            children: [
              TextSpan(
                  text: "Terms and Conditions ",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                  text: "& ",
                  style: TextStyle(color: Color(0xff333333), fontSize: 13)),
              TextSpan(
                  text: "Privacy Policy.",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
            ])),
        const SizedBox(height: 10,),
        const Text.rich(
            TextSpan(
            text: "This information is collected by car_projects for the porposes of creating your account, managing your booking, using and improving our services and ensuring the security of our platform.",style: TextStyle(
            color: Color(0xff333333),
            fontSize: 13,
            fontWeight: FontWeight.w300
        )
        )
        ),
            SizedBox(height: 80,)
      ]
      ),
    )
    );
  }
}
