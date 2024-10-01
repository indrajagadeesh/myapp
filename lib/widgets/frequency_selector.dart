// lib/widgets/frequency_selector.dart

import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../utils/constants.dart';

class FrequencySelector extends StatelessWidget {
  final Frequency? frequency;
  final Function(Frequency?) onChanged;

  const FrequencySelector({
    required this.frequency,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Frequency>(
      value: frequency,
      decoration: const InputDecoration(labelText: 'Frequency'),
      items: Frequency.values.map((Frequency freq) {
        return DropdownMenuItem<Frequency>(
          value: freq,
          child: Text(frequencyNames[freq]!),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select a frequency';
        }
        return null;
      },
    );
  }
}
