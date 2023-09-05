import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymtracker/past/WorkoutScreen.dart';
import 'package:gymtracker/provider/app_provider.dart';
import 'package:gymtracker/views/dashboard/dashboard_screen.dart';
import 'package:gymtracker/views/dashboard/homePage.dart';
import 'package:gymtracker/views/learn/learn.dart';
import 'package:gymtracker/views/splash_screen.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'db/databaseHelper.dart';
import 'views/onboarding/name_input_screen.dart';
import 'views/onboarding/workout_days_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  static const Color primaryColor = Color(0xFF404040);
  static const Color accentColor = Color(0xFFFFA500);
  static const Color backgroundColor = Color(0x00000000);
  static const Color textColor = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.dark(),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashScreen()),
        GetPage(name: '/nameInput', page: () => const NameInputScreen()),
        GetPage(name: '/workoutDays', page: () => const WorkoutDaysScreen()),
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
        GetPage(name: '/homepage', page: () => const HomePage()),
        GetPage(name: '/workouts', page: () => const WorkoutScreen()),
        GetPage(name: '/learn', page: () => const LearnScreen()),
        GetPage(
            name: '/floatingActionButton',
            page: () => const FloatingActionButton(
                  onPressed: null,
                )),
      ],
    );
  }
}
