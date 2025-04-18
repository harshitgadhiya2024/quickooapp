import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    // Fetch route data after small delay (ensures LatLngs are set)
    Future.delayed(Duration(milliseconds: 300), () {
      routeController.fetchRouteData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route Selection')),
      body: Obx(() {
        return Column(
          children: [
            Expanded(
              flex: 2,
              child: routeController.pickupLatLng.value != null &&
                  routeController.dropoffLatLng.value != null
                  ? GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: routeController.pickupLatLng.value!,
                  zoom: 14,
                ),
                polylines: {
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
                          Text("City: ${routeController.dropoffAddress.value}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text("Distance: ${routeController.distance.value}"),
                          Text("Dropoff: ${routeController.dropoffAddress.value}"),
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
                    // Navigate or save
                  } else {
                    Future.delayed(Duration(milliseconds: 100), () {
                      Get.showSnackbar(GetBar(
                        message: "Please check the route to proceed.",
                        duration: Duration(seconds: 2),
                      ));
                    });
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
}
