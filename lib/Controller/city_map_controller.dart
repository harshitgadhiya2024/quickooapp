import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Model/city_map_model.dart';
import '../Utills/city_map_service.dart';

class CityMapController {
  final CityMapService _service = CityMapService();
  List<CityMapModel> cities = [];
  Set<Polyline> polylines = {};
  Set<Marker> markers = {};

  Future<void> fetchAndPrepareData(String from, String to) async {
    cities = await _service.fetchCities(from, to);
    _createPolylinesAndMarkers();
  }

  void _createPolylinesAndMarkers() {
    List<LatLng> points = cities
        .map((city) => LatLng(city.location[0], city.location[1]))
        .toList();

    polylines.add(
      Polyline(
        polylineId: PolylineId('route'),
        points: points,
        color: Colors.blue, // Blue color
        width: 5,
      ),
    );

    markers.addAll(
      cities.map(
            (city) => Marker(
          markerId: MarkerId(city.cityName),
          position: LatLng(city.location[0], city.location[1]),
          infoWindow: InfoWindow(
            title: city.cityName,
            snippet: '${city.distanceFromStartKm.toStringAsFixed(2)} km from start',
          ),
        ),
      ),
    );
  }

  LatLng getInitialCameraPosition() {
    if (cities.isNotEmpty) {
      return LatLng(cities.first.location[0], cities.first.location[1]);
    }
    return LatLng(23.01161, 72.59768); // Default to Ahmedabad
  }
}