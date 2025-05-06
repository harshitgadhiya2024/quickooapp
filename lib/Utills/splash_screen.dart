import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:quickoo/Utills/home_screen.dart';
import 'package:lottie/lottie.dart'; // Add this import

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  final String imagePath;
  final String companyName;
  final Duration duration;
  final Color backgroundColor;
  const SplashScreen({
    super.key, required this.nextScreen, required this.imagePath, required this.duration, required this.backgroundColor, required this.companyName,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Create a scale animation
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    // Start the animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // This will scale and rotate the logo
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: Image.asset(
              widget.imagePath, // Replace with your car app logo
              width: 150,
              height: 150,
            ),
          ),
          const SizedBox(height: 30),
          // Car animation using Lottie
          SizedBox(
            width: 200,
            height: 100,
            child: Lottie.asset(
              'assets/animation/car_animation.json', // Add a car animation Lottie file
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.companyName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
      nextScreen: widget.nextScreen,
      duration: 3500,
      backgroundColor: widget.backgroundColor,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(milliseconds: 1000),
    );
  }
}