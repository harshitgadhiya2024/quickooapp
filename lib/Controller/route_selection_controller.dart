import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RouteController extends GetxController {
  Rx<LatLng?> pickupLatLng = Rx<LatLng?>(null);
  Rx<LatLng?> dropoffLatLng = Rx<LatLng?>(null);
  RxString pickupAddress = ''.obs;
  RxString dropoffAddress = ''.obs;
  var selectedLatLng = Rx<LatLng?>(null);
  var selectedAddress = Rx<String>('');


  RxString distance = ''.obs;
  RxString time = ''.obs;

  RxList<LatLng> polylineCoordinates = <LatLng>[].obs;

  Future<void> fetchRouteData() async {
    if (pickupLatLng.value == null || dropoffLatLng.value == null) return;

    final response = await http.post(
      Uri.parse("https://quickoo.stylic.ai/quickoo/get-cities-for-location"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "pickup_lat": pickupLatLng.value!.latitude,
        "pickup_lng": pickupLatLng.value!.longitude,
        "drop_lat": dropoffLatLng.value!.latitude,
        "drop_lng": dropoffLatLng.value!.longitude,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      distance.value = data['data']['distance'] ?? '';
      time.value = data['data']['time'] ?? '';

      // Decode polyline if the API returns one
      if (data['data']['polyline'] != null) {
        polylineCoordinates.value = decodePolyline(data['data']['polyline']);
      }
    } else {
      Get.snackbar("Error", "Failed to fetch route data");
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }
}
