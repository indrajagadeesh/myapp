// lib/widgets/stopwatch_widget.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class StopwatchWidget extends StatefulWidget {
  final Task task;

  StopwatchWidget({required this.task});

  @override
  _StopwatchWidgetState createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Time Spent',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              _formatDuration(widget.task.timeSpent + _stopwatch.elapsed),
              style: TextStyle(fontSize: 36),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _stopwatch.isRunning ? _stopTimer : _startTimer,
                  child: Icon(
                    _stopwatch.isRunning ? Icons.pause : Icons.play_arrow,
                    size: 32,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                SizedBox(width: 24),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: Icon(
                    Icons.stop,
                    size: 32,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startTimer() {
    _stopwatch.start();
    _timer =
        Timer.periodic(Duration(seconds: 1), (timer) => setState(() {}));
  }

  void _stopTimer() {
    _stopwatch.stop();
    _timer?.cancel();
    widget.task.timeSpent += _stopwatch.elapsed;
    Provider.of<TaskProvider>(context, listen: false)
        .updateTask(widget.task);
    _stopwatch.reset();
  }

  void _resetTimer() {
    _stopwatch.reset();
    widget.task.timeSpent = Duration.zero;
    Provider.of<TaskProvider>(context, listen: false)
        .updateTask(widget.task);
    setState(() {});
  }
}