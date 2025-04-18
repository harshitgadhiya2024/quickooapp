import 'package:flutter/material.dart';
import 'package:quickoo/Utills/enable_booking_screen.dart';

class PriorityScreen extends StatefulWidget {
  final String? pickupAddress;
  final String? dropoffAddress;
  final double? distance;
  final int? duration;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final int? passengerCount;

  const PriorityScreen({super.key, this.pickupAddress, this.dropoffAddress, this.distance, this.duration, this.selectedDate, this.selectedTime, this.passengerCount});

  @override
  State<PriorityScreen> createState() => _PriorityScreenState();
}

class _PriorityScreenState extends State<PriorityScreen> {

  bool isDailyRidesEnables = false;
  Map<String,bool> selectedDays = {
    'Mon' : false,
    'Tue' : false,
    'Wed' : false,
    'Thu' : false,
    'Fri' : false,
    'Sat' : false,
    'Sun' : false,
  };

  void _showBottomSheet() async {
    final result = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15),
                    const Text(
                      "Select days for daily ride",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: selectedDays.keys.map((day) {
                        return CheckboxListTile(
                          title: Text(day),
                          value: selectedDays[day],
                          onChanged: (bool? value) {
                            setModalState(() {
                              selectedDays[day] = value ?? false;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (e) => EnableBookingScreen(
                              pickupAddress: widget.pickupAddress,
                              dropoffAddress: widget.dropoffAddress,
                              distance: widget.distance,
                              duration: widget.duration,
                              selectedDate: widget.selectedDate,
                              selectedTime: widget.selectedTime,
                              passengerCount: widget.passengerCount,
                              selectedDays: selectedDays,
                            ),
                          ),
                        );
                      },
                      child: const Text("Done"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != true) {
      setState(() {
        isDailyRidesEnables = false;
        selectedDays.updateAll((key, value) => false);
      });
    }
  }


  void _onDailyRideChanged(bool? value){
      setState(() {
        isDailyRidesEnables = value ?? false;
      });

      if(value == true){
        _showBottomSheet();
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
        padding: const EdgeInsets.all(20),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Make it priority ride",
              style: TextStyle(color: Color(0xFF104E5B), fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Checkbox(
                    value: isDailyRidesEnables,
                    onChanged: _onDailyRideChanged
                ),

                Text("Enable Daily Rides",style: TextStyle(fontSize: 20),)
              ],
            ),
            Spacer(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                ),
                onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (e) => EnableBookingScreen()));
                },
                child:Text("Next",style: TextStyle(fontSize: 18,color: Colors.white),)
            ),
          ],
        ),
      ),
    );
  }
}