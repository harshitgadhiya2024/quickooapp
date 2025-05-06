// lib/models/city_models.dart
class City {
  final String address;
  final String cityName;
  final double distanceFromStartKm;
  final List<double> location;
  bool isSelected;

  City({
    required this.address,
    required this.cityName,
    required this.distanceFromStartKm,
    required this.location,
    this.isSelected = false,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      address: json['address'] ?? '',
      cityName: json['city_name'] ?? '',
      distanceFromStartKm: json['distance_from_start_km']?.toDouble() ?? 0.0,
      location: List<double>.from(json['location'] ?? [0.0, 0.0]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city_name': cityName,
      'distance_from_start_km': distanceFromStartKm,
      'location': location,
    };
  }
}

class CityResponse {
  final List<City> data;
  final int status;
  final String timestamp;

  CityResponse({
    required this.data,
    required this.status,
    required this.timestamp,
  });

  factory CityResponse.fromJson(Map<String, dynamic> json) {
    return CityResponse(
      data: (json['data'] as List)
          .map((cityJson) => City.fromJson(cityJson))
          .toList(),
      status: json['status'] ?? 0,
      timestamp: json['timestamp'] ?? '',
    );
  }
}