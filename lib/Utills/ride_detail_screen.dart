import 'package:flutter/material.dart';
import '../Controller/ride_controller.dart';

class RideDetailScreen extends StatelessWidget {
  final Ride ride;

  const RideDetailScreen({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [

            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Ride Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '${ride.fromLocation} → ${ride.toLocation}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Ride Detail Container
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      // color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(

                        color: Colors.black.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          icon: Icons.calendar_today,
                          label: 'Date',
                          value: ride.startDate.split('T')[0],
                        ),
                        _buildDetailRow(
                          icon: Icons.access_time,
                          label: 'Time',
                          value: ride.startTime,
                        ),
                        _buildDetailRow(
                          icon: Icons.group,
                          label: 'Persons',
                          value: ride.persons.toString(),
                        ),
                        _buildDetailRow(
                          icon: Icons.repeat,
                          label: 'Daily',
                          value: ride.isDaily ? 'Yes' : 'No',
                        ),
                        if (ride.days.isNotEmpty)
                          _buildDetailRow(
                            icon: Icons.date_range,
                            label: 'Days',
                            value: ride.days.join(', '),
                          ),
                        const SizedBox(height: 24),
                        const Text(
                          'Route Cities',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ride.cities.map((city) => city.toLowerCase()).join(' → '),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          icon: Icons.info,
                          label: 'Status',
                          value: ride.isCompleted ? 'Completed' : 'Pending',
                          valueColor: ride.isCompleted
                              ? Colors.greenAccent
                              : Colors.redAccent,
                        ),
                        const SizedBox(height: 8)
        ]
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: valueColor ?? Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
