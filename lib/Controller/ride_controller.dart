import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickoo/Utills/globle_variable.dart';

// Model for Ride
class Ride {
  final List<String> cities;
  final String createdOn;
  final List<String> days;
  final String fromLocation;
  final bool isCompleted;
  final bool isDaily;
  final int persons;
  final String rideId;
  final String startDate;
  final String startTime;
  final String toLocation;
  final String userId;

  Ride({
    required this.cities,
    required this.createdOn,
    required this.days,
    required this.fromLocation,
    required this.isCompleted,
    required this.isDaily,
    required this.persons,
    required this.rideId,
    required this.startDate,
    required this.startTime,
    required this.toLocation,
    required this.userId,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      cities: List<String>.from(json['cities']),
      createdOn: json['created_on'],
      days: List<String>.from(json['days']),
      fromLocation: json['from_location'],
      isCompleted: json['is_completed'],
      isDaily: json['is_daily'],
      persons: json['persons'],
      rideId: json['ride_id'],
      startDate: json['start_date'],
      startTime: json['start_time'],
      toLocation: json['to_location'],
      userId: json['user_id'],
    );
  }
}

// Controller for Past Rides
class PastRidesController {
  List<Ride> rides = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchPastRides() async {
    await GlobleVariables.loadSavedUserId();
    var userId = GlobleVariables.userId;
    isLoading = true;
    errorMessage = null;

    try {
      var request = http.MultipartRequest(
        'GET',
        Uri.parse('https://quickoo.stylic.ai/quickoo/get_past_rides'),
      );
      request.fields['user_id'] = userId;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        if (data['status'] == 200) {
          rides = (data['data'] as List)
              .map((rideJson) => Ride.fromJson(rideJson))
              .toList();
        } else {
          errorMessage = 'API error: ${data['status']}';
        }
      } else {
        errorMessage = 'Failed to load rides: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Error fetching rides: $e';
    } finally {
      isLoading = false;
    }
  }
}
