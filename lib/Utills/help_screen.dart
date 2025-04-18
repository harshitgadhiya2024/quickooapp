import 'package:quickoo/Verify_gov_id_screen.dart';
import 'package:quickoo/add_vehicle_screen.dart';
import 'package:quickoo/app_color.dart';
import 'package:quickoo/confirm_email_screen.dart';
import 'package:quickoo/confirm_phone_screen.dart';
import 'package:quickoo/edit_personal_detail_screen.dart';
import 'package:quickoo/home_screen.dart';
import 'package:quickoo/login_screen.dart';
import 'package:quickoo/mobilenumber_screen.dart';
import 'package:quickoo/password_screen.dart';
import 'package:quickoo/profile_detail_screen.dart';
import 'package:quickoo/profile_picture_screen.dart';
import 'package:quickoo/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  void _launchURL(String url_text) async {
    final Uri url = Uri.parse(url_text);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
       leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Help",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColor.bottomcurveColor,
                ),
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: (){
                  String urltext = "https://quickoo.in/";
                  _launchURL(urltext);
                },
                child: const Row(
                  children: [
                    Text(
                      "How it's works?",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColor.bottomcurveColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Divider(thickness: 1),
              const SizedBox(height: 15),
              InkWell(
                onTap: (){
                  String urltext = "https://quickoo.in/";
                  _launchURL(urltext);
                },
                child: const Row(
                  children: [
                    Text(
                      "Help Center",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColor.bottomcurveColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Divider(thickness: 1),
              const SizedBox(height: 15),
              InkWell(
                onTap: (){
                  String urltext = "https://quickoo.in/";
                  _launchURL(urltext);
                },
                child: const Row(
                  children: [
                    Text(
                      "Contact Us",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColor.bottomcurveColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Divider(thickness: 1),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
