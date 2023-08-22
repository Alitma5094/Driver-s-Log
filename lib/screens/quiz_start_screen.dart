import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key, required this.onStartPressed});

  final void Function(bool timed) onStartPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Lerner\'s Permit Law Quiz'),
          ElevatedButton(
            onPressed: () {
              onStartPressed(true);
            },
            child: const Text('Start Quiz (25 Minuets)'),
          ),
          ElevatedButton(
            onPressed: () {
              onStartPressed(false);
            },
            child: const Text('Start Quiz (Untimed)'),
          ),
        ],
      ),
    );
  }
}
