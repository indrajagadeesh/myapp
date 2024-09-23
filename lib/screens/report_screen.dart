// lib/screens/report_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final List<Task> tasks = taskProvider.tasks;

    // Process data for charts
    final weeklyData = _generateWeeklyData(tasks);
    final monthlyData = _generateMonthlyData(tasks);

    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text('Weekly Report', style: TextStyle(fontSize: 18)),
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BarChart(
                  BarChartData(
                    barGroups: _createBarGroups(weeklyData),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < weeklyData.length) {
                              return Text(
                                weeklyData[index].period,
                                style: TextStyle(fontSize: 10),
                              );
                            } else {
                              return Text('');
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Monthly Report', style: TextStyle(fontSize: 18)),
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BarChart(
                  BarChartData(
                    barGroups: _createBarGroups(monthlyData),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < monthlyData.length) {
                              return Text(
                                monthlyData[index].period,
                                style: TextStyle(fontSize: 10),
                              );
                            } else {
                              return Text('');
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups(List<ReportData> data) {
    return data.asMap().entries.map((entry) {
      int index = entry.key;
      ReportData report = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: report.completedTasks.toDouble(),
            color: Colors.tealAccent,
          ),
        ],
      );
    }).toList();
  }

  List<ReportData> _generateWeeklyData(List<Task> tasks) {
    // Generate data for the past 6 weeks
    List<ReportData> data = [];
    DateTime now = DateTime.now();
    for (int i = 5; i >= 0; i--) {
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday + (i * 7) - 1));
      DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

      int completedTasks = tasks.where((task) {
        return task.isCompleted &&
            task.scheduledTime != null &&
            task.scheduledTime!.isAfter(startOfWeek) &&
            task.scheduledTime!.isBefore(endOfWeek);
      }).length;

      data.add(ReportData(
        period: 'Week ${6 - i}',
        completedTasks: completedTasks,
      ));
    }
    return data;
  }

  List<ReportData> _generateMonthlyData(List<Task> tasks) {
    // Generate data for the past 6 months
    List<ReportData> data = [];
    DateTime now = DateTime.now();
    for (int i = 5; i >= 0; i--) {
      int year = now.year;
      int month = now.month - i;
      if (month <= 0) {
        month += 12;
        year -= 1;
      }
      DateTime startOfMonth = DateTime(year, month, 1);
      DateTime endOfMonth = DateTime(year, month + 1, 0);

      int completedTasks = tasks.where((task) {
        return task.isCompleted &&
            task.scheduledTime != null &&
            task.scheduledTime!.isAfter(startOfMonth.subtract(Duration(seconds: 1))) &&
            task.scheduledTime!.isBefore(endOfMonth.add(Duration(days: 1)));
      }).length;

      data.add(ReportData(
        period: '${startOfMonth.month}/${startOfMonth.year}',
        completedTasks: completedTasks,
      ));
    }
    return data;
  }
}

class ReportData {
  final String period;
  final int completedTasks;

  ReportData({required this.period, required this.completedTasks});
}