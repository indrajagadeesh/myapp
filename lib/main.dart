// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'providers/folder_provider.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';
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

  // Register Hive adapters
  Hive.registerAdapter(TaskTypeAdapter());
  Hive.registerAdapter(TaskPriorityAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(SubtaskAdapter());
  Hive.registerAdapter(FolderAdapter());

  // Initialize Notification Service
  await NotificationService.init();

  // Open Hive boxes
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Folder>('folders');

  runApp(TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskProvider>(
          create: (_) => TaskProvider(),
        ),
        ChangeNotifierProvider<FolderProvider>(
          create: (_) => FolderProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'TaskFlow',
        theme: appTheme,
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