import 'package:flutter/material.dart';
import '../Controller/ride_controller.dart';
import 'app_color.dart';
import 'ride_detail_screen.dart';

class YourRideScreen extends StatefulWidget {
  const YourRideScreen({super.key});

  @override
  State<YourRideScreen> createState() => _YourRideScreenState();
}

class _YourRideScreenState extends State<YourRideScreen> {
  final PastRidesController _controller = PastRidesController();

  @override
  void initState() {
    super.initState();
    _controller.fetchPastRides().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Your Rides',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 26,
            color: Colors.black,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _controller.isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.black,
          strokeWidth: 3,
        ),
      )
          : _controller.errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 12),
            Text(
              _controller.errorMessage!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  _controller.fetchPastRides().then((_) {
                    if (mounted) setState(() {});
                  });
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColor.bottomcurveColor,
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          : _controller.rides.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.directions_car_rounded,
              size: 60,
              color: Colors.white38,
            ),
            const SizedBox(height: 12),
            Text(
              'No Rides Found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        itemCount: _controller.rides.length,
        itemBuilder: (context, index) {
          final ride = _controller.rides[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RideDetailScreen(ride: ride),
                ),
              );
            },
            child: Hero(
              tag: 'ride_${ride.rideId}',
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                           color: Colors.black
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.bottomcurveColor,
                              ),
                              child: Icon(
                                ride.isCompleted
                                    ? Icons.check_circle
                                    : Icons.pending,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${ride.fromLocation} → ${ride.toLocation}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    overflow:
                                    TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ride.startDate.split('T')[0],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColor.bottomcurveColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}