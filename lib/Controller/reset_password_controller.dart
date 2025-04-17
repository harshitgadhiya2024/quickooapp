
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ResetPasswordController extends GetxController{

  Future<Map<String, Object>> resetData({
    required String newPassword,
    required String confirmPassword,
    required String user_id,
  }) async{
    try{
      final url = Uri.parse('https://quickoo.stylic.ai/quickoo/change-password');

      final Map<String,dynamic> data = {
        'password' : newPassword,
        'confirm_password' : confirmPassword,
        'user_id' : user_id
      };

      final response = await http.post(url,body: data);
      final jsonData = json.decode(response.body);
      print("data was: ${jsonData}");
      String message = jsonData['data']['message'];
      int status = jsonData['status'];
      if(response.statusCode == 200){
        return {
          'message': message,
          'status': status,
        };
      } else {
        return {
          'message': message,
          'status': status,
        };
      }
    }
    catch(e){
      print('Error during Change Password: $e');
      return {
        'message': "Please try again..",
        'status': 403,
      };
    }
  }
}