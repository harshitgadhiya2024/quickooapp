import 'package:flutter/material.dart';
import 'package:quickoo/Utills/priority_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_color.dart';


class PassengersScreen extends StatefulWidget {
  const PassengersScreen({
    super.key,
    this.pickupAddress,
    this.dropoffAddress,
    this.distance,
    this.duration,
    this.selectedDate,
    this.selectedTime,
  });

  final String? pickupAddress;
  final String? dropoffAddress;
  final double? distance;
  final int? duration;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;

  @override
  State<PassengersScreen> createState() => _PassengersScreenState();
}

class _PassengersScreenState extends State<PassengersScreen> {
  int passengerCount = 1;

  @override
  void initState() {
    super.initState();
    _loadPassengerCount();
  }

  Future<void> _loadPassengerCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      passengerCount = prefs.getInt('passengerCount') ?? 1;
    });
  }

  Future<void> _savePassengerCountAndNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('passengerCount', passengerCount);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PriorityScreen(

        pickupAddress: widget.pickupAddress,
        dropoffAddress: widget.dropoffAddress,
        distance: widget.distance,
        duration: widget.duration,
        selectedDate: widget.selectedDate,
        selectedTime: widget.selectedTime,
        passengerCount: passengerCount,
      )),
    );
  }

  void _increment() {
    setState(() {
      passengerCount++;
    });
  }

  void _decrement() {
    if (passengerCount > 1) {
      setState(() {
        passengerCount--;
      });
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "So how many quickoo passengers can you take?",
              style: TextStyle(
                color: Color(0xFF104E5B),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _decrement,
                  icon: const Icon(Icons.remove_circle_outline_outlined),
                  iconSize: 40,
                ),
                const SizedBox(width: 85),
                Text(
                  passengerCount.toString(),
                  style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 85),
                IconButton(
                  onPressed: _increment,
                  icon: const Icon(Icons.add_circle_outline),
                  iconSize: 40,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _savePassengerCountAndNavigate,
        backgroundColor: AppColor.bottomcurveColor,
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }
}
