

import 'package:flutter/material.dart';

import 'edit_dob_screen.dart';
import 'edit_firstname_screen.dart';


class EditPersonalDetailScreen extends StatefulWidget {
  const EditPersonalDetailScreen({super.key});

  @override
  State<EditPersonalDetailScreen> createState() =>
      _EditPersonalDetailScreenState();
}

class _EditPersonalDetailScreenState extends State<EditPersonalDetailScreen> {
  String firstName = "john";
  String dob = "01-02-2020";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.teal, size: 30),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal details',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 24),
            _buildItem("First name", firstName, () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>  EditFirstNameScreen(
                    firstName: firstName,
                  ),
                ),
              );
              if(result != null){
                setState(() {
                  firstName = result;
                });
              }
            }),
            _buildItem("Date of birth", dob, () async {
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
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
