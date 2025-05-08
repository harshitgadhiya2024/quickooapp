import 'package:flutter/material.dart';
import '../Controller/ride_controller.dart';

class RideDetailScreen extends StatelessWidget {
  final Ride ride;

  const RideDetailScreen({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.shade300,
                  Colors.grey.shade500
                  // Colors.indigo.shade800,
                  // Colors.indigo.shade600,
                ],
              ),
            ),
          ),

          // Curved background shape
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: IconButton(
                      onPressed:()=> Navigator.pop(context),
                      icon: Icon(Icons.arrow_back,color: Colors.black,)),
                ),
                // App bar area
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       // Back button
                //       Container(
                //         decoration: BoxDecoration(
                //           color: Colors.black,
                //           shape: BoxShape.circle,
                //           boxShadow: [
                //             BoxShadow(
                //               color: Colors.black.withOpacity(0.1),
                //               blurRadius: 8,
                //               spreadRadius: 1,
                //             ),
                //           ],
                //         ),
                //         child: IconButton(
                //           icon: const Icon(Icons.arrow_back, color: Colors.white),
                //           onPressed: () => Navigator.pop(context),
                //         ),
                //       ),
                //
                //       // Options button
                //
                //     ],
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.route,
                              color: Colors.indigo,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Ride Details",
                            style: TextStyle(
                              color: Colors.indigo.shade700,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        '${ride.fromLocation}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_downward,
                            color: Colors.indigo.shade400,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${ride.toLocation}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
                // Rest of the content
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // Route header
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Row(
                      //         children: [
                      //           Container(
                      //             padding: EdgeInsets.all(8),
                      //             decoration: BoxDecoration(
                      //               color: Colors.indigo.shade100,
                      //               borderRadius: BorderRadius.circular(12),
                      //             ),
                      //             child: Icon(
                      //               Icons.route,
                      //               color: Colors.indigo,
                      //               size: 24,
                      //             ),
                      //           ),
                      //           SizedBox(width: 12),
                      //           Text(
                      //             "Ride Details",
                      //             style: TextStyle(
                      //               color: Colors.indigo.shade700,
                      //               fontSize: 14,
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       SizedBox(height: 16),
                      //       Text(
                      //         '${ride.fromLocation}',
                      //         style: TextStyle(
                      //           fontSize: 22,
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.black87,
                      //         ),
                      //       ),
                      //       SizedBox(height: 8),
                      //       Row(
                      //         children: [
                      //           Icon(
                      //             Icons.arrow_downward,
                      //             color: Colors.indigo.shade400,
                      //             size: 18,
                      //           ),
                      //           SizedBox(width: 8),
                      //           Expanded(
                      //             child: Container(
                      //               height: 1,
                      //               color: Colors.grey.shade300,
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       SizedBox(height: 8),
                      //       Text(
                      //         '${ride.toLocation}',
                      //         style: TextStyle(
                      //           fontSize: 22,
                      //           fontWeight: FontWeight.bold,
                      //           color: Colors.black87,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // Journey details
                      Padding(
                        padding: const EdgeInsets.only(left: 16,right: 16,bottom: 16,top: 23),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.black,
                                  Colors.black87
                                ],
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Journey Information",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoCard(
                                        icon: Icons.calendar_today,
                                        title: "Date",
                                        value: ride.startDate.split('T')[0],
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: _buildInfoCard(
                                        icon: Icons.access_time,
                                        title: "Time",
                                        value: ride.startTime,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoCard(
                                        icon: Icons.group,
                                        title: "Persons",
                                        value: ride.persons.toString(),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: _buildInfoCard(
                                        icon: Icons.repeat,
                                        title: "Daily",
                                        value: ride.isDaily ? "Yes" : "No",
                                      ),
                                    ),
                                  ],
                                ),
                                if (ride.days.isNotEmpty) ...[
                                  SizedBox(height: 16),
                                  _buildInfoCard(
                                    icon: Icons.date_range,
                                    title: "Days",
                                    value: ride.days.join(', '),
                                    fullWidth: true,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Route cities
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Card(
                          color: Colors.black,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.location_on,
                                        color: Colors.amber.shade800,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      "Route Cities",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                _buildRouteTimeline(context, ride.cities),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Status card
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: ride.isCompleted ? Colors.green.shade50 : Colors.black,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: ride.isCompleted ? Colors.green.shade200 : Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: ride.isCompleted ? Colors.green.shade100 : Colors.red.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    ride.isCompleted ? Icons.check_circle : Icons.info,
                                    color: ride.isCompleted ? Colors.green : Colors.red,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Status",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      ride.isCompleted ? "Completed" : "Pending",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: ride.isCompleted ? Colors.green.shade700 : Colors.red.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Container(
      //   padding: EdgeInsets.all(16),
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.05),
      //         blurRadius: 10,
      //         spreadRadius: 0,
      //         offset: Offset(0, -5),
      //       ),
      //     ],
      //   ),
      //   child: ElevatedButton(
      //     onPressed: () {
      //       // Implement action
      //     },
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: Colors.indigo.shade600,
      //       foregroundColor: Colors.white,
      //       padding: EdgeInsets.symmetric(vertical: 16),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(16),
      //       ),
      //       elevation: 0,
      //     ),
      //     child: Text(
      //       ride.isCompleted ? "View Details" : "Track Ride",
      //       style: TextStyle(
      //         fontSize: 16,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    bool fullWidth = false,
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: fullWidth ? 14 : 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRouteTimeline(BuildContext context, List<String> cities) {
    return Column(
      children: List.generate(cities.length, (index) {
        final isFirst = index == 0;
        final isLast = index == cities.length - 1;
        final city = cities[index].toLowerCase();

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isFirst ? Colors.indigo : (isLast ? Colors.amber.shade700 : Colors.grey.shade400),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: Colors.grey.shade300,
                  ),
              ],
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isFirst || isLast ? FontWeight.bold : FontWeight.w500,
                      color: Colors.white
                    ),
                  ),
                  if (!isLast) SizedBox(height: 24),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}