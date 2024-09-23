import 'package:flutter/material.dart';
import '../models/task.dart';

class StopwatchWidget extends StatefulWidget {
  final Task task;

  StopwatchWidget({required this.task});

  @override
  _StopwatchWidgetState createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  Stopwatch _stopwatch = Stopwatch();
  late Task task;
  late Duration duration;

  @override
  void initState() {
    super.initState();
    task = widget.task;
    duration = task.timeSpent;
  }

  void _startStopwatch() {
    setState(() {
      _stopwatch.start();
    });
  }

  void _stopStopwatch() {
    setState(() {
      _stopwatch.stop();
      duration += _stopwatch.elapsed;
      task.timeSpent = duration;
      _stopwatch.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Time Spent: ${duration.inSeconds}s'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _stopwatch.isRunning ? null : _startStopwatch,
              child: Text('Start'),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: _stopwatch.isRunning ? _stopStopwatch : null,
              child: Text('Stop'),
            ),
          ],
        ),
      ],
    );
  }
}