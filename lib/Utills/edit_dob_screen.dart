
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app_color.dart';

class EditDobScreen extends StatefulWidget {
  const EditDobScreen({super.key, required this.currentDob});

  final String currentDob;

  @override
  State<EditDobScreen> createState() => _EditDobScreenState();
}

class _EditDobScreenState extends State<EditDobScreen> {

  final TextEditingController birthDateController = TextEditingController();
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
                      Navigator.pop(context,birthDateController.text);
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    )),

              ],
            ),
            const SizedBox(height: 70,),
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

          ],
        ),
      ),
    );
  }
}
