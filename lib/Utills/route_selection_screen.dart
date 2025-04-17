import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:quickoo/Utills/app_color.dart';
import 'package:quickoo/Utills/date_selection_screen.dart';


class RouteSelectionScreen extends StatefulWidget {
  final String pickupAddress;
  final String dropoffAddress;

  const RouteSelectionScreen({
    Key? key,
    required this.pickupAddress,
    required this.dropoffAddress,
  }) : super(key: key);

  @override
  State<RouteSelectionScreen> createState() => _RouteSelectionScreenState();
}

class _RouteSelectionScreenState extends State<RouteSelectionScreen> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  LatLng? _pickupLatLng;
  LatLng? _dropoffLatLng;

  // Route options
  List<RouteOption> routeOptions = [];
  int selectedRouteIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getLocationCoordinates();
  }

  Future<void> _getLocationCoordinates() async {
    try {
      // Get coordinates for pickup and dropoff addresses
      List<Location> pickupLocations = await locationFromAddress(widget.pickupAddress);
      List<Location> dropoffLocations = await locationFromAddress(widget.dropoffAddress);

      if (pickupLocations.isNotEmpty && dropoffLocations.isNotEmpty) {
        _pickupLatLng = LatLng(
          pickupLocations.first.latitude,
          pickupLocations.first.longitude,
        );

        _dropoffLatLng = LatLng(
          dropoffLocations.first.latitude,
          dropoffLocations.first.longitude,
        );

        // Generate mock route options
        _generateRouteOptions();

        // Draw route on map
        _drawRoute();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading locations: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _generateRouteOptions() {
    // Create mock route options similar to the image
    routeOptions = [
      RouteOption(
        duration: 39,
        distance: 19,
        hasTolls: false,
        viaRoute: 'Narol - Naroda Rd and NH64',
      ),
      RouteOption(
        duration: 40,
        distance: 16,
        hasTolls: false,
        viaRoute: 'Narol - Naroda Rd',
      ),
      RouteOption(
        duration: 42,
        distance: 14,
        hasTolls: false,
        viaRoute: 'Relief Rd',
      ),
    ];
  }

  void _drawRoute() {
    if (_pickupLatLng != null && _dropoffLatLng != null) {
      // Create a polyline for the selected route
      _polylines.clear();

      // Different colors for different routes
      Color routeColor = Colors.blue;

      // For a simple straight line, just connect the two points
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route_$selectedRouteIndex'),
          color: routeColor,
          width: 5,
          points: _getRoutePoints(),
        ),
      );

      if (_mapController != null) {
        _updateCameraPosition();
      }

      setState(() {});
    }
  }

  List<LatLng> _getRoutePoints() {
    // In a real app, this would come from a directions API
    // This is a simplified version with curved routes

    if (_pickupLatLng == null || _dropoffLatLng == null) {
      return [];
    }

    // For curved route, add some intermediate points
    double latDiff = _dropoffLatLng!.latitude - _pickupLatLng!.latitude;
    double lngDiff = _dropoffLatLng!.longitude - _pickupLatLng!.longitude;

    // Different curve for each route option
    double curveFactor;
    switch (selectedRouteIndex) {
      case 0:
        curveFactor = 0.2;
        break;
      case 1:
        curveFactor = 0.1;
        break;
      case 2:
        curveFactor = -0.15;
        break;
      default:
        curveFactor = 0.2;
    }

    List<LatLng> routePoints = [];
    routePoints.add(_pickupLatLng!);

    // Add some points to create a curve
    for (int i = 1; i < 10; i++) {
      double fraction = i / 10.0;
      double lat = _pickupLatLng!.latitude + (latDiff * fraction);
      double lng = _pickupLatLng!.longitude + (lngDiff * fraction);

      // Add curve - perpendicular to the straight line
      double curveAmt = sin(3.14 * fraction) * curveFactor;
      lat += lngDiff * curveAmt;
      lng -= latDiff * curveAmt;

      routePoints.add(LatLng(lat, lng));
    }

    routePoints.add(_dropoffLatLng!);
    return routePoints;
  }

  void _updateCameraPosition() {
    if (_pickupLatLng != null && _dropoffLatLng != null && _mapController != null) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          _pickupLatLng!.latitude < _dropoffLatLng!.latitude
              ? _pickupLatLng!.latitude
              : _dropoffLatLng!.latitude,
          _pickupLatLng!.longitude < _dropoffLatLng!.longitude
              ? _pickupLatLng!.longitude
              : _dropoffLatLng!.longitude,
        ),
        northeast: LatLng(
          _pickupLatLng!.latitude > _dropoffLatLng!.latitude
              ? _pickupLatLng!.latitude
              : _dropoffLatLng!.latitude,
          _pickupLatLng!.longitude > _dropoffLatLng!.longitude
              ? _pickupLatLng!.longitude
              : _dropoffLatLng!.longitude,
        ),
      );

      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50), // 50 is padding
      );
    }
  }

  void _selectRoute(int index) {
    setState(() {
      selectedRouteIndex = index;
    });
    _drawRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          (_pickupLatLng != null && _dropoffLatLng != null)
              ? GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickupLatLng!,
              zoom: 12,
            ),
            markers: {
              Marker(
                markerId: MarkerId('pickup'),
                position: _pickupLatLng!,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
              ),
              Marker(
                markerId: MarkerId('dropoff'),
                position: _dropoffLatLng!,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
              ),
            },
            polylines: _polylines,
            onMapCreated: (controller) {
              _mapController = controller;
              _updateCameraPosition();
            },
          )
              : Center(child: CircularProgressIndicator()),

          // Back button
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Bottom sheet with route options
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.25,
            maxChildSize: 0.5,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sheet handle
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // Title
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "What is your route?",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                      ),
                    ),

                    // Route options
                    Expanded(
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : ListView.separated(
                        controller: scrollController,
                        itemCount: routeOptions.length,
                        separatorBuilder: (context, index) => Divider(),
                        itemBuilder: (context, index) {
                          return _buildRouteOption(
                            routeOptions[index],
                            index == selectedRouteIndex,
                            index,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Next button
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              child: Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DateSelectionScreen(
                      pickupAddress: widget.pickupAddress,
                      dropoffAddress: widget.dropoffAddress,
                      distance: routeOptions[selectedRouteIndex].distance,
                      duration: routeOptions[selectedRouteIndex].duration,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteOption(RouteOption route, bool isSelected, int index) {
    return InkWell(
      onTap: () => _selectRoute(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            // Radio button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey,
                  width: 2,
                ),
              ),
              child: Center(
                child: isSelected
                    ? Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                )
                    : null,
              ),
            ),
            SizedBox(width: 16),
            // Route details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${route.duration} min",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                      ),
                      Text(
                        " - No tolls",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${route.distance} km - ${route.viaRoute}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RouteOption {
  final int duration; // in minutes
  final double distance; // in km
  final bool hasTolls;
  final String viaRoute;

  RouteOption({
    required this.duration,
    required this.distance,
    required this.hasTolls,
    required this.viaRoute,
  });
}

// This would be implemented in a real app to handle ride confirmation
class RideConfirmationScreen extends StatelessWidget {
  final String pickupAddress;
  final String dropoffAddress;
  final double distance;
  final int duration;

  const RideConfirmationScreen({
    Key? key,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.distance,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder for actual implementation
    return Scaffold(
      appBar: AppBar(title: Text("Confirm Ride")),
      body: Center(
        child: Text("Ride confirmation screen would go here"),
      ),
    );
  }
}