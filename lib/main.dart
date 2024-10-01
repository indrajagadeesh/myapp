// lib/main.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/task.dart';
import 'models/subtask.dart';
import 'models/folder.dart';
import 'models/user_settings.dart';
import 'models/enums.dart';
import 'models/time_of_day_adapter.dart';
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

  // Register TypeAdapters
  Hive.registerAdapter(TaskTypeAdapter());
  Hive.registerAdapter(TaskPriorityAdapter());
  Hive.registerAdapter(FrequencyAdapter());
  Hive.registerAdapter(PartOfDayAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(UserSettingsAdapter());
  Hive.registerAdapter(FolderAdapter());
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(SubtaskAdapter());

  // Open Hive Boxes
  await Hive.openBox<UserSettings>('user_settings');
  await Hive.openBox<Folder>('folders');
  await Hive.openBox<Task>('tasks');

  // Initialize Notifications
  await NotificationService.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final UserSettingsProvider _userSettingsProvider = UserSettingsProvider();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserSettingsProvider>(
          create: (_) => _userSettingsProvider,
        ),
        ChangeNotifierProvider<FolderProvider>(
          create: (_) => FolderProvider(),
        ),
        ChangeNotifierProxyProvider2<FolderProvider, UserSettingsProvider,
            TaskProvider>(
          create: (context) => TaskProvider(
            folderProvider: Provider.of<FolderProvider>(context, listen: false),
            userSettingsProvider:
                Provider.of<UserSettingsProvider>(context, listen: false),
          ),
          update:
              (context, folderProvider, userSettingsProvider, taskProvider) =>
                  taskProvider!..notifyListeners(),
        ),
      ],
      child: Consumer<UserSettingsProvider>(
        builder: (context, userSettingsProvider, child) {
          // If user settings are not set, navigate to Initial Setup
          if (userSettingsProvider.userSettings == null ||
              userSettingsProvider.userSettings!.name.isEmpty) {
            return MaterialApp(
              title: 'TaskFlow',
              theme: appTheme,
              home: const InitialSetupScreen(),
              onGenerateRoute: (settings) {
                // Define routes if needed
                return null;
              },
            );
          }

          return MaterialApp(
            title: 'TaskFlow',
            theme: appTheme,
            home: const WelcomeScreen(),
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
                default:
                  return MaterialPageRoute(
                      builder: (context) => const HomeScreen());
              }
            },
          );
        },
      ),
    );
  }
}
