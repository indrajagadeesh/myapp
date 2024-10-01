// lib/screens/initial_setup_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_settings.dart';
import '../providers/user_settings_provider.dart';

class InitialSetupScreen extends StatefulWidget {
  const InitialSetupScreen({Key? key}) : super(key: key);

  @override
  _InitialSetupScreenState createState() => _InitialSetupScreenState();
}

class _InitialSetupScreenState extends State<InitialSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  TimeOfDay _wakeUpTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _lunchTime = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _eveningTime = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay _dinnerTime = const TimeOfDay(hour: 20, minute: 0);

  Future<void> _selectTime(BuildContext context, String title,
      TimeOfDay initialTime, Function(TimeOfDay) onTimeSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: title,
    );
    if (picked != null && picked != initialTime) {
      setState(() {
        onTimeSelected(picked);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final userSettingsProvider =
          Provider.of<UserSettingsProvider>(context, listen: false);
      final now = DateTime.now();
      userSettingsProvider.saveUserSettings(
        UserSettings(
          name: _name,
          wakeUpTime: DateTime(now.year, now.month, now.day, _wakeUpTime.hour,
              _wakeUpTime.minute),
          lunchTime: DateTime(
              now.year, now.month, now.day, _lunchTime.hour, _lunchTime.minute),
          eveningTime: DateTime(now.year, now.month, now.day, _eveningTime.hour,
              _eveningTime.minute),
          dinnerTime: DateTime(now.year, now.month, now.day, _dinnerTime.hour,
              _dinnerTime.minute),
        ),
      );
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Initial Setup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Welcome! Please provide the following information:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              // Name Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Your Name'),
                onSaved: (value) => _name = value ?? '',
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Please enter your name'
                    : null,
              ),
              const SizedBox(height: 20),
              // Wake Up Time
              ListTile(
                title: Text('Wake Up Time: ${_wakeUpTime.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(
                    context, 'Select Wake Up Time', _wakeUpTime, (time) {
                  _wakeUpTime = time;
                }),
              ),
              // Lunch Time
              ListTile(
                title: Text('Lunch Time: ${_lunchTime.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(
                    context, 'Select Lunch Time', _lunchTime, (time) {
                  _lunchTime = time;
                }),
              ),
              // Evening Time
              ListTile(
                title: Text('Evening Time: ${_eveningTime.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(
                    context, 'Select Evening Time', _eveningTime, (time) {
                  _eveningTime = time;
                }),
              ),
              // Dinner Time
              ListTile(
                title: Text('Dinner Time: ${_dinnerTime.format(context)}'),
                trailing: const Icon(Icons.access_time),
                onTap: () => _selectTime(
                    context, 'Select Dinner Time', _dinnerTime, (time) {
                  _dinnerTime = time;
                }),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Finish Setup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
