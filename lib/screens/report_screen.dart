// lib/screens/report_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/constants.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key}) : super(key: key);

  Color _getColorForPriority(String priority) {
    switch (priority) {
      case 'Regular':
        return Colors.green;
      case 'Important':
        return Colors.blue;
      case 'Very Important':
        return Colors.orange;
      case 'Urgent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final List<Task> completedTasks =
        taskProvider.tasks.where((t) => t.isCompleted).toList();
    final Map<String, int> priorityCount = {};

    for (var task in completedTasks) {
      String priority = priorityText(task.priority);
      priorityCount[priority] = (priorityCount[priority] ?? 0) + 1;
    }

    List<PieChartSectionData> sections = priorityCount.entries.map((entry) {
      return PieChartSectionData(
        color: _getColorForPriority(entry.key),
        value: entry.value.toDouble(),
        title: '${entry.key}\n${entry.value}',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: completedTasks.isEmpty
          ? const Center(child: Text('No completed tasks to display.'))
          : Center(
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
    );
  }
}
