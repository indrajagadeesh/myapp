// lib/providers/user_settings_provider.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user_settings.dart';

class UserSettingsProvider extends ChangeNotifier {
  late Box<UserSettings> _userSettingsBox;
  UserSettings? userSettings;

  UserSettingsProvider() {
    init();
  }

  Future<void> init() async {
    _userSettingsBox = Hive.box<UserSettings>('user_settings');

    if (_userSettingsBox.isNotEmpty) {
      userSettings = _userSettingsBox.getAt(0);
    }

    notifyListeners();
  }

  Future<void> updateUserSettings(UserSettings settings) async {
    userSettings = settings;

    if (_userSettingsBox.isEmpty) {
      await _userSettingsBox.add(userSettings!);
    } else {
      await _userSettingsBox.putAt(0, userSettings!);
    }

    notifyListeners();
  }
}
