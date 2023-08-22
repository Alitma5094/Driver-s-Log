import 'package:drivers_log/models/database_handler.dart';
import 'package:drivers_log/screens/event_list_screen.dart';
import 'package:drivers_log/screens/event_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:drivers_log/quiz.dart';
import 'package:drivers_log/screens/log_screen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentPageIndex == 0
            ? const Text('Drivers Log')
            : const Text('Law Test'),
      ),
      drawer: _currentPageIndex == 0
          ? NavigationDrawer(
              onDestinationSelected: (int screenNum) async {
                Navigator.of(context).pop();
                switch (screenNum) {
                  case 0:
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        maintainState: false,
                        builder: (context) => const NewEventScreen(),
                      ),
                    );
                    setState(() {});
                  case 1:
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        maintainState: false,
                        builder: (context) => const ListEventsScreen(),
                      ),
                    );
                    setState(() {});
                  case 2:
                    break;
                  case 3:
                    break;
                  case 4:
                    showAboutDialog(
                      context: context,
                      applicationName: 'Driver\'s Log',
                      applicationVersion: '1.23.4',
                      applicationLegalese: 'Copyright (c) 2023 Andrew Litman',
                    );
                  default:
                    break;
                }
              },
              selectedIndex: null,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
                  child: Text(
                    'Options',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const NavigationDrawerDestination(
                  icon: Icon(Icons.add_circle),
                  label: Text('Log Previous Drive'),
                ),
                const NavigationDrawerDestination(
                  icon: Icon(Icons.assessment),
                  label: Text('View Driving Log'),
                ),
                const NavigationDrawerDestination(
                  icon: Icon(Icons.book),
                  label: Text('New Driver Resources'),
                ),
                const NavigationDrawerDestination(
                  icon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
                const NavigationDrawerDestination(
                  icon: Icon(Icons.info),
                  label: Text('About'),
                ),
              ],
            )
          : null,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(
              Icons.import_contacts,
            ),
            label: 'Drive Log',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.rocket_launch,
            ),
            label: 'Law Test',
          ),
        ],
      ),
      body: <Widget>[
        LogScreen(
          eventsFuture: DatabaseHandler().fetchDrivingEvents(),
        ),
        const Quiz(),
      ][_currentPageIndex],
    );
  }
}
