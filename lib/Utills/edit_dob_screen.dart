import 'package:get/get.dart';
import 'package:quickoo/Controller/update_user_data_controller.dart';
import 'package:quickoo/app_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditDobScreen extends StatefulWidget {
  const EditDobScreen({super.key, required this.currentDob});

  final String currentDob;

  @override
  State<EditDobScreen> createState() => _EditDobScreenState();
}

class _EditDobScreenState extends State<EditDobScreen> {

  final TextEditingController birthDateController = TextEditingController();
  final UpdateUserDataController updateUserDataController = Get.put(UpdateUserDataController());

  void savedob(String text) async {
    var result = await updateUserDataController.UpdateuserData(dob: birthDateController.text);
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
            "OTP verified successfully!",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context,birthDateController.text);
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

  Future<void> selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: today,
        firstDate: DateTime(1900),
        lastDate: today
    );
    if(picked != null){
      setState(() {
        birthDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
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
            const SizedBox(height: 60,),
            const Text(
              "What's your date of birth?",
              style: TextStyle(
                  fontSize: 25,
                  color: AppColor.textColor,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: birthDateController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                fillColor: AppColor.textfieldColor,
                filled: true,
                hintText: "Date of Birth",
                prefixIcon: Icon(Icons.calendar_today, color: Colors.white,),
                hintStyle:  TextStyle(
                    color: Colors.white, fontSize: 15),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a birthdate';
                }
                return null;
              },
              onTap: (){
                selectDate(context);
              },
              readOnly: true,
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
                      savedob(birthDateController.text);
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
