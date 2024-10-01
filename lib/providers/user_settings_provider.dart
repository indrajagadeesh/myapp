// lib/providers/user_settings_provider.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user_settings.dart';

class UserSettingsProvider extends ChangeNotifier {
  late Box<UserSettings> _userSettingsBox;
  UserSettings? userSettings;

  UserSettingsProvider() {
    _init();
  }

  Future<void> _init() async {
    _userSettingsBox = Hive.box<UserSettings>('user_settings');
    userSettings = _userSettingsBox.get('settings');
    notifyListeners();
  }

  void saveUserSettings(UserSettings settings) {
    _userSettingsBox.put('settings', settings);
    userSettings = settings;
    notifyListeners();
  }
}
