// lib/main.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/task.dart';
import 'models/subtask.dart';
import 'models/folder.dart';
import 'providers/task_provider.dart';
import 'providers/folder_provider.dart';
import 'screens/home_screen.dart';
import 'screens/add_task_screen.dart';
import 'screens/task_detail_screen.dart';
import 'screens/folder_screen.dart';
import 'screens/report_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  
  // Registering TypeAdapters only once
  if (!Hive.isAdapterRegistered(TaskTypeAdapter().typeId)) {
    Hive.registerAdapter(TaskTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(TaskPriorityAdapter().typeId)) {
    Hive.registerAdapter(TaskPriorityAdapter());
  }
  if (!Hive.isAdapterRegistered(TaskAdapter().typeId)) {
    Hive.registerAdapter(TaskAdapter());
  }
  if (!Hive.isAdapterRegistered(FolderAdapter().typeId)) {
    Hive.registerAdapter(FolderAdapter());
  }
  if (!Hive.isAdapterRegistered(SubtaskAdapter().typeId)) {
    Hive.registerAdapter(SubtaskAdapter());
  }
  if (!Hive.isAdapterRegistered(FrequencyAdapter().typeId)) {
    Hive.registerAdapter(FrequencyAdapter());
  }
  if (!Hive.isAdapterRegistered(WeekdayAdapter().typeId)) {
    Hive.registerAdapter(WeekdayAdapter());
  }

  // Open Hive Boxes
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Folder>('folders');
  await Hive.openBox<Subtask>('subtasks');
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(),
          '/add-task': (context) => AddTaskScreen(),
          '/task-detail': (context) => TaskDetailScreen(),
          '/folders': (context) => FolderScreen(),
          '/reports': (context) => ReportScreen(),
        },
      ),
    );
  }
}