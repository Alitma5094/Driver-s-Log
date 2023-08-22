import 'package:drivers_log/models/database_handler.dart';
import 'package:drivers_log/models/driving_event.dart';
import 'package:drivers_log/screens/event_detail_modal.dart';
import 'package:flutter/material.dart';

class ListEventsScreen extends StatefulWidget {
  const ListEventsScreen({super.key});

  @override
  State<ListEventsScreen> createState() => _ListEventsScreenState();
}

class _ListEventsScreenState extends State<ListEventsScreen> {
  late DatabaseHandler _handler;

  @override
  void initState() {
    _handler = DatabaseHandler();
    super.initState();
  }

  void _onEventDelete() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drive Log'),
      ),
      body: FutureBuilder(
        future: _handler.fetchDrivingEvents(),
        builder:
            (BuildContext context, AsyncSnapshot<List<DrivingEvent>> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.isEmpty
                ? const Center(child: Text('No previous drives recorded'))
                : ListView.separated(
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      final driveDuration = snapshot.data![index].endDate
                          .difference(snapshot.data![index].startDate);
                      return ListTile(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          useSafeArea: true,
                          builder: (context) => EventDetailModal(
                              event: snapshot.data![index],
                              onDelete: _onEventDelete),
                        ),
                        leading: const Icon(Icons.drive_eta),
                        title: Text(
                          snapshot.data![index].startDate.toString(),
                        ),
                        subtitle: Text(
                          '${snapshot.data![index].timeOfDay.name.replaceFirst(snapshot.data![index].timeOfDay.name[0], snapshot.data![index].timeOfDay.name[0].toUpperCase())} • ${driveDuration.inHours}hrs ${driveDuration.inMinutes.remainder(60)}mins',
                        ),
                      );
                    },
                  );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
