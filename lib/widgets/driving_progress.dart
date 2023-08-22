import 'package:drivers_log/models/driving_event.dart';
import 'package:flutter/material.dart';

class DrivingProgress extends StatelessWidget {
  const DrivingProgress({super.key, required this.drivingEvents});

  final List<DrivingEvent> drivingEvents;

  @override
  Widget build(BuildContext context) {
    int totalHours = 0;
    int totalMinutes = 0;

    int totalNightHours = 0;
    int totalNightMinuets = 0;

    for (var event in drivingEvents) {
      final driveDuration = event.endDate.difference(event.startDate);

      totalHours += driveDuration.inHours;
      totalMinutes += driveDuration.inMinutes.remainder(60);

      totalHours += totalMinutes ~/ 60;
      totalMinutes = totalMinutes % 60;

      if (event.timeOfDay == DriveTimeOfDay.night) {
        totalNightHours += driveDuration.inHours;
        totalNightMinuets += driveDuration.inMinutes.remainder(60);

        totalNightHours += totalNightMinuets ~/ 60;
        totalNightMinuets = totalNightMinuets % 60;
      }
    }

    double totalProgress = ((totalHours * 60 + totalMinutes) / 3600) *
        100; // Assuming 60 hours total
    double totalNightProgress =
        ((totalNightHours * 60 + totalNightMinuets) / 600) *
            100; // Assuming 10 hours at night

    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.drive_eta,
                  ),
                  const Text(
                    'Total Time',
                  ),
                  Text('${totalHours}hrs ${totalMinutes}mins / 60hrs'),
                  CircularProgressIndicator(
                    value: totalProgress / 100,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.nightlight,
                  ),
                  const Text(
                    'Night Driving',
                  ),
                  Text(
                      '${totalNightHours}hrs ${totalNightMinuets}mins / 10hrs'),
                  CircularProgressIndicator(
                    value: totalNightProgress / 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
