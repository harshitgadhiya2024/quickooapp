import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInService {

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      final userData = {
        'id' : googleUser.id,
        'email' : googleUser.email,
        'displayName' : googleUser.displayName,
        'photoUrl' : googleUser.photoUrl,
        'accessToken' : accessToken,
        'idToken' : idToken,
      };
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', jsonEncode(userData));
      prefs.setBool('isLoggedIn', true);

      return userData;

    } catch (error) {
      print('Google Sign-In Error: $error');
      return null;
    }
  }
  Future<void> _saveUserData(Map<String, dynamic> userData) async {

     final prefs = await SharedPreferences.getInstance();
     prefs.setString('user_data', jsonEncode(userData));
     prefs.setBool('is_logged_in', true);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('userData');
      prefs.setBool('isLoggedIn', false);
    } catch (error) {
      print('Sign Out Error: $error');
    }
  }
}