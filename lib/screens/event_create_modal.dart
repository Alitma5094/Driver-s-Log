import 'package:drivers_log/models/database_handler.dart';
import 'package:drivers_log/models/driving_event.dart';
import 'package:drivers_log/widgets/datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewEventModal extends StatefulWidget {
  const NewEventModal(
      {super.key, required this.startTime, required this.endTime});

  final DateTime startTime;
  final DateTime endTime;

  @override
  State<NewEventModal> createState() => _NewEventModalState();
}

class _NewEventModalState extends State<NewEventModal> {
  final _notesController = TextEditingController();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  DriveTimeOfDay _selectedTimeOfDay = DriveTimeOfDay.day;

  void _onSavePressed() {
    if (_selectedStartDate == null || _selectedEndDate == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Please double check your input.'),
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
      return;
    }
    if (_selectedStartDate!.compareTo(_selectedEndDate!) != -1) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Your start time must be before your end time.'),
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
      return;
    }

    DatabaseHandler().insertDrivingEvent(
      DrivingEvent(
        startDate: _selectedStartDate!,
        endDate: _selectedEndDate!,
        timeOfDay: _selectedTimeOfDay,
        notes: _notesController.text,
      ),
    );
    Navigator.pop(context);
    setState(() {});
  }

  void _onStartDatePressed() async {
    final pickedDate = await showDateTimePicker(
        context: context,
        initialDate: DateTime.now(),
        lastDate: DateTime.now().subtract(const Duration(seconds: 1)));
    setState(() {
      _selectedStartDate = pickedDate;
    });
  }

  void _onEndDatePressed() async {
    final pickedDate = await showDateTimePicker(
        context: context,
        initialDate: DateTime.now(),
        lastDate: DateTime.now());
    setState(() {
      _selectedEndDate = pickedDate;
    });
  }

  @override
  void initState() {
    _selectedStartDate = widget.startTime;
    _selectedEndDate = widget.endTime;
    super.initState();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              'Save drive',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          InkWell(
            onTap: _onStartDatePressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  const Icon(Icons.flag),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    _selectedStartDate != null
                        ? DateFormat.MEd().add_jm().format(_selectedStartDate!)
                        : 'No start time selected',
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          InkWell(
            onTap: _onEndDatePressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  const Icon(Icons.sports_score),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    _selectedEndDate != null
                        ? DateFormat.MEd().add_jm().format(_selectedEndDate!)
                        : 'No end time selected',
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: TextField(
              controller: _notesController,
              keyboardType: TextInputType.multiline,
              maxLength: 250,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                label: Text('Notes'),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DropdownButton(
                value: _selectedTimeOfDay,
                items: DriveTimeOfDay.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          category.name.toUpperCase(),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedTimeOfDay = value;
                  });
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _onSavePressed,
                child: const Text('Save'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
