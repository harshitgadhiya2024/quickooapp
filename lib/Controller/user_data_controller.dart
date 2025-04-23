import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:quickoo/Model/UserModel.dart';
import 'package:quickoo/Utills/globle_variable.dart';

class UserModel {
  final String bio;
  final String dob;
  final String email;
  final String firstName;
  final String gender;
  final bool isActive;
  final bool isBio;
  final bool isEmail;
  final bool isPayment;
  final bool isPhone;
  final bool isProfile;
  final bool isVehicle;
  final bool isVerified;
  final String password;
  final Map<String, dynamic> paymentDetails;
  final String phoneNumber;
  final String profileUrl;
  final String type;
  final String userId;
  final Map<String, dynamic> vehicleDetails;

  UserModel({
    required this.bio,
    required this.dob,
    required this.email,
    required this.firstName,
    required this.gender,
    required this.isActive,
    required this.isBio,
    required this.isEmail,
    required this.isPayment,
    required this.isPhone,
    required this.isProfile,
    required this.isVehicle,
    required this.isVerified,
    required this.password,
    required this.paymentDetails,
    required this.phoneNumber,
    required this.profileUrl,
    required this.type,
    required this.userId,
    required this.vehicleDetails,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      bio: json['bio'] ?? '',
      dob: json['dob'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      gender: json['gender'] ?? '',
      isActive: json['is_active'] ?? false,
      isBio: json['is_bio'] ?? false,
      isEmail: json['is_email'] ?? false,
      isPayment: json['is_payment'] ?? false,
      isPhone: json['is_phone'] ?? false,
      isProfile: json['is_profile'] ?? false,
      isVehicle: json['is_vehicle'] ?? false,
      isVerified: json['is_verified'] ?? false,
      password: json['password'] ?? '',
      paymentDetails: json['payment_details'] ?? {},
      phoneNumber: json['phone_number'] ?? '',
      profileUrl: json['profile_url'] ?? '',
      type: json['type'] ?? '',
      userId: json['user_id'] ?? '',
      vehicleDetails: json['vehicle_details'] ?? {},
    );
  }
}

class UserDataController extends GetxController {
  var userModel = Rxn<UserModel>();
  final isLoading = false.obs;
  final error = ''.obs;

  Future<void> fetchUserData() async {
    isLoading.value = true;
    try {
      final url = Uri.parse('https://quickoo.stylic.ai/quickoo/get-user-data');

      final Map<String, dynamic> data = {
        "user_id": GlobleVariables.userId,
      };
      print("userid was: ${GlobleVariables.userId}");
      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        print("output in data: ${data}");
        userModel.value = UserModel.fromJson(data);
      } else {
        print(response.body);
      }
      isLoading.value = false;
    } catch (e) {
      print("error in fetching data: ${e}");
    }
  }
}