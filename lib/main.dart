// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'providers/folder_provider.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart'; // Ensure this import is present
import 'models/task.dart';
import 'models/subtask.dart';
import 'models/folder.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'utils/notification_service.dart';
import 'screens/add_task_screen.dart';
import 'screens/report_screen.dart';
import 'screens/folder_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TaskTypeAdapter());
  Hive.registerAdapter(TaskPriorityAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(SubtaskAdapter());
  Hive.registerAdapter(FolderAdapter());

  await NotificationService.init();

  runApp(TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskProvider>(
          create: (_) => TaskProvider()..init(),
        ),
        ChangeNotifierProvider<FolderProvider>(
          create: (_) => FolderProvider()..init(),
        ),
      ],
      child: MaterialApp(
        title: 'TaskFlow',
        theme: appTheme, // Updated to use appTheme
        home: HomeScreen(),
        routes: {
          '/add-task': (context) => AddTaskScreen(),
          '/reports': (context) => ReportScreen(),
          '/folders': (context) => FolderScreen(),
        },
      ),
    );
  }
}
