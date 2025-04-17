
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_navigation_bar_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  bool isLoggedIn = preferences.getBool('isLoggedIn') ?? false;
  bool seenIntro = preferences.getBool('seenIntro') ?? false;
  runApp( MyApp(isLoggedIn : isLoggedIn, seenIntro: seenIntro));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool seenIntro;
  const MyApp({super.key, required this.isLoggedIn, required this.seenIntro});

  @override
  Widget build(BuildContext context) {
    Widget startScreen;
    if (!seenIntro) {
      startScreen = HomeScreen();
    } else if (isLoggedIn) {
      startScreen = BottomNavigationBarScreen();
    } else {
      startScreen = LoginScreen();
    }
    return   MaterialApp(
     debugShowCheckedModeBanner: false,
        home: startScreen
    );
  }
}
