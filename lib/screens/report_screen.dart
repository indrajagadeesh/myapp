// lib/screens/report_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key}) : super(key: key);

  Widget _buildReport(List<Task> tasks) {
    // Implement your report logic here
    return const Center(child: Text('Weekly and Monthly Reports'));
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: _buildReport(taskProvider.tasks),
    );
  }
}
