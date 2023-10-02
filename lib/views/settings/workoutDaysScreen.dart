import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../db/databaseHelper.dart';

class workoutDayPage extends StatefulWidget {
  final String currentDay;

  const workoutDayPage({super.key, required this.currentDay});

  @override
  workoutDayPageState createState() => workoutDayPageState();
}

class workoutDayPageState extends State<workoutDayPage> {
  late String day = widget.currentDay;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(); // Initialize the controller
    getWorkoutForSpecificDay(); // Load workouts on initialization
  }

  Future<String?> getFocusAreaForDay(dayName) async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    String? focusArea = await databaseHelper.getFocusAreaForDayString(dayName);
    return focusArea;
  }

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
      ),
      body: Column(
        children: [
          FutureBuilder(
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
                  controller.text = focusArea;

                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 30.0, bottom: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Edit today's focus area",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'Add or Edit Focus area',
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'Oops! no workouts found for $day',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ),
                  );
                }
              }
            },
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: getWorkoutForSpecificDay(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<Map<String, dynamic>> workouts = snapshot.data!;
                  return ListView.builder(
                      itemCount: workouts.length,
                      itemBuilder: (context, index) {
                        // Build your list item using workouts[index]
                        return Padding(
                          padding:
                              const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(workouts[index]['name']),
                                subtitle: Text(
                                    '${workouts[index]['sets'].toString()} Sets ${workouts[index]['reps'].toString()} Reps'),
                                trailing: GestureDetector(
                                  onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text("Confirm Deletion"),
                                              content: const Text("Are you sure you want to delete this workout?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); // Close the dialog
                                                  },
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // Add code to delete the workout here
                                                    DatabaseHelper databasehelper = DatabaseHelper.instance;
                                                    databasehelper.deleteWorkout(workouts[index]['id']);
                                                    print(workouts[index]['name']);
                                                    if (kDebugMode) {
                                                      print('Deleting... OK');
                                                    }
                                                    setState(() {});
                                                    Navigator.of(context).pop(); // Close the dialog
                                                  },
                                                  child: const Text("Delete"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                    // You can access the workout data using workouts[index]
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                } else {
                  return const Center(
                    child: Text('No workouts for this day'),
                  );
                }
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    DatabaseHelper databaseHelper = DatabaseHelper.instance;
                    databaseHelper.updateFocusAreaForDay(day, controller.text);
                    String editedfocusArea = controller.text;
                    setState(() {});
                    print(' HERE $editedfocusArea');

                    // Show a snackbar to indicate that the focus area has been updated
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Focus area updated for $day'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('SAVE'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
