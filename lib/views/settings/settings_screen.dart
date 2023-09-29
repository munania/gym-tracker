import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../db/databaseHelper.dart';
import '../../provider/app_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final List weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  @override
  void initState() {
    super.initState();
    getWorkoutDays();
    loadWorkoutDays();
  }

  List<String> options = [];

  // String selectedItem = '';

  void loadWorkoutDays() async {
    List<String> workoutDays = await getWorkoutDays();
    setState(() {
      options = workoutDays.toSet().toList();
      print(options);
    });
  }

  Future<List<String>> getWorkoutDays() async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    List<String> dayNames = await databaseHelper.getWorkoutDayNames();
    print("Our List $dayNames");

    // Remove duplicates from the dayNames list
    List<String> uniqueDayNames = dayNames.toSet().toList();

    return uniqueDayNames;
  }

  Future<int> getWorkoutDayId(String dayName) async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    int dayId = await databaseHelper.getWorkoutDayId(dayName);
    return dayId;
  }

  Future<String?> getFocusAreaForDay(dayId) async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    String? focusArea = await databaseHelper.getFocusAreaForDay(dayId);
    return focusArea;
  }

  final List<bool> isSelected = List.generate(7, (index) => false);
  List allSelectedDays = [];


  void _onSaveButtonPressed() async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;

    // Iterate through the selected days and their focus areas
    for (String day in options) {
      // Get the day ID
      int dayId = await getWorkoutDayId(day);

      // Get the focus area for the day
      String? focusArea = await getFocusAreaForDay(dayId);

      print('DAY ID $dayId');
      print(focusArea);

      // Save the selected day and its focus area to the database
      // await databaseHelper.saveSelectedDay(day, focusArea);
    }

    // Navigate to the desired page
    // Get.offNamed('');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit your workout days",
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
                  final day = weekDays[index];
                  final isSelected = options.contains(day);

                  return FutureBuilder<int>(
                    future: getWorkoutDayId(day),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final dayId = snapshot.data!;
                        final focusAreaFuture = getFocusAreaForDay(dayId);

                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 30, right: 30),
                          child: Card(
                            child: Column(
                              children: [
                                ListTile(
                                  // trailing: const Icon(Icons.edit),
                                  title: Text(day),
                                  tileColor: isSelected ? Colors.blue : null,
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        options.remove(day);
                                      } else {
                                        options.add(day);
                                      }
                                    });
                                  },
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Color.fromARGB(100, 15, 114, 103),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: FutureBuilder<String?>(
                                      future: focusAreaFuture,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Container();
                                        } else if (snapshot.hasError) {
                                          return Text('Error: ${snapshot.error}');
                                        } else {
                                          final focusArea = snapshot.data ?? '';
                                          final controller =
                                              TextEditingController(
                                                  text: focusArea);

                                          return TextField(
                                            controller: controller,
                                            decoration: const InputDecoration(
                                              hintText: 'Add or Edit Focus area',
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
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
                      onPressed: _onSaveButtonPressed,
                      child: const Text("Save",
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

// I want to get all selected days with their focus area when the save button is clicked and save it to the db