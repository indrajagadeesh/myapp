// lib/main.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/task.dart';
import 'models/subtask.dart';
import 'models/folder.dart';
import 'models/user_settings.dart';
import 'providers/task_provider.dart';
import 'providers/folder_provider.dart';
import 'providers/user_settings_provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/add_task_screen.dart';
import 'screens/task_detail_screen.dart';
import 'screens/home_screen.dart';
import 'screens/folder_screen.dart';
import 'screens/report_screen.dart';
import 'screens/initial_setup_screen.dart';
import 'utils/notification_service.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Register TypeAdapters with checks
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
  if (!Hive.isAdapterRegistered(UserSettingsAdapter().typeId)) {
    Hive.registerAdapter(UserSettingsAdapter());
  }
  if (!Hive.isAdapterRegistered(PartOfDayAdapter().typeId)) {
    Hive.registerAdapter(PartOfDayAdapter());
  }

  // Initialize Notifications
  await NotificationService.initialize();

  // Open Hive Boxes
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Folder>('folders');
  await Hive.openBox<Subtask>('subtasks');
  await Hive.openBox<UserSettings>('user_settings');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Removed _checkIfFirstRun method since it's now handled in WelcomeScreen

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
        ChangeNotifierProvider<UserSettingsProvider>(
          create: (_) => UserSettingsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'TaskFlow',
        theme: appTheme,
        home: const WelcomeScreen(), // Show the WelcomeScreen first
        onGenerateRoute: (settings) {
          if (settings.name == '/add-task') {
            final args = settings.arguments as Map<String, dynamic>?;
            final String? taskId = args != null ? args['taskId'] : null;
            return MaterialPageRoute(
              builder: (context) => AddTaskScreen(taskId: taskId),
            );
          }
          if (settings.name == '/task-detail') {
            final args = settings.arguments as Map<String, dynamic>;
            final String taskId = args['taskId'];
            return MaterialPageRoute(
              builder: (context) => TaskDetailScreen(taskId: taskId),
            );
          }
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(
                  builder: (context) => const HomeScreen());
            case '/folders':
              return MaterialPageRoute(
                  builder: (context) => const FolderScreen());
            case '/reports':
              return MaterialPageRoute(
                  builder: (context) => const ReportScreen());
            case '/initial-setup':
              return MaterialPageRoute(
                  builder: (context) => const InitialSetupScreen());
            default:
              return MaterialPageRoute(
                  builder: (context) => const HomeScreen());
          }
        },
      ),
    );
  }
}
