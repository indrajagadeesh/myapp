// lib/screens/initial_setup_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_settings_provider.dart';
import '../providers/folder_provider.dart';
import '../models/user_settings.dart';

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

  Future<void> _selectTime(BuildContext context, TimeOfDay initialTime,
      Function(TimeOfDay) onTimeSelected) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null && picked != initialTime) {
      onTimeSelected(picked);
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final userSettingsProvider =
          Provider.of<UserSettingsProvider>(context, listen: false);
      final folderProvider =
          Provider.of<FolderProvider>(context, listen: false);

      UserSettings settings = UserSettings(
        name: _name,
        wakeUpTime: _wakeUpTime,
        lunchTime: _lunchTime,
        eveningTime: _eveningTime,
        dinnerTime: _dinnerTime,
      );

      await userSettingsProvider.updateUserSettings(settings);

      // Create default folder with user's name
      await folderProvider.createDefaultFolder(_name);

      // Navigate to Home Screen
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
              // Name
              TextFormField(
                decoration: const InputDecoration(labelText: 'Your Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your name'
                    : null,
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 20),
              // Wake-up Time
              ListTile(
                title: const Text('Wake-up Time'),
                subtitle: Text(_wakeUpTime.format(context)),
                trailing: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () {
                    _selectTime(context, _wakeUpTime, (picked) {
                      setState(() {
                        _wakeUpTime = picked;
                      });
                    });
                  },
                ),
              ),
              // Lunch Time
              ListTile(
                title: const Text('Lunch Time'),
                subtitle: Text(_lunchTime.format(context)),
                trailing: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () {
                    _selectTime(context, _lunchTime, (picked) {
                      setState(() {
                        _lunchTime = picked;
                      });
                    });
                  },
                ),
              ),
              // Evening Time
              ListTile(
                title: const Text('Evening Time'),
                subtitle: Text(_eveningTime.format(context)),
                trailing: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () {
                    _selectTime(context, _eveningTime, (picked) {
                      setState(() {
                        _eveningTime = picked;
                      });
                    });
                  },
                ),
              ),
              // Dinner Time
              ListTile(
                title: const Text('Dinner Time'),
                subtitle: Text(_dinnerTime.format(context)),
                trailing: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () {
                    _selectTime(context, _dinnerTime, (picked) {
                      setState(() {
                        _dinnerTime = picked;
                      });
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Complete Setup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
