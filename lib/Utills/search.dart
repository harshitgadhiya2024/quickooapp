import 'package:flutter/material.dart';
import 'package:quickoo/Utills/app_color.dart';
import 'package:quickoo/Utills/search_passenger_count_screen.dart';
import '../Controller/save_ride_controller.dart';
import 'car.dart';
import 'drop_of_screen.dart';
import 'passengers_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String from = '';
  String to = '';
  String date = '';
  int passengers = 1;

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final dateController = TextEditingController();

  List<Map<String, dynamic>> resultCards = [];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() {
        date = "${picked.day} ${_getMonthName(picked.month)}";
        dateController.text = date;
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }

  void _search() {
    if (fromController.text.isNotEmpty &&
        toController.text.isNotEmpty &&
        date.isNotEmpty) {
      setState(() {
        resultCards.add({
          'from': fromController.text,
          'to': toController.text,
          'date': date,
          'passengers': passengers,
        });

        // Keep only the last 2 search results
        if (resultCards.length > 2) {
          resultCards.removeAt(0);
        }
      });
    }
  }

  void _navigateToPassengersScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPassengerCountScreen(
          pickupAddress: fromController.text,
          dropoffAddress: toController.text,
          selectedDate: dateController.text.isNotEmpty ? DateTime.now() : null,
        ),
      ),
    );

    if (result != null && result is int) {
      setState(() {
        passengers = result;
      });
    }
  }

  Widget buildPickupDropContainer() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Icon(Icons.circle, size: 14, color: Colors.green),
              SizedBox(height: 12),
              Container(width: 1, height: 20, color: Colors.grey),
              SizedBox(height: 12),
              Icon(Icons.circle, size: 14, color: Colors.red),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PickupLocationScreen(isFromSearchScreen: true),
                      ),
                    );
                    if (result != null && result is String) {
                      setState(() {
                        fromController.text = result;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: fromController,
                      decoration: InputDecoration(
                        hintText: "Pickup point",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Divider(height: 0),
                GestureDetector(
                  onTap: () async {
                    if (fromController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please select pickup location first"),
                        ),
                      );
                      return;
                    }
                    final SaveRideController saveRideController = SaveRideController();
                    saveRideController.setFrom(fromController.text.toString());
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DropoffScreen(
                          pickup: fromController.text,
                          saveRideController: SaveRideController(),
                          isFromSearchScreen: true,
                        ),
                      ),
                    );
                    if (result != null && result is String) {
                      setState(() {
                        toController.text = result;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: toController,
                      decoration: InputDecoration(
                        hintText: "Drop point",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black,
            ),
            child: IconButton(
              color: Colors.white,
              onPressed: () {
                setState(() {
                  final temp = fromController.text;
                  fromController.text = toController.text;
                  toController.text = temp;
                });
              },
              icon: Icon(Icons.swap_vert),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Today do you want to?",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     vehicleTile("assets/images/1-removebg-preview.png", "Auto"),
              //     vehicleTile("assets/images/2-removebg-preview.png", "Car"),
              //     vehicleTile("assets/images/3-removebg-preview.png", "Bike"),
              //   ],
              // ),
              // SizedBox(height: 20),
              buildPickupDropContainer(),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.date_range_outlined, color: Colors.black54),
                            SizedBox(width: 8),
                            Text(
                              date.isEmpty ? "Date" : date,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: _navigateToPassengersScreen,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.person_outline, color: Colors.black54),
                            SizedBox(width: 8),
                            Text(
                              "$passengers Passenger${passengers > 1 ? 's' : ''}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _search,
                child: Text(
                  "Search",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                  backgroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 20),
        
              /// Show only the last 2 search result cards
              ...resultCards.map((card) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text("${card['from']} → ${card['to']}"),
                    subtitle: Text(
                      "${card['date']}, ${card['passengers']} passenger${card['passengers'] > 1 ? 's' : ''}",
                    ),
                  ),
                );
              }).toList(),

            ],
          ),
        ),
      ),
    );
  }

  Widget vehicleTile(String imagePath, String label) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xffE9E8EC),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(imagePath, cacheWidth: 60, cacheHeight: 60),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
