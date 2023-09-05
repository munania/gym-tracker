import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../db/databaseHelper.dart';
import '../../provider/app_provider.dart';

class WorkoutDaysScreen extends StatefulWidget {
  const WorkoutDaysScreen({super.key});

  @override
  _WorkoutDaysScreenState createState() => _WorkoutDaysScreenState();
}

class _WorkoutDaysScreenState extends State<WorkoutDaysScreen> {
  // Create a map to store selected days
  final Map<String, bool> selectedDays = {
    'Sunday': false,
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
  };

  void _onContinueButtonPressed() async{
    // Filter selected days
    final List<String> selected = selectedDays.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    // Save workout days to a controller or data model
    print('Selected Days: $selected');

    final DatabaseHelper databaseHelper = DatabaseHelper.instance;

    // Get the user's name from the provider
    final userName = Provider.of<AppProvider>(context, listen: false).userName;

    // Call the insertUser method
    await databaseHelper.insertUser(userName: userName, workoutDays: selected);

    // Navigate to the dashboard and prevent navigation backward
    Get.offNamed('/homepage');
    Get.until((route) => route.isFirst); // Prevent navigation backward
  }

  void _toggleDay(String day) {
    setState(() {
      selectedDays[day] = !selectedDays[day]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Extend body behind the AppBar
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const Text(
                  "Select your Workout Days",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  children: selectedDays.keys.map((day) {
                    final isSelected = selectedDays[day]!;
                    final color = isSelected ? const Color.fromARGB(255, 202, 187, 20) : Colors.grey[300];
                    return InkWell(
                      onTap: () => _toggleDay(day),
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _onContinueButtonPressed,
                          child: const Text("Continue",
                          style: TextStyle(
                            fontSize: 18,
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
