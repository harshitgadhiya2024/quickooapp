
import 'package:flutter/material.dart';

import 'app_color.dart';

class EditFirstNameScreen extends StatefulWidget {
  const EditFirstNameScreen({super.key, required this.firstName});

  final String firstName;

  @override
  State<EditFirstNameScreen> createState() => _EditFirstNameScreenState();
}

class _EditFirstNameScreenState extends State<EditFirstNameScreen> {
  final TextEditingController fullNameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    fullNameController.text = widget.firstName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.bottomcurveColor),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    )),


                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.bottomcurveColor),
                    onPressed: () {
                      Navigator.pop(context,fullNameController.text);
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    )),

              ],
            ),
            SizedBox(height: 70,),
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

          ],
        ),
      ),
    );
  }
}
