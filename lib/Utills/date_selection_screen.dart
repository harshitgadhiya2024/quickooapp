import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickoo/Utills/time_pickup_screen.dart';

class DateSelectionScreen extends StatefulWidget {
  final String? pickupAddress;
  final String? dropoffAddress;
  final double? distance;
  final int? duration;

  const DateSelectionScreen({super.key, this.pickupAddress, this.dropoffAddress, this.distance, this.duration});

  @override
  State<DateSelectionScreen> createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  DateTime selectedDate = DateTime.now();
  final List<String> weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  // Generate dates for the next 3 months
  List<DateTime> generateDates() {
    List<DateTime> dates = [];
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 12, 0); // 3 months from now

    for (var date = startDate; date.isBefore(endDate) || date.isAtSameMomentAs(endDate); date = date.add(const Duration(days: 1))) {
      dates.add(date);
    }
    return dates;
  }

  Map<String, List<List<DateTime?>>> getCalendarData() {
    Map<String, List<List<DateTime?>>> calendarData = {};
    final dates = generateDates();

    String currentMonth = '';
    List<List<DateTime?>> currentMonthDates = [];
    List<DateTime?> currentWeek = [];

    // Find the first day of the first month and add nulls for days before it
    final firstDate = dates.first;
    final firstDayOfWeek = firstDate.weekday % 7; // 0 is Sunday
    for (int i = 0; i < firstDayOfWeek; i++) {
      currentWeek.add(null);
    }

    for (var date in dates) {
      final month = months[date.month - 1] + ' ' + date.year.toString();

      // If we're starting a new month
      if (month != currentMonth) {
        // Save the previous month's data if it exists
        if (currentMonth.isNotEmpty) {
          // Add the last week if it's not empty
          if (currentWeek.isNotEmpty) {
            // Fill the rest of the week with nulls
            while (currentWeek.length < 7) {
              currentWeek.add(null);
            }
            currentMonthDates.add(List.from(currentWeek));
          }
          calendarData[currentMonth] = List.from(currentMonthDates);
        }

        // Start a new month
        currentMonth = month;
        currentMonthDates = [];
        currentWeek = [];

        // Add nulls for days before the start of the month
        final firstDayOfMonth = date.weekday % 7; // 0 is Sunday
        for (int i = 0; i < firstDayOfMonth; i++) {
          currentWeek.add(null);
        }
      }

      // Add the date to the current week
      currentWeek.add(date);

      // If we've reached the end of a week, start a new one
      if (currentWeek.length == 7) {
        currentMonthDates.add(List.from(currentWeek));
        currentWeek = [];
      }
    }

    // Add any remaining dates
    if (currentWeek.isNotEmpty) {
      // Fill the rest of the week with nulls
      while (currentWeek.length < 7) {
        currentWeek.add(null);
      }
      currentMonthDates.add(currentWeek);
    }

    // Add the last month
    if (currentMonth.isNotEmpty) {
      calendarData[currentMonth] = currentMonthDates;
    }

    return calendarData;
  }

  @override
  Widget build(BuildContext context) {
    final calendarData = getCalendarData();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 15),
          Text(
            "When are you going?",
            style: TextStyle(color: Color(0xFF104E5B), fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: weekdays.map((day) =>
                Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        color: Color(0xFF104E5B),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
            ).toList(),
          ),

          const SizedBox(height: 20),

          // Calendar months
          ...calendarData.entries.map((entry) {
            final monthName = entry.key.split(' ')[0]; // Extract just the month name
            final monthDates = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16,left: 10),
                  child: Text(
                    monthName,
                    style: TextStyle(
                      color: Color(0xFF104E5B),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Calendar grid
                ...monthDates.map((week) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: week.map((date) {
                      if (date == null) {
                        return Expanded(child: Container());
                      }

                      final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));
                      final isSelected = date.day == selectedDate.day &&
                          date.month == selectedDate.month &&
                          date.year == selectedDate.year;

                      return Expanded(
                        child: GestureDetector(
                          onTap: isPast ? null : () {
                            setState(() {
                              selectedDate = date;
                            });

                            // Navigate to time selection screen after a short delay
                            Future.delayed(const Duration(milliseconds: 300), () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TimePickupScreen(),
                                ),
                              );
                            });
                          },
                          child: Container(
                            height: 40,
                            margin: const EdgeInsets.all(4),
                            decoration: isSelected ? BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ) : null,
                            child: Center(
                              child: Text(
                                '${date.day}',
                                style: TextStyle(
                                  color: isPast
                                      ? Colors.grey.withOpacity(0.5)
                                      : isSelected ? Colors.white : Colors.black,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ),),
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),

                const SizedBox(height: 20),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}