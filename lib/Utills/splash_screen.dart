import 'package:flutter/material.dart';

class EnhancedSplashScreen extends StatefulWidget {
  final Widget nextScreen;
  final String logoPath;
  final String companyName;
  final Duration duration;
  final Color primaryColor;
  final Color secondaryColor;

  const EnhancedSplashScreen({
    Key? key,
    required this.nextScreen,
    required this.logoPath,
    required this.companyName,
    this.duration = const Duration(seconds: 4),
    this.primaryColor = const Color(0xFF2C3E50),
    this.secondaryColor = const Color(0xFF3498DB),
  }) : super(key: key);

  @override
  State<EnhancedSplashScreen> createState() => _EnhancedSplashScreenState();
}

class _EnhancedSplashScreenState extends State<EnhancedSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundController;
  late AnimationController _carController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _particleController;

  late Animation<double> _backgroundAnimation;
  late Animation<double> _carAnimation;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    // Background animation
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeOut,
    );

    // Car animation controller
    _carController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _carAnimation = Tween<double>(begin: -1.2, end: 0.0).animate(
      CurvedAnimation(
        parent: _carController,
        curve: Curves.easeOutQuart,
      ),
    );

    // Logo animation controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );

    // Text animation controller
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Particle effect controller
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
      reverseDuration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Sequence the animations
    _backgroundController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _carController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1300), () {
      _logoController.forward();
    });
    Future.delayed(const Duration(milliseconds: 1800), () {
      _textController.forward();
    });

    // Navigate to next screen after the duration
    Future.delayed(widget.duration, () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => widget.nextScreen,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _carController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _backgroundController,
          _carController,
          _logoController,
          _textController,
          _particleController
        ]),
        builder: (context, child) {
          return Stack(
            children: [
              // Animated gradient background
              Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.primaryColor,
                      Color.lerp(widget.primaryColor, widget.secondaryColor,
                          _backgroundAnimation.value) ?? widget.secondaryColor,
                      widget.secondaryColor,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              // Road with perspective effect
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: size.height * 0.4,
                  child: CustomPaint(
                    size: Size(size.width, size.height * 0.4),
                    painter: RoadPainter(
                      progress: _backgroundAnimation.value,
                      primaryColor: widget.primaryColor,
                    ),
                  ),
                ),
              ),

              // Moving car with trail effect
              Positioned(
                bottom: size.height * 0.22,
                left: size.width * (0.5 + _carAnimation.value),
                child: Transform.scale(
                  scale: 1.0 - (_carAnimation.value * 0.2).abs(),
                  child: Transform.rotate(
                    angle: _carAnimation.value * 0.05,
                    child: _buildCar(size),
                  ),
                ),
              ),

              // Motion lines and particles
              if (_carAnimation.value > -1.0)
                _buildParticles(size),

              // Logo reveal with pop effect
              Center(
                child: Transform.scale(
                  scale: _logoAnimation.value,
                  child: Opacity(
                  opacity: _logoAnimation.value.clamp(0.0, 1.0),
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                            color: widget.secondaryColor.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          widget.logoPath,
                          width: 150,
                          height: 150,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.error,
                              size: 150,
                              color: Colors.red,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Company name with fade-in and slide-up effect
              Positioned(
                bottom: size.height * 0.12,
                left: 0,
                right: 0,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - _textAnimation.value)),
                  child: Opacity(
                    opacity: _textAnimation.value.clamp(0.0, 1.0),
                    child: Center(
                      child: Text(
                        widget.companyName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Animated loading indicator
              Positioned(
                bottom: size.height * 0.06,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: _textAnimation.value.clamp(0.0, 1.0),
                  child: Center(
                    child: SizedBox(
                      width: size.width * 0.4,
                      child: const LinearProgressIndicator(
                        value: null, // Indeterminate progress
                        backgroundColor: Colors.white30,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCar(Size size) {
    return SizedBox(
      width: 120,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Car body
          Container(
            width: 100,
            height: 30,
            decoration: BoxDecoration(
              color: widget.secondaryColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 0, 0, 0),
                  offset: Offset(0, 4),
                  blurRadius: 5,
                ),
              ],
            ),
          ),

          // Car top/cabin
          Positioned(
            top: 0,
            left: 30,
            right: 20,
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: widget.secondaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
          ),

          // Windows
          Positioned(
            top: 5,
            left: 35,
            right: 25,
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // Front light
          Positioned(
            top: 15,
            right: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.yellowAccent,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellowAccent.withOpacity(0.8),
                    blurRadius: _carAnimation.value < -0.5 ? 15 : 5,
                    spreadRadius: _carAnimation.value < -0.5 ? 3 : 1,
                  ),
                ],
              ),
            ),
          ),

          // Back light
          Positioned(
            top: 15,
            left: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          // Wheels
          Positioned(
            bottom: 0,
            left: 15,
            child: _buildWheel(),
          ),
          Positioned(
            bottom: 0,
            right: 15,
            child: _buildWheel(),
          ),
        ],
      ),
    );
  }

  Widget _buildWheel() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.black87,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildParticles(Size size) {
    List<Widget> particles = [];

    // Calculate how many particles to show based on animation progress
    int particleCount = (_carAnimation.value < -0.7)
        ? 5
        : (_carAnimation.value < -0.3)
        ? 4
        : 2;

    // Base opacity based on car animation
    double baseOpacity = (_carAnimation.value < -0.5) ? 0.8 : 0.5;

    for (int i = 0; i < particleCount; i++) {
      double offset = (i + 1) * 15.0;
      double particleSize = 6.0 - (i * 0.5);

      // Step 1: Calculate initial opacity with a smaller decrement to avoid negatives
      double opacity = baseOpacity - (i * 0.05);
      opacity = opacity.clamp(0.2, 1.0);

      // Step 2: Apply particle controller animation
      double multiplier = 0.5 + (_particleController.value * 0.5);
      multiplier = multiplier.clamp(0.5, 1.0);
      opacity *= multiplier;

      // Step 3: Final clamp to ensure opacity is between 0.0 and 1.0
      opacity = opacity.clamp(0.0, 1.0);

      particles.add(
        Positioned(
          bottom: size.height * 0.22 + 15 + (i % 3) * 2,
          left: size.width * (0.5 + _carAnimation.value) - offset - 10,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: particleSize,
              height: particleSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 1,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Stack(children: particles);
  }
}

class RoadPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;

  RoadPainter({required this.progress, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint roadPaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.fill;

    final Paint linePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Draw the main road
    Path roadPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.7, size.height * 0.1)
      ..lineTo(size.width * 0.3, size.height * 0.1)
      ..close();

    canvas.drawPath(roadPath, roadPaint);

    // Draw the center line with animation effect
    for (int i = 0; i < 8; i++) {
      double yProgress = i / 7;
      double animatedY = yProgress + ((1 - progress) * 0.14) % 1.0;

      if (animatedY > 1.0) animatedY -= 1.0;

      double startX = size.width * 0.3 + (size.width * 0.4 * animatedY);
      double endX = size.width * 0.7 - (size.width * 0.4 * animatedY);
      double y = size.height - (size.height * 0.9 * animatedY);

      // Line width decreases as it gets "further" away
      linePaint.strokeWidth = 4 * (1 - (0.8 * animatedY));

      // Only draw if within the viewable area
      if (y >= size.height * 0.1 && y <= size.height) {
        canvas.drawLine(
          Offset(startX, y),
          Offset(endX, y),
          linePaint,
        );
      }
    }

    // Draw edge highlights
    final Paint edgePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Path leftEdgePath = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.3, size.height * 0.1);

    Path rightEdgePath = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width * 0.7, size.height * 0.1);

    canvas.drawPath(leftEdgePath, edgePaint);
    canvas.drawPath(rightEdgePath, edgePaint);
  }

  @override
  bool shouldRepaint(covariant RoadPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}