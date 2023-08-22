import 'dart:async';

import 'package:flutter/material.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({super.key, this.onStopwatchStart, this.onStopwatchStop});

  final Function(DateTime startTime)? onStopwatchStart;
  final Function(DateTime stopTime)? onStopwatchStop;

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  final Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  String _result = '00:00:00';

  bool _isRunning = false;

  void _start() {
    _stopwatch.start();

    if (widget.onStopwatchStart != null) {
      widget.onStopwatchStart!(
        DateTime.now(),
      );
    }

    setState(() {
      _isRunning = true;
    });
  }

  void _stop() {
    _timer.cancel();
    _stopwatch.stop();

    if (widget.onStopwatchStop != null) {
      widget.onStopwatchStop!(
        DateTime.now(),
      );
    }

    setState(() {
      _result = '00:00:00';
    });

    setState(() {
      _isRunning = false;
    });
  }

  @override
  void initState() {
    // Timer.periodic() will call the callback function every 100 milliseconds
    _timer = Timer.periodic(
      const Duration(milliseconds: 30),
      (Timer t) {
        // Update the UI
        setState(
          () {
            _result =
                '${_stopwatch.elapsed.inMinutes.toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inSeconds % 60).toString().padLeft(2, '0')}:${(_stopwatch.elapsed.inMilliseconds % 100).toString().padLeft(2, '0')}';
          },
        );
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _result,
            style: const TextStyle(
              fontSize: 50.0,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          _isRunning
              ? ElevatedButton(
                  onPressed: _stop,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Stop'),
                )
              : ElevatedButton(
                  onPressed: _start,
                  child: const Text('Start'),
                ),
        ],
      ),
    );
  }
}
