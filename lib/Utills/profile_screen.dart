
import 'package:flutter/material.dart';
import 'package:quickoo/Utills/password_screen.dart';
import 'package:quickoo/Utills/profile_detail_screen.dart';
import 'package:quickoo/Utills/profile_picture_screen.dart';
import 'package:quickoo/Utills/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_vehicle_screen.dart';
import 'app_color.dart';
import 'confirm_email_screen.dart';
import 'confirm_phone_screen.dart';
import 'edit_personal_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (e) => const ProfileDetailScreen()));
                },
                child: const Row(
                  children: [
                    CircleAvatar(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 70,
                      ),
                      radius: 40,
                      backgroundColor: Colors.black,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Harshit",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        // SizedBox(
                        //   height: ,
                        // ),
                        Text(
                          "NewComer",
                          style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded),
                    SizedBox(
                      width: 11,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (e) => EditPersonalDetailScreen()));
                },
                child: Row(
                  children: [
                    Text("Edit personal details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Divider(thickness: 1,),
              SizedBox(height: 10,),
              Text("About you", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.bottomcurveColor),),
              SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (e) => ProfilePictureScreen()));
                },
                child: const Row(
                  children: [
                    Icon(Icons.add_circle, color: Colors.black,),
                    SizedBox(width: 10,),
                    Text("Add profile picture", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),),
                    Spacer(),
                    Icon(Icons.check_circle, color: AppColor.bottomcurveColor,)
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const Divider(thickness: 1,),
              const SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (e) => const ConfirmEmailScreen()));
                },
                child: const Row(
                  children: [
                    Icon(Icons.add_circle, color: Colors.black,),
                    SizedBox(width: 10,),
                    Text("Confirm email", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),),
                    Spacer(),
                    Icon(Icons.check_circle, color: AppColor.bottomcurveColor,)
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const Divider(thickness: 1,),
              const SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (e) => const ConfirmPhoneScreen()));
                },
                child: const Row(
                  children: [
                    Icon(Icons.add_circle, color: Colors.black,),
                    SizedBox(width: 10,),
                    Text("Confirm phone number", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),),
                    Spacer(),
                    Icon(Icons.check_circle, color: AppColor.bottomcurveColor,)
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Divider(thickness: 1,),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (e) => ProfilePictureScreen()));
                },
                child: const Row(
                  children: [
                    Icon(Icons.add_circle, color: Colors.black,),
                    SizedBox(width: 10,),
                    Text("Add a mini bio", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),),
                    Spacer(),
                    Icon(Icons.check_circle, color: AppColor.bottomcurveColor,)
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const Divider(thickness: 1,),
              const SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (e) => AddVehicleScreen()));
                },
                child: const Row(
                  children: [
                    Icon(Icons.add_circle, color: Colors.black,),
                    SizedBox(width: 10,),
                    Text("Add vehicle", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),),
                    Spacer(),
                    Icon(Icons.check_circle, color: AppColor.bottomcurveColor,)
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const Divider(thickness: 1,),
              const SizedBox(height: 10,),
              const Text("Account", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.bottomcurveColor),),
              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (e) => PasswordScreen()));
                },
                child: const Row(
                  children: [
                    Text("Change password", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded, color: AppColor.bottomcurveColor,)
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const Divider(thickness: 1,),
              const SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (e) => ProfilePictureScreen()));
                },
                child: const Row(
                  children: [
                    Text("Rate the app", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded, color: AppColor.bottomcurveColor,)
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const Divider(thickness: 1,),
              const SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (e) => ProfilePictureScreen()));
                },
                child: const Row(
                  children: [
                    Text("Help", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded, color: AppColor.bottomcurveColor,)
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const Divider(thickness: 1,),
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: (){},
                child: const Row(
                  children: [
                    Text("Terms and Conditions", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded, color: AppColor.bottomcurveColor,)
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              InkWell(
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('isLoggedIn', false);
                    await prefs.setBool('seenIntro', false);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (e) => WelcomeScreen()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red
                    ),
                    child: Center(child: Text("Log out", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),)),)
              ),
              SizedBox(height: 10,),
              InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (e) => ProfilePictureScreen()));
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red
                    ),
                    child: Center(child: Text("Close my account", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),)),)
              ),
              SizedBox(height: 120,),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildVerifyTile(String text,VoidCallback onTap) {
    return TextButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.add, color: Colors.blue),
      label: Text(text, style: const TextStyle(color: Colors.blue)),
    );
  }
}