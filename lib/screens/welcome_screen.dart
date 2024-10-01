// lib/screens/welcome_screen.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/user_settings.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate loading time

    bool isFirstRun = await _checkIfFirstRun();

    if (!mounted) return;

    if (isFirstRun) {
      Navigator.pushReplacementNamed(context, '/initial-setup');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<bool> _checkIfFirstRun() async {
    var box = Hive.box<UserSettings>('user_settings');
    return box.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo, // Background color for the welcome screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo or Icon
            const Icon(
              Icons.task_alt,
              size: 100.0,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            // App Name
            const Text(
              'TaskFlow',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            // Progress Indicator or Animation
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
