// import 'package:flutter/material.dart';
// import 'SettingScreen.dart';
// import 'WorkoutScreen.dart';
// import 'bottomNavigationWidget.dart';
// import 'homeScreen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = [
//     const HomeScreen(),
//     const WorkoutScreen(),
//     const SettingsScreen(),
//   ];

//   void _onTabSelected(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Gym Tracker'),
//       ),
//       body: _screens[_currentIndex],
//       bottomNavigationBar: BottomNavigation(
//         currentIndex: _currentIndex,
//         onTabSelected: _onTabSelected,
//       ),
//     );
//   }
// }
        
       
      
