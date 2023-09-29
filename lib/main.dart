import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymtracker/past/SettingScreen.dart';
import 'package:gymtracker/past/WorkoutScreen.dart';
import 'package:gymtracker/provider/app_provider.dart';
import 'package:gymtracker/views/dashboard/dashboard_screen.dart';
import 'package:gymtracker/views/dashboard/homePage.dart';
import 'package:gymtracker/views/learn/learn.dart';
import 'package:gymtracker/views/onboarding/workout_focus.dart';
import 'package:gymtracker/views/splash_screen.dart';
import 'package:gymtracker/views/workouts/workout_data.dart';
import 'package:provider/provider.dart';

// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'db/databaseHelper.dart';
import 'views/onboarding/name_input_screen.dart';
import 'views/onboarding/workout_days_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // databaseFactory = databaseFactoryFfi;
  await DatabaseHelper.instance.database; // Initialize the database

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: const MyApp(), // Your app's root widget
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int currentDay = now.weekday;

    String getDayOfWeek(int day) {
      switch (day) {
        case 1:
          return 'Monday';
        case 2:
          return 'Tuesday';
        case 3:
          return 'Wednesday';
        case 4:
          return 'Thursday';
        case 5:
          return 'Friday';
        case 6:
          return 'Saturday';
        case 7:
          return 'Sunday';
        default:
          return '';
      }
    }
    String day = getDayOfWeek(currentDay);


    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppProvider>(
          create: (context) => AppProvider()..setCurrentDay(day),
        ),
        // Add other providers if needed
      ],
      child: GetMaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        getPages: [
          GetPage(name: '/splash', page: () => const SplashScreen()),
          GetPage(name: '/nameInput', page: () => const NameInputScreen()),
          GetPage(name: '/workoutDays', page: () => const WorkoutDaysScreen()),
          GetPage(name: '/dashboard', page: () => const DashboardScreen()),
          GetPage(name: '/homepage', page: () => const HomePage()),
          GetPage(name: '/workouts', page: () => const WorkoutScreen()),
          GetPage(name: '/learnScreen', page: () => const LearnScreen()),
          GetPage(name: '/settingsScreen', page: () => const SettingsScreen()),
          GetPage(name: '/workoutFocus', page: () => const WorkoutFocus()),
          GetPage(name: '/workoutData', page: () => const WorkoutData()),
          GetPage(
              name: '/floatingActionButton',
              page: () =>
              const FloatingActionButton(
                onPressed: null,
              )),
        ],
      ),
    );
  }
}

//     return GetMaterialApp(
//       theme: ThemeData.dark(),
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/splash',
//       getPages: [
//         GetPage(name: '/splash', page: () => const SplashScreen()),
//         GetPage(name: '/nameInput', page: () => const NameInputScreen()),
//         GetPage(name: '/workoutDays', page: () => const WorkoutDaysScreen()),
//         GetPage(name: '/dashboard', page: () => const DashboardScreen()),
//         GetPage(name: '/homepage', page: () => const HomePage()),
//         GetPage(name: '/workouts', page: () => const WorkoutScreen()),
//         GetPage(name: '/learn', page: () => const LearnScreen()),
//         GetPage(name: '/workoutFocus', page: () => const WorkoutFocus()),
//         GetPage(name: '/workoutdata', page: () => const WorkoutData()),
//         GetPage(
//             name: '/floatingActionButton',
//             page: () => const FloatingActionButton(
//                   onPressed: null,
//                 )),
//       ],
//     );
//   }
// }
