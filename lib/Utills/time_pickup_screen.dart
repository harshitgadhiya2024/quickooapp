import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickoo/Utills/app_color.dart';
import 'package:quickoo/Utills/passengers_screen.dart';

class TimePickupScreen extends StatefulWidget {
  final String? pickupAddress;
  final String? dropoffAddress;
  final double? distance;
  final int? duration;
  final DateTime? selectedDate;

  const TimePickupScreen({
    super.key, this.pickupAddress, this.dropoffAddress, this.distance, this.duration, this.selectedDate,

  });

  @override
  State<TimePickupScreen> createState() => _TimePickupScreenState();
}

class _TimePickupScreenState extends State<TimePickupScreen> {
  TimeOfDay? selectedTime;

  void _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  String getFormattedTime() {
    if (selectedTime == null) return 'Select Time';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, selectedTime!.hour, selectedTime!.minute);
    return DateFormat.jm().format(dt); // Example: 5:30 PM
  }

  void _goToPassengerScreen() {
    if (selectedTime != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PassengersScreen(
              pickupAddress: widget.pickupAddress,
              dropoffAddress: widget.dropoffAddress,
              distance: widget.distance,
              duration: widget.duration,
              selectedDate: widget.selectedDate,
              selectedTime: selectedTime

          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Text(
              "At what time will you pick passengers up?",
              style: TextStyle(color: Color(0xFF104E5B), fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,

                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getFormattedTime(),
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Icon(Icons.access_time),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToPassengerScreen,
        backgroundColor: AppColor.bottomcurveColor,
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }
}


