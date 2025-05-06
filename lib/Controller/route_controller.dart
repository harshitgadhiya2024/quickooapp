// lib/controllers/route_controller.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../Model/city_model.dart';
import '../Utills/city_api_service.dart';

class CityRouteController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<City> _cities = [];
  City? _selectedCity;
  bool _isLoading = false;
  String? _error;

  // Getter methods
  List<City> get cities => _cities;
  City? get selectedCity => _selectedCity;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Method to fetch cities
  Future<void> fetchCities(String from, String to) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getCitiesForLocation(from, to);
      _cities = response.data;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Method to select a city
  void selectCity(City city) {
    _selectedCity = city;
    notifyListeners();
  }

  // Method to create map markers for all cities
  Set<Marker> getMarkers() {
    return _cities.map((city) {
      return Marker(
        markerId: MarkerId(city.cityName),
        position: LatLng(city.location[0], city.location[1]),
        infoWindow: InfoWindow(
          title: city.cityName,
          snippet: '${city.distanceFromStartKm.toStringAsFixed(2)} km',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          city.cityName == _cities.first.cityName || city.cityName == _cities.last.cityName
              ? BitmapDescriptor.hueRed
              : BitmapDescriptor.hueBlue,
        ),
      );
    }).toSet();
  }

  // Method to get polyline points for the route
  List<LatLng> getRoutePoints() {
    return _cities.map((city) => LatLng(city.location[0], city.location[1])).toList();
  }

  // Get map bounds to fit all markers
  LatLngBounds getBounds() {
    if (_cities.isEmpty) {
      return LatLngBounds(
        southwest: const LatLng(20.0, 70.0),
        northeast: const LatLng(24.0, 74.0),
      );
    }

    double minLat = _cities.first.location[0];
    double maxLat = _cities.first.location[0];
    double minLng = _cities.first.location[1];
    double maxLng = _cities.first.location[1];

    for (var city in _cities) {
      if (city.location[0] < minLat) minLat = city.location[0];
      if (city.location[0] > maxLat) maxLat = city.location[0];
      if (city.location[1] < minLng) minLng = city.location[1];
      if (city.location[1] > maxLng) maxLng = city.location[1];
    }

    return LatLngBounds(
      southwest: LatLng(minLat - 0.5, minLng - 0.5),
      northeast: LatLng(maxLat + 0.5, maxLng + 0.5),
    );
  }
}