class CityMapModel {
  final String address;
  final String cityName;
  final double distanceFromStartKm;
  final List<double> location;

  CityMapModel({
    required this.address,
    required this.cityName,
    required this.distanceFromStartKm,
    required this.location,
  });

  factory CityMapModel.fromJson(Map<String, dynamic> json) {
    return CityMapModel(
      address: json['address'],
      cityName: json['city_name'],
      distanceFromStartKm: json['distance_from_start_km'].toDouble(),
      location: List<double>.from(json['location'].map((x) => x.toDouble())),
    );
  }
}