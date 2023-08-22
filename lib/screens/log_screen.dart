import 'package:drivers_log/screens/event_create_modal.dart';
import 'package:drivers_log/widgets/driving_progress.dart';
import 'package:drivers_log/widgets/stopwatch.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drivers_log/models/driving_event.dart';
import 'package:drivers_log/models/database_handler.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key, required this.eventsFuture});

  final Future<List<DrivingEvent>> eventsFuture;

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  // TODO: Implement saving a backed up time
  // void _loadSavedTime() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? loadedString = prefs.getString('savedTime');
  //   print(loadedString != null ? DateTime.parse(loadedString) : null);
  // }

  void _saveTime(stopTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('savedTime', stopTime.toIso8601String());
  }

  void _saveDriveEvent(DateTime stopTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final startTime = DateTime.parse(prefs.getString('savedTime')!);

    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        isDismissible: false,
        builder: (context) => NewEventModal(
          startTime: startTime,
          endTime: stopTime,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error loading drive'),
          content: const Text(
            'Go to the "View Driving Log" screen to finish customizing your drive.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      DatabaseHandler().insertDrivingEvent(
        DrivingEvent(
          startDate: startTime,
          endDate: stopTime,
          timeOfDay: DriveTimeOfDay.day,
          notes: '',
        ),
      );
    }

    prefs.remove('savedTime');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StopWatch(
          onStopwatchStart: _saveTime,
          onStopwatchStop: _saveDriveEvent,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: FutureBuilder<List<DrivingEvent>>(
            future: widget.eventsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Error loading driving events');
              } else {
                List<DrivingEvent> drivingEvents = snapshot.data!;
                return DrivingProgress(drivingEvents: drivingEvents);
              }
            },
          ),
        ),
      ],
    );
  }
}
