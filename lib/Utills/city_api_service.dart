// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Model/city_model.dart';

class ApiService {
  final String baseUrl = 'https://quickoo.stylic.ai/quickoo';

  Future<CityResponse> getCitiesForLocation(String from, String to) async {
    final url = Uri.parse('$baseUrl/get-cities-for-location');

    try {
      final request = http.MultipartRequest('POST', url)
        ..fields['from'] = from
        ..fields['to'] = to;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return CityResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load cities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cities: $e');
    }
  }
}