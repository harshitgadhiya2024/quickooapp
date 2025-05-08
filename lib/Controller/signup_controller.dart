
import 'dart:convert';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Utills/globle_variable.dart';
class SignupController extends GetxController {
  String firstName = '';
  String dob = '';
  String gender = '';
  String password = '';
  String email = '';
  String phoneNumber = '';

  void saveFirstName(String name) {
    firstName = name;
  }

  void saveDOB(String value) {
    dob = value;
  }

  void saveGender(String value) {
    gender = value;
  }

  void savePassword(String value) {
    password = value;
  }

  void saveEmail(String value) {
    email = value;
  }

  void savePhoneNumber(String value) {
    phoneNumber = value;
  }

  Future<Map<String, Object>> SignupData() async {
    try {
      final url = Uri.parse('https://quickoo.stylic.ai/quickoo/register-user');

      final Map<String, dynamic> data = {
        'first_name': firstName,
        'dob': dob,
        'gender': gender,
        'password': password,
        'email': email,
        'phone_number': phoneNumber,
      };

      print("json data: ${data}");

      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("data was: ${jsonData}");
        String user_id = jsonData['data']['user_id'];
        int status = jsonData['status'];
        GlobleVariables.userId = jsonData["data"]["user_id"].toString();
        print("GlobalVariables.regId :- ${GlobleVariables.userId}");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', user_id);
        return {
          'user_id': user_id,
          'status': status,
        };
      } else {
        final jsonData = json.decode(response.body);
        print("data was: ${jsonData}");
        String message = jsonData['data']['message'];
        int status = jsonData['status'];
        return {
          'message': message,
          'status': status,
        };
      }
    } catch (e) {
      return {
        'message': 'Please try again',
        'status': 403,
      };
    }
  }
}
