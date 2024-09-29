// lib/widgets/frequency_selector.dart

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/constants.dart';

class FrequencySelector extends StatefulWidget {
  final Frequency selectedFrequency;
  final List<Weekday> selectedWeekdays;
  final Function(Frequency) onFrequencyChanged;
  final Function(List<Weekday>) onWeekdaysChanged;

  FrequencySelector({
    required this.selectedFrequency,
    required this.selectedWeekdays,
    required this.onFrequencyChanged,
    required this.onWeekdaysChanged,
  });

  @override
  _FrequencySelectorState createState() => _FrequencySelectorState();
}

class _FrequencySelectorState extends State<FrequencySelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Frequency', style: TextStyle(fontSize: 16)),
        DropdownButtonFormField<Frequency>(
          value: widget.selectedFrequency,
          items: Frequency.values.map((Frequency freq) {
            return DropdownMenuItem<Frequency>(
              value: freq,
              child: Text(frequencyText(freq)),
            );
          }).toList(),
          onChanged: (Frequency? newFreq) {
            if (newFreq != null) {
              widget.onFrequencyChanged(newFreq);
              if (newFreq != Frequency.Weekly && newFreq != Frequency.BiWeekly) {
                widget.onWeekdaysChanged([]);
              }
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Select Frequency',
          ),
        ),
        SizedBox(height: 16),
        if (widget.selectedFrequency == Frequency.Weekly ||
            widget.selectedFrequency == Frequency.BiWeekly)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Days', style: TextStyle(fontSize: 16)),
              Wrap(
                spacing: 8.0,
                children: Weekday.values.map((day) {
                  return FilterChip(
                    label: Text(weekdayText(day)),
                    selected: widget.selectedWeekdays.contains(day),
                    onSelected: (bool selected) {
                      List<Weekday> updatedWeekdays = List.from(widget.selectedWeekdays);
                      if (selected) {
                        updatedWeekdays.add(day);
                      } else {
                        updatedWeekdays.remove(day);
                      }
                      widget.onWeekdaysChanged(updatedWeekdays);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
      ],
    );
  }
}