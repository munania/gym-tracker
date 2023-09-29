import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/app_provider.dart';

class WorkoutDaysScreen extends StatefulWidget {
  const WorkoutDaysScreen({super.key});

  @override
  _WorkoutDaysScreenState createState() => _WorkoutDaysScreenState();
}

class _WorkoutDaysScreenState extends State<WorkoutDaysScreen> {

  final List weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  final List<bool> isSelected = List.generate(7, (index) => false);
  List allSelectedDays = [];

  void _onContinueButtonPressed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userNameProvider = Provider.of<AppProvider>(context, listen: false);
    final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    // If it's the first time, set the flag to false for future launches
    if (isFirstTime && userNameProvider.userName!="") {
      await prefs.setBool('isFirstTime', false);
    }
    // Save workout days to provider
    final workoutDays = Provider.of<AppProvider>(context, listen: false);
    workoutDays.setWorkoutDays(allSelectedDays);
    print('Selected Days: ${workoutDays.getWorkoutDays}');

    // Navigate to the focus page and prevent navigation backward
    Get.offNamed('/workoutFocus');
    // Get.until((route) => route.isFirst); // Prevent navigation backward
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select your workout days",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ), // Extend body behind the AppBar
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: weekDays.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(weekDays[index]),
                            tileColor: isSelected[index] ? Colors.blue : null,
                            onTap: () {
                              setState(() {
                                isSelected[index] = !isSelected[index];
                              });
                              print(weekDays[index]);
                              if (isSelected[index]) {
                                allSelectedDays.add(weekDays[index]);
                              } else if (!isSelected[index]) {
                                allSelectedDays.remove(weekDays[index]);
                              }
                              ;
                              print("All days $allSelectedDays");
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
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
    );
  }
}
