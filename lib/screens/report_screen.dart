// lib/screens/report_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../utils/constants.dart';

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    // Generate data for charts
    Map<String, int> tasksPerDay = _getTasksCompletedPerDay(tasks);
    Map<String, double> timeSpentPerDay = _getTimeSpentPerDay(tasks);
    Map<TaskPriority, int> tasksPerPriority = _getTasksPerPriority(tasks);

    return Scaffold(
      appBar: AppBar(title: Text('Reports')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Tasks Completed Per Day Chart
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Tasks Completed Over Last 7 Days',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildTasksPerDayChart(tasksPerDay),
            // Time Spent Per Day Chart
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Time Spent on Tasks (Hours)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildTimeSpentPerDayChart(timeSpentPerDay),
            // Tasks by Priority Pie Chart
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Tasks by Priority',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _buildTasksPerPriorityChart(tasksPerPriority),
          ],
        ),
      ),
    );
  }

  // Helper methods to generate data
  Map<String, int> _getTasksCompletedPerDay(List<Task> tasks) {
    Map<String, int> tasksPerDay = {};
    DateTime today = DateTime.now();

    // Initialize the map with the last 7 days
    for (int i = 6; i >= 0; i--) {
      DateTime day = today.subtract(Duration(days: i));
      String dayStr = "${day.month}/${day.day}";
      tasksPerDay[dayStr] = 0;
    }

    // Count tasks completed on each day
    for (Task task in tasks) {
      if (task.isCompleted && task.completedDate != null) {
        String dayStr = "${task.completedDate!.month}/${task.completedDate!.day}";
        if (tasksPerDay.containsKey(dayStr)) {
          tasksPerDay[dayStr] = tasksPerDay[dayStr]! + 1;
        }
      }
    }
    return tasksPerDay;
  }

  Map<String, double> _getTimeSpentPerDay(List<Task> tasks) {
    Map<String, double> timeSpentPerDay = {};
    DateTime today = DateTime.now();

    // Initialize the map with the last 7 days
    for (int i = 6; i >= 0; i--) {
      DateTime day = today.subtract(Duration(days: i));
      String dayStr = "${day.month}/${day.day}";
      timeSpentPerDay[dayStr] = 0.0;
    }

    // Sum time spent on tasks for each day
    for (Task task in tasks) {
      if (task.completedDate != null) {
        String dayStr = "${task.completedDate!.month}/${task.completedDate!.day}";
        if (timeSpentPerDay.containsKey(dayStr)) {
          timeSpentPerDay[dayStr] =
              timeSpentPerDay[dayStr]! + task.timeSpent.inHours.toDouble();
        }
      }
    }
    return timeSpentPerDay;
  }

  Map<TaskPriority, int> _getTasksPerPriority(List<Task> tasks) {
    Map<TaskPriority, int> tasksPerPriority = {};
    for (var priority in TaskPriority.values) {
      tasksPerPriority[priority] = 0;
    }

    for (Task task in tasks) {
      tasksPerPriority[task.priority] = tasksPerPriority[task.priority]! + 1;
    }
    return tasksPerPriority;
  }

  // Chart widgets
  Widget _buildTasksPerDayChart(Map<String, int> data) {
    List<BarChartGroupData> barGroups = [];
    int i = 0;
    data.forEach((day, count) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: Colors.deepPurple,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
      i++;
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 250,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: (data.values.isNotEmpty)
                ? (data.values.reduce((a, b) => a > b ? a : b)).toDouble() + 1
                : 10,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 30),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < data.keys.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          data.keys.elementAt(index),
                          style: TextStyle(fontSize: 10),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            barGroups: barGroups,
            gridData: FlGridData(show: false),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSpentPerDayChart(Map<String, double> data) {
    List<FlSpot> spots = [];
    int i = 0;
    data.forEach((day, hours) {
      spots.add(FlSpot(i.toDouble(), hours));
      i++;
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 250,
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: (data.values.isNotEmpty)
                ? (data.values.reduce((a, b) => a > b ? a : b)) + 1
                : 10,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true, reservedSize: 30),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < data.keys.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          data.keys.elementAt(index),
                          style: TextStyle(fontSize: 10),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: true, horizontalInterval: 1),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.deepPurple,
                barWidth: 3,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasksPerPriorityChart(Map<TaskPriority, int> data) {
    List<PieChartSectionData> sections = [];
    int total = data.values.fold(0, (sum, item) => sum + item);
    if (total == 0) total = 1; // Prevent division by zero

    data.forEach((priority, count) {
      final double percentage = (count / total) * 100;
      sections.add(
        PieChartSectionData(
          color: priorityColor(priority),
          value: percentage,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 250,
        child: PieChart(
          PieChartData(
            sections: sections,
            centerSpaceRadius: 40,
            sectionsSpace: 2,
            borderData: FlBorderData(show: false),
            pieTouchData: PieTouchData(enabled: false),
          ),
        ),
      ),
    );
  }
}