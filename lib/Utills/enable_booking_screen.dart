import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quickoo/Utills/bottom_navigation_bar_screen.dart';

class EnableBookingScreen extends StatefulWidget {
  const EnableBookingScreen({super.key});

  @override
  State<EnableBookingScreen> createState() => _EnableBookingScreenState();
}

class _EnableBookingScreenState extends State<EnableBookingScreen> {

  @override
  void initState() {
    Timer(Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (e)=> BottomNavigationBarScreen()));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              SizedBox(height: 150,),
              Image.asset("assets/images/8489144.jpg"),
              SizedBox(height: 30,),
              Text("Enable Instant Booking for your passengers",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}
