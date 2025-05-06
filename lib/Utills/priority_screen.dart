import 'package:flutter/material.dart';
import 'package:quickoo/Utills/enable_booking_screen.dart';

import '../Controller/save_ride_controller.dart';

class PriorityScreen extends StatefulWidget {
  final SaveRideController saveRideController;
  const PriorityScreen({super.key, required this.saveRideController,});

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
                      onPressed: () async {
                        List<String> getSelectedDays(Map<String, bool> selectedDays) {
                          return selectedDays.entries
                              .where((entry) => entry.value == true)
                              .map((entry) => entry.key.toLowerCase()) // Convert to lowercase to match API format
                              .toList();
                        }
                        List<String> trueDays = getSelectedDays(selectedDays);
                        widget.saveRideController.setIsDaily(true);
                        widget.saveRideController.setDays(trueDays);
                        bool success = await widget.saveRideController.submitRideData();
                        success ?
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Ride created successfully!'),
                          ),
                        ) : ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Failed to create ride.'),
                          ),
                        );
                        Navigator.pop(context, true);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (e) => EnableBookingScreen(
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
                onPressed: () async {
                  List<String> getSelectedDays(Map<String, bool> selectedDays) {
                    return selectedDays.entries
                        .where((entry) => entry.value == true)
                        .map((entry) => entry.key.toLowerCase()) // Convert to lowercase to match API format
                        .toList();
                  }
                  List<String> trueDays = getSelectedDays(selectedDays);
                  widget.saveRideController.setIsDaily(false);
                  widget.saveRideController.setDays(trueDays);
                  bool success = await widget.saveRideController.submitRideData();
                  success ?
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Ride created successfully!'),
                    ),
                  ) : ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text('Failed to create ride.'),
                    ),
                  );
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