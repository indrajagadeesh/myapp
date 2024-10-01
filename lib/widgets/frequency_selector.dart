// lib/widgets/frequency_selector.dart

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/constants.dart';

class FrequencySelector extends StatefulWidget {
  final Frequency frequency;
  final Function(Frequency) onFrequencyChanged;

  const FrequencySelector(
      {required this.frequency, required this.onFrequencyChanged, Key? key})
      : super(key: key);

  @override
  _FrequencySelectorState createState() => _FrequencySelectorState();
}

class _FrequencySelectorState extends State<FrequencySelector> {
  late Frequency _selectedFrequency;

  @override
  void initState() {
    super.initState();
    _selectedFrequency = widget.frequency;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Frequency>(
      value: _selectedFrequency,
      decoration: const InputDecoration(labelText: 'Frequency'),
      items: Frequency.values.map((Frequency freq) {
        return DropdownMenuItem<Frequency>(
          value: freq,
          child: Text(frequencyText(freq)),
        );
      }).toList(),
      onChanged: (Frequency? newValue) {
        setState(() {
          _selectedFrequency = newValue ?? Frequency.Daily;
          widget.onFrequencyChanged(_selectedFrequency);
        });
      },
    );
  }
}
