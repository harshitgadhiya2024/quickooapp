import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quickoo/Utills/globle_variable.dart';

import '../app_color.dart';

class UpdateUserDataController extends GetxController {
  Future<Map<String, Object>> UpdateuserData({
    String? firstname,
    String? email,
    String? phone,
    String? dob,
  }) async {
    try {
      final url = Uri.parse(
        'https://quickoo.stylic.ai/quickoo/update-user-data',
      );
      var data = {};
      if (firstname != null) {
        data = {'first_name': firstname};
      } else if (email != null) {
        data = {'email': email};
      } else if (phone != null) {
        data = {'phone_number': phone};
      } else {
        data = {'dob': dob};
      }
      data["user_id"] = GlobleVariables.userId;

      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("Response JSON: $jsonData");
        String message = jsonData['data']['message'];
        int status = jsonData['status'];

        return {'message': message, 'status': status};
      } else {
        final jsonData = json.decode(response.body);
        print("data was: ${jsonData}");
        String message = jsonData['data']['message'];
        int status = jsonData['status'];
        return {'message': message, 'status': status};
      }
    } catch (e) {
      return {'message': 'Please try again..', 'status': 403};
    }
  }
}
