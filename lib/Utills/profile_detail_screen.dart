import 'package:flutter/material.dart';
import 'package:quickoo/app_color.dart';
import 'package:quickoo/edit_dob_screen.dart';
import 'package:quickoo/edit_firstname_screen.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  String firstName = "Harshit Gadhiya";
  String dob = "17-Nov-2000";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
       leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
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
              ],
            ),
            const SizedBox(height: 30),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(height: 10,),
            const Text("Personal Details", style: TextStyle(color: AppColor.bottomcurveColor, fontSize: 20, fontWeight: FontWeight.bold),),
            const SizedBox(height: 20),
            InkWell(
              onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>  EditFirstNameScreen(
                    firstName: "Harshit Gadhiya",
                  ),
                ),
              );
              if(result != null){
                setState(() {
                  firstName = result;
                });
              }
            },
              child: Row(
              children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                      Text(firstName, style: TextStyle(fontSize: 14, color: Colors.grey),),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded, color: AppColor.bottomcurveColor,)
                ],
            ),),
            SizedBox(height: 10,),
            Divider(thickness: 1,),
            SizedBox(height: 10,),
            InkWell(
              onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>  EditDobScreen(
                    currentDob: dob,
                  ),
                ),
              );
              if(result != null){
                setState(() {
                  dob = result;
                });
              }
            },
              child: Row(
              children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Date Of Birth", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                      Text(dob, style: TextStyle(fontSize: 14, color: Colors.grey),),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded, color: AppColor.bottomcurveColor,)
                ],
            ),),
          ],
        ),
      ),
    );
  }
}
