import 'package:flutter/material.dart';
import 'package:quickoo/Utills/app_color.dart';

class SearchPassengerCountScreen extends StatefulWidget {
  final String pickupAddress;
  final String dropoffAddress;
  final DateTime? selectedDate;

  const SearchPassengerCountScreen({
    Key? key,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _SearchPassengerCountScreenState createState() => _SearchPassengerCountScreenState();
}

class _SearchPassengerCountScreenState extends State<SearchPassengerCountScreen> {
  int count = 1;

  void increment() {
    setState(() {
      count++;
    });
  }

  void decrement() {
    if (count > 1) {
      setState(() {
        count--;
      });
    }
  }

  void submit() {
    Navigator.pop(context, count);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(height: 20),
            const Text(
              "How many passengers?",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: FloatingActionButton(

                    heroTag: 'decrement',
                    onPressed: decrement,

                    child: const Icon(Icons.remove,size: 30,),
                    mini: true,
                  ),
                ),
                const SizedBox(width: 50),
                Text(
                  "$count",
                  style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 50),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: FloatingActionButton(
                    heroTag: 'increment',
                    onPressed: increment,
                    child: const Icon(Icons.add,size: 30,),
                    mini: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),

          ],
        ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: submit,
        backgroundColor: AppColor.bottomcurveColor,
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
    );
  }
}
