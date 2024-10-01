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

  // Register TypeAdapters with unique typeIds
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
          return MaterialApp(
            title: 'TaskFlow',
            theme: appTheme,
            initialRoute: userSettingsProvider.userSettings == null ||
                    userSettingsProvider.userSettings!.name.isEmpty
                ? '/initial-setup'
                : '/',
            routes: {
              '/': (context) => const WelcomeScreen(),
              '/initial-setup': (context) => const InitialSetupScreen(),
              '/home': (context) => const HomeScreen(),
              '/folders': (context) => const FolderScreen(),
              '/reports': (context) => const ReportScreen(),
              // Remove '/task-detail' from routes
              // '/task-detail': (context) => TaskDetailScreen(), // Removed
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/add-task') {
                final args = settings.arguments as Map<String, dynamic>?;
                final String? taskId = args != null ? args['taskId'] : null;
                return MaterialPageRoute(
                  builder: (context) => AddTaskScreen(taskId: taskId),
                );
              }
              if (settings.name == '/task-detail') {
                final args = settings.arguments as Map<String, dynamic>?;
                if (args == null || !args.containsKey('taskId')) {
                  return MaterialPageRoute(
                    builder: (context) => const Scaffold(
                      body: Center(child: Text('No Task ID provided')),
                    ),
                  );
                }
                final String taskId = args['taskId'];
                return MaterialPageRoute(
                  builder: (context) => TaskDetailScreen(taskId: taskId),
                );
              }
              return null; // Let `onUnknownRoute` handle all other routes
            },
            onUnknownRoute: (settings) => MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Route not found')),
              ),
            ),
          );
        },
      ),
    );
  }
}
