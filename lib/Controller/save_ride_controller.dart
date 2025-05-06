import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quickoo/Utills/globle_variable.dart';

class SaveRideController {
  String? userId = GlobleVariables.userId;
  String? from;
  String? to;
  List<String>? cities;
  String? startDate;
  String? startTime;
  int? count;
  bool? isDaily;
  List<String>? days;

  void setFrom(String location) {
    from = location;
    print('From: $from');
  }

  void setTo(String location) {
    to = location;
    print('To: $to');
  }

  void setCities(List<String> cityList) {
    cities = cityList;
    print('Cities: $cities');
  }

  void setStartDate(String date) {
    startDate = date;
    print('Start Date: $startDate');
  }

  void setStartTime(String time) {
    startTime = time;
    print('Start Time: $startTime');
  }

  void setCount(int rideCount) {
    count = rideCount;
    print('Count: $count');
  }

  void setIsDaily(bool daily) {
    isDaily = daily;
    print('Is Daily: $isDaily');
  }

  void setDays(List<String> dayList) {
    days = dayList;
    print('Days: $days');
  }

  // Method to submit ride data to the API
  Future<bool> submitRideData() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://quickoo.stylic.ai/quickoo/save_rides'),
      );

      // Add fields to the request
      userId = GlobleVariables.userId;
      request.fields['user_id'] = userId ?? '';
      request.fields['from'] = from ?? '';
      request.fields['to'] = to ?? '';
      request.fields['cities'] = jsonEncode(cities ?? []);
      request.fields['start_date'] = startDate ?? '';
      request.fields['start_time'] = startTime ?? '';
      request.fields['count'] = count?.toString() ?? '0';
      request.fields['is_daily'] = isDaily?.toString() ?? 'false';
      request.fields['days'] = jsonEncode(days ?? []);

      // Print request fields for debugging
      print('Request Fields: ${request.fields}');

      // Send the request
      var response = await request.send();

      // Read the response
      var responseBody = await response.stream.bytesToString();
      print('Response: $responseBody');

      // Check if the request was successful
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseBody);
        if (jsonResponse['status'] == 200) {
          print('Ride created successfully');
          return true;
        }
      }
      print('Failed to create ride: ${response.statusCode}');
      return false;
    } catch (e) {
      print('Error submitting ride data: $e');
      return false;
    }
  }
}