// lib/widgets/stopwatch_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Import Ticker
import 'dart:async';

class StopwatchWidget extends StatefulWidget {
  final Duration initialDuration;
  final Function(Duration) onTimeChange;

  const StopwatchWidget({
    required this.initialDuration,
    required this.onTimeChange,
    Key? key,
  }) : super(key: key);

  @override
  _StopwatchWidgetState createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget>
    with SingleTickerProviderStateMixin {
  late Duration _duration;
  late Stopwatch _stopwatch;
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _duration = widget.initialDuration;
    _stopwatch = Stopwatch();
    _ticker = createTicker(_onTick);
  }

  void _onTick(Duration elapsed) {
    if (_stopwatch.isRunning) {
      setState(() {
        _duration = widget.initialDuration + _stopwatch.elapsed;
      });
      widget.onTimeChange(_duration);
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _stopwatch.stop();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Time: ${_formatDuration(_duration)}'),
        IconButton(
          icon: Icon(_stopwatch.isRunning ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            setState(() {
              if (_stopwatch.isRunning) {
                _stopwatch.stop();
                _ticker.stop();
              } else {
                _stopwatch.start();
                _ticker.start();
              }
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          onPressed: () {
            setState(() {
              _stopwatch.reset();
              _duration = widget.initialDuration;
              _ticker.stop();
            });
            widget.onTimeChange(_duration);
          },
        ),
      ],
    );
  }
}
