import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/city_map_model.dart';

class CityMapService {
  Future<List<CityMapModel>> fetchCities(String from, String to) async {
    var uri = Uri.parse('https://quickoo.stylic.ai/quickoo/get-cities-for-location');
    var response = await http.post(
      uri,
      body: {
        'from': from,
        'to': to,
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var cities = (jsonData['data'] as List)
          .map((city) => CityMapModel.fromJson(city))
          .toList();
      return cities;
    } else {
      throw Exception('Failed to load cities');
    }
  }
}