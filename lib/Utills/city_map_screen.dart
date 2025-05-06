import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickoo/Utills/date_selection_screen.dart';
import '../Controller/city_map_controller.dart';
import '../Controller/save_ride_controller.dart';
import 'app_color.dart';

class CityMapScreen extends StatefulWidget {
  final String from;
  final String to;
  final SaveRideController saveRideController;

  const CityMapScreen({Key? key, required this.from, required this.to, required this.saveRideController,}) : super(key: key);

  @override
  _CityMapScreenState createState() => _CityMapScreenState();
}

class _CityMapScreenState extends State<CityMapScreen> {
  late CityMapController _controller;
  GoogleMapController? _mapController;
  bool _isLoading = true;
  List<String> _selectedCities = [];

  @override
  void initState() {
    super.initState();
    _controller = CityMapController();
    _loadData();
  }

  Future<void> _loadData() async {
    await _controller.fetchAndPrepareData(widget.from, widget.to);
    setState(() {
      _isLoading = false;
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(
              _controller.cities.map((c) => c.location[0]).reduce((a, b) => a < b ? a : b),
              _controller.cities.map((c) => c.location[1]).reduce((a, b) => a < b ? a : b),
            ),
            northeast: LatLng(
              _controller.cities.map((c) => c.location[0]).reduce((a, b) => a > b ? a : b),
              _controller.cities.map((c) => c.location[1]).reduce((a, b) => a > b ? a : b),
            ),
          ),
          50, // Padding
        ),
      );
    }
  }

  void _toggleCitySelection(String cityName) {
    setState(() {
      if (_selectedCities.contains(cityName)) {
        _selectedCities.remove(cityName);
      } else {
        _selectedCities.add(cityName);
      }
    });
  }

  void _navigateToNextScreen() {
    widget.saveRideController.setCities(_selectedCities);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DateSelectionScreen(saveRideController: widget.saveRideController,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.from} to ${widget.to}', style: TextStyle(fontSize: 18),),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _controller.getInitialCameraPosition(),
                zoom: 10,
              ),
              polylines: _controller.polylines,
              markers: _controller.markers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _loadData(); // Re-run to adjust camera bounds after map is created
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text("Select Cities!", style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
                Divider(thickness: 1,),
                Expanded(
                  child: ListView.builder(
                    itemCount: _controller.cities.length,
                    itemBuilder: (context, index) {
                      final city = _controller.cities[index];
                      return ListTile(
                        leading: Checkbox(
                          value: _selectedCities.contains(city.cityName),
                          onChanged: (bool? value) {
                            _toggleCitySelection(city.cityName);
                          },
                        ),
                        title: Text(city.cityName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Distance: ${city.distanceFromStartKm.toStringAsFixed(2)} km'),
                            Text('Address: ${city.address}'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _selectedCities.isNotEmpty ? _navigateToNextScreen : null,
                    child: Text('Next', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.black
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}