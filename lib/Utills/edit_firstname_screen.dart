import 'package:quickoo/Controller/update_user_data_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickoo/Controller/user_data_controller.dart';

import 'app_color.dart';

class EditFirstNameScreen extends StatefulWidget {
  const EditFirstNameScreen({super.key, required this.firstName});

  final String firstName;

  @override
  State<EditFirstNameScreen> createState() => _EditFirstNameScreenState();
}

class _EditFirstNameScreenState extends State<EditFirstNameScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final UpdateUserDataController updateUserDataController = Get.put(UpdateUserDataController());
  final UserDataController userDataController = Get.put(UserDataController());

  void savefirstname() async {
    var result = await updateUserDataController.UpdateuserData(firstname: fullNameController.text);
    if (result["status"] == 200) {
      print("Result: $result");
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
              "Success",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          content: const Text(
            "Name Update Successfully",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                Navigator.pop(context,fullNameController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("OK", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
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
              "Notification",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          content:  Text(
            result["message"].toString(),
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
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


  @override
  void initState() {
    // TODO: implement initState
    fullNameController.text = widget.firstName;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60,),
            const Text(
              "What's your full name?",
              style: TextStyle(
                  fontSize: 25,
                  color: AppColor.textColor,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: fullNameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                fillColor: AppColor.textfieldColor,
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                filled: true,
                hintText: 'Your Name',
                hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            Spacer(),
            Padding(padding: EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
                    )),


                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.bottomcurveColor),
                    onPressed: () {
                      savefirstname();
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
                    )),
              ],
            ),)
          ],
        ),
      ),
    );
  }
}
