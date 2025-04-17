import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:quickoo/Utills/app_color.dart';
import 'package:quickoo/Utills/profile_screen.dart';
import 'package:quickoo/Utills/search.dart';
import 'package:quickoo/Utills/your_ride_screen.dart';

import 'car.dart';
import 'inbox_screen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key, this.userData});
  final Map<String, dynamic>? userData;

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  final _pageController = PageController();
  final NotchBottomBarController _bottomBarController =
      NotchBottomBarController();

  int _currentIndex = 0;

  final List<Widget> _pages = [
    SearchScreen(),
    const PickupLocationScreen(),
    const YourRideScreen(),
    const InboxScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
        extendBody: true,
        bottomNavigationBar: AnimatedNotchBottomBar(
          notchBottomBarController: _bottomBarController,
          color: Colors.black,
          showLabel: false,
          notchColor: AppColor.bottomcurveColor,
          removeMargins: false,
          bottomBarWidth: MediaQuery.of(context).size.width * 0.85,
          durationInMilliSeconds: 300,

          bottomBarItems: const [
            BottomBarItem(

                inActiveItem: Icon(Icons.search,color: Colors.white,),
                activeItem: Icon(Icons.search, color: Colors.white,)),
            BottomBarItem(
                inActiveItem: Icon(Icons.directions_car,color: Colors.white,),
                activeItem: Icon(Icons.directions_car, color: Colors.white)),
            BottomBarItem(
                inActiveItem: Icon(Icons.bolt,color: Colors.white,),
                activeItem: Icon(Icons.bolt, color: Colors.white)),
            BottomBarItem(
                inActiveItem: Icon(Icons.chat_bubble_outline,color: Colors.white,),
                activeItem: Icon(Icons.chat_bubble_outline, color: Colors.white)),
            BottomBarItem(
                inActiveItem: Icon(Icons.person,color: Colors.white,),
                activeItem: Icon(Icons.person, color: Colors.white)),
          ],
          onTap: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          kIconSize: 24,
          kBottomRadius: 35.0,
        ),
      ),
    );
  }
}
