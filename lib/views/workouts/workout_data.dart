import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../db/databaseHelper.dart';

class WorkoutData extends StatefulWidget {
  final String currentDay;

  const WorkoutData({super.key, required this.currentDay});

  @override
  State<WorkoutData> createState() => _WorkoutDataState();
}

class _WorkoutDataState extends State<WorkoutData> {
  late String day = widget.currentDay;

  Future<int> getWorkoutDayId(String dayName) async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    int dayId = await databaseHelper.getWorkoutDayId(dayName);
    return dayId;
  }

  Future<List<Map<String, dynamic>>> getWorkoutForSpecificDay() async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    int dayId = await getWorkoutDayId(day);
    List<Map<String, dynamic>> workouts =
        await databaseHelper.getWorkoutDaysForDay(dayId);
    return workouts;
  }

  Future<String?> getFocusAreaForDay(dayName) async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    String? focusArea = await databaseHelper.getFocusAreaForDayString(dayName);
    return focusArea;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: getFocusAreaForDay(day),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                  'Loading...'); // Show a loading message while waiting for data
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              String? focusArea = snapshot.data;

              if (focusArea != null) {
                return Text('$day - $focusArea day');
              } else {
                return Text(day);
              }
            }
          },
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: getWorkoutForSpecificDay(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                List<Map<String, dynamic>> workouts = snapshot.data!;

                print(workouts);
                return Expanded(
                  child: ListView.builder(
                      itemCount: workouts.length,
                      itemBuilder: (context, index) {
                        // Build your list item using workouts[index]
                        return Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                          child: Card(
                            child: Column(
                              children: [
                                ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(top:15.0, bottom: 15.0),
                                    child: Text(workouts[index]['name'], style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(bottom: 15.0),
                                    child: Text(
                                      '${workouts[index]['sets'].toString()} Sets ${workouts[index]['reps'].toString()} Reps ${workouts[index]['duration'].toString()} Kgs ${workouts[index]['duration'].toString()} Minutes',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                );
              } else {
                return const Center(
                  child: Text('No workouts for this day'),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
