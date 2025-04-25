import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/location_model.dart';

class LocationApiService {
  final String baseUrl = 'https://quickoo.stylic.ai/quickoo';

  Future<LocationData> getCitiesForLocation(String from, String to) async {
    final uri = Uri.parse('$baseUrl/get-cities-for-location');

    var request = http.MultipartRequest('POST', uri)
      ..fields['from'] = from
      ..fields['to'] = to;

    try {
      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return LocationData.fromJson(json.decode(responseString));
      } else {
        throw Exception('Failed to load cities with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}