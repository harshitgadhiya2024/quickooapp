import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickoo/Utills/date_selection_screen.dart';

import '../Controller/route_selection_controller.dart';

class RouteSelectionScreen extends StatefulWidget {
  const RouteSelectionScreen({super.key, required this.pickupAddress, required this.dropoffAddress});
  final String pickupAddress;
  final String dropoffAddress;

  @override
  State<RouteSelectionScreen> createState() => _RouteSelectionScreenState();
}

class _RouteSelectionScreenState extends State<RouteSelectionScreen> {
  final RouteController routeController = Get.find<RouteController>();
  final RxBool isChecked = false.obs;

  @override
  void initState() {
    super.initState();

    // Initialize route data in a proper sequence
    _initializeRouteData();
  }

  Future<void> _initializeRouteData() async {
    // First set addresses from widget parameters
    await routeController.setPickupAddress(widget.pickupAddress);
    await routeController.setDropoffAddress(widget.dropoffAddress);

    // Now fetch route data after coordinates are set
    await routeController.fetchRouteData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route Selection')),
      body: Obx(() {
        // Show loading state while fetching data
        if (routeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Expanded(
              flex: 2,
              child: routeController.pickupLatLng.value != null &&
                  routeController.dropoffLatLng.value != null
                  ? GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _getCenterPosition(),
                  zoom: _getAppropriateZoom(),
                ),
                polylines: {
                  if (routeController.polylineCoordinates.isNotEmpty)
                    Polyline(
                      polylineId: const PolylineId("route"),
                      color: Colors.blue,
                      width: 5,
                      points: routeController.polylineCoordinates,
                    ),

                },

                markers: {
                  Marker(
                    markerId: const MarkerId('pickup'),
                    position: routeController.pickupLatLng.value!,
                    infoWindow: InfoWindow(
                      title: "Pickup",
                      snippet: routeController.pickupAddress.value,
                    ),

                  ),
                  Marker(
                    markerId: const MarkerId('dropoff'),
                    position: routeController.dropoffLatLng.value!,
                    infoWindow: InfoWindow(
                      title: "Dropoff",
                      snippet: routeController.dropoffAddress.value,
                    ),
                  ),
                },
              )
                  : const Center(child: Text("Loading map...")),
            ),

            // Checkbox + City + Distance + Dropoff Address
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isChecked.value,
                      onChanged: (val) => isChecked.value = val ?? false,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("City: ${_extractCityName(routeController.dropoffAddress.value)}", style: const TextStyle(fontWeight: FontWeight.bold)),

                          const SizedBox(height: 4),
                          Text("Distance: ${routeController.distance.value}"),
                          Text("Address: ${routeController.dropoffAddress.value}"),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),

            // NEXT button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (isChecked.value) {
                    // Store or use data here
                    print("Pickup Address: ${routeController.pickupAddress.value}");
                    print("Dropoff Address: ${routeController.dropoffAddress.value}");
                    print("Distance: ${routeController.distance.value}");
                    print("Time: ${routeController.time.value}");

                    Navigator.push(context, MaterialPageRoute(builder: (e) => DateSelectionScreen()));
                    // Navigate or save
                  } else {
                    Get.snackbar(
                      "Required",
                      "Please check the route to proceed.",
                      duration: Duration(seconds: 2),
                    );
                  }
                },
                child: const Text("Next"),
              ),
            ),
          ],
        );
      }),
    );
  }
  String _extractCityName(String address) {
    // Extract just the city name from the address
    // This is a simple implementation - you might need to adjust based on your address format
    List<String> parts = address.split(',');
    if (parts.length > 1) {
      // Typically the city is the second-to-last or third-to-last component
      // This is just an example - adjust based on your address format
      return parts[parts.length > 2 ? parts.length - 2 : 0].trim();
    }
    return address; // Return the full address if we can't extract a city
  }

  // Helper to calculate center position between pickup and dropoff
  LatLng _getCenterPosition() {
    if (routeController.pickupLatLng.value == null || routeController.dropoffLatLng.value == null) {
      return LatLng(0, 0); // Default fallback
    }

    return LatLng(
      (routeController.pickupLatLng.value!.latitude + routeController.dropoffLatLng.value!.latitude) / 2,
      (routeController.pickupLatLng.value!.longitude + routeController.dropoffLatLng.value!.longitude) / 2,
    );
  }

  // Helper to calculate appropriate zoom level based on distance
  double _getAppropriateZoom() {
    if (routeController.pickupLatLng.value == null || routeController.dropoffLatLng.value == null) {
      return 14.0; // Default fallback
    }

    // Calculate distance between points
    double latDiff = (routeController.pickupLatLng.value!.latitude - routeController.dropoffLatLng.value!.latitude).abs();
    double lngDiff = (routeController.pickupLatLng.value!.longitude - routeController.dropoffLatLng.value!.longitude).abs();
    double maxDiff = latDiff > lngDiff ? latDiff : lngDiff;

    // Adjust zoom based on distance
    if (maxDiff > 0.1) return 10.0;
    if (maxDiff > 0.05) return 11.0;
    if (maxDiff > 0.01) return 12.0;
    if (maxDiff > 0.005) return 13.0;

    return 14.0;
  }


}