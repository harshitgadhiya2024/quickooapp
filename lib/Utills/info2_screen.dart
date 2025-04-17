import 'package:flutter/material.dart';
import 'package:quickoo/Utills/welcome_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custom_widgets.dart';
import 'app_color.dart';


class Info2Screen extends StatefulWidget {
  const Info2Screen({super.key});

  @override
  State<Info2Screen> createState() => _Info2ScreenState();
}

class _Info2ScreenState extends State<Info2Screen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showBackArrow: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              // Container(
              //     width: 200,
              //     child: Image.asset("assets/images/blacklogo.png")),
              Image.asset("assets/images/3.png"),
              const SizedBox(height: 20,),
              const Text("Enjoy the Journey", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold,),),
              const SizedBox(height: 10,),
              const Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text("Hop in, relax, and share the ride. Save", style: TextStyle(fontSize: 16, color: AppColor.textfieldColor),),
              ),
              const Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text("money, reduce emissions, and meet", style: TextStyle(fontSize: 16, color: AppColor.textfieldColor),),
              ),
              const Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text("new people along the way.", style: TextStyle(fontSize: 16, color: AppColor.textfieldColor),),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColor.bottomcurveColor
                        ),
                        child: Icon(Icons.arrow_back, color: Colors.white,),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('seenIntro', true);
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => WelcomeScreen()),
                              (Route<dynamic> route) => false,
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColor.bottomcurveColor
                        ),
                        child: Icon(Icons.arrow_forward, color: Colors.white,),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
