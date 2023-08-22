import 'package:uuid/uuid.dart';

enum DriveTimeOfDay {
  day,
  night,
}

class DrivingEvent {
  String id = const Uuid().v4();
  final DateTime startDate;
  final DateTime endDate;
  final DriveTimeOfDay timeOfDay;
  final String notes;

  DrivingEvent({
    required this.startDate,
    required this.endDate,
    required this.timeOfDay,
    required this.notes,
  });

  DrivingEvent.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        startDate = DateTime.parse(res['startDate']),
        endDate = DateTime.parse(res['endDate']),
        timeOfDay = DriveTimeOfDay.values[res['timeOfDay']],
        notes = res['notes'];

  Map<String, Object> toMap() {
    return {
      'id': id.toString(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'timeOfDay': timeOfDay.index,
      'notes': notes,
    };
  }
}
