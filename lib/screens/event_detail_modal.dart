import 'package:drivers_log/models/database_handler.dart';
import 'package:drivers_log/models/driving_event.dart';
import 'package:flutter/material.dart';

class EventDetailModal extends StatefulWidget {
  const EventDetailModal(
      {super.key, required this.event, required this.onDelete});

  final DrivingEvent event;
  final Function() onDelete;

  @override
  State<EventDetailModal> createState() => _EventDetailModalState();
}

class _EventDetailModalState extends State<EventDetailModal> {
  void _onDeletePressed() async {
    DatabaseHandler().deleteDrivingEvent(widget.event.id);
    Navigator.pop(context);
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    final driveDuration =
        widget.event.endDate.difference(widget.event.startDate);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          Text(
            'Drive Details',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        Text(
                            '${driveDuration.inHours}hrs ${driveDuration.inMinutes.remainder(60)}mins'),
                        const Text('Total Drive Time'),
                      ]),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(children: [
                        Text(widget.event.timeOfDay.name),
                        const Text('Time of Day'),
                      ]),
                    ),
                  ),
                )
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            // TODO: Fix notes display logic
            child: Text(widget.event.notes.isEmpty
                ? widget.event.notes
                : 'No driving notes...'),
          ),
          const Divider(),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Edit Drive'),
          ),
          const SizedBox(
            height: 6,
          ),
          ElevatedButton(
            onPressed: _onDeletePressed,
            child: const Text('Delete Drive'),
          ),
        ],
      ),
    );
  }
}
