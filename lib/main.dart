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
import 'utils/notification_service.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Register TypeAdapters
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

  // Initialize Notifications
  await NotificationService.initialize();

  // Open Hive Boxes
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Folder>('folders');
  await Hive.openBox<Subtask>('subtasks');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        initialRoute: '/',
        onGenerateRoute: (settings) {
          if (settings.name == '/task-detail') {
            final args = settings.arguments as Map<String, dynamic>;
            final String taskId = args['taskId'];
            return MaterialPageRoute(
              builder: (context) {
                return TaskDetailScreen(taskId: taskId);
              },
            );
          }
          if (settings.name == '/add-task') {
            final args = settings.arguments as Map<String, dynamic>?;
            final String? taskId = args != null ? args['taskId'] : null;
            return MaterialPageRoute(
              builder: (context) => AddTaskScreen(taskId: taskId),
            );
          }
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                  builder: (context) => const HomeScreen());
            case '/folders':
              return MaterialPageRoute(
                  builder: (context) => const FolderScreen());
            case '/reports':
              return MaterialPageRoute(
                  builder: (context) => const ReportScreen());
            default:
              return MaterialPageRoute(
                  builder: (context) => const HomeScreen());
          }
        },
      ),
    );
  }
}
