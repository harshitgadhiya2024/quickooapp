// map_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Controller/location_controller.dart';

class MapRouteScreen extends StatelessWidget {
  final RouteController routeController = Get.put(RouteController());

  final CameraPosition initialPosition = const CameraPosition(
    target: LatLng(23.0225, 72.5714), // Ahmedabad as default
    zoom: 7,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Route Map")),
      body: Stack(
        children: [
          Obx(() {
            return GoogleMap(
              initialCameraPosition: initialPosition,
              polylines: {
                if (routeController.routePoints.isNotEmpty)
                  Polyline(
                    polylineId: const PolylineId('route'),
                    points: routeController.routePoints
                        .map((e) => LatLng(e['location'][0], e['location'][1]))
                        .toList(),
                    color: Colors.blue,
                    width: 4,
                  )
              },
              markers: routeController.routePoints.map((e) {
                return Marker(
                  markerId: MarkerId(e['city_name']),
                  position: LatLng(e['location'][0], e['location'][1]),
                  infoWindow: InfoWindow(title: e['city_name']),
                );
              }).toSet(),
              onMapCreated: (GoogleMapController controller) {
                // Optionally animate to fit the bounds
              },
            );
          }),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                routeController.fetchRoute("ahmedabad", "surat");
              },
              child: const Text("Load Route from Ahmedabad to Surat"),
            ),
          )
        ],
      ),
    );
  }
}
