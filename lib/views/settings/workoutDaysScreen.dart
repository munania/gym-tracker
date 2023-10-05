import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../db/databaseHelper.dart';
import '../../widgets/custom_textfield.dart';

class workoutDayPage extends StatefulWidget {
  final String currentDay;

  const workoutDayPage({super.key, required this.currentDay});

  @override
  workoutDayPageState createState() => workoutDayPageState();
}

class workoutDayPageState extends State<workoutDayPage> {
  late String day = widget.currentDay;
  late TextEditingController controller;

  TextEditingController focusAreaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {

    });
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              // Add your delete logic here
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirm Deletion"),
                    content: const Text(
                        "Are you sure you want to delete this workout day?"),
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
                          DatabaseHelper databaseHelper =
                              DatabaseHelper.instance;

                          databaseHelper.deleteWorkoutDay(day);

                          setState(() {});
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text("Delete"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
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
                    child: Padding(
                      padding: const EdgeInsets.only(top: 90.0),
                      child: Column(
                        children: [
                          Text(
                            'Oops! no workouts found for $day',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Add focus area for $day'),
                                    content: SingleChildScrollView(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              CustomTextField(
                                                keyBoard: TextInputType.text,
                                                labelText: 'Focus Area',
                                                hintText:
                                                    "Chest day, leg day etc",
                                                controller: focusAreaController,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          // Add your save logic here
                                          DatabaseHelper databaseHelper =
                                              DatabaseHelper.instance;
                                          databaseHelper.insertWorkoutDays(
                                              dayName: day,
                                              focusArea:
                                                  focusAreaController.text);
                                          focusAreaController.clear();
                                          // setState(() {});
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                          setState(() {});
                                        },
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text('Add new focus area'),
                          ),
                        ],
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
                                          content: const Text(
                                              "Are you sure you want to delete this workout?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Add code to delete the workout here
                                                DatabaseHelper databaseHelper =
                                                    DatabaseHelper.instance;
                                                databaseHelper.deleteWorkout(
                                                    workouts[index]['id']);
                                                if (kDebugMode) {
                                                  print(
                                                      workouts[index]['name']);
                                                }
                                                if (kDebugMode) {
                                                  print('Deleting... OK');
                                                }
                                                setState(() {});
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
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
          // ...
          Row(
            children: [
              FutureBuilder(
                future: getFocusAreaForDay(day),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(); // Return an empty container while waiting for data
                  } else if (snapshot.hasError) {
                    return Container(); // Return an empty container in case of an error
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // Show the SAVE button if there are workouts
                    return Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          DatabaseHelper databaseHelper =
                              DatabaseHelper.instance;
                          databaseHelper.updateFocusAreaForDay(
                              day, controller.text);
                          String editedfocusArea = controller.text;
                          setState(() {});
                          print(' HERE $editedfocusArea');

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Focus area updated for $day'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text('SAVE'),
                      ),
                    );
                  } else {
                    return Container(); // Return an empty container if there are no workouts
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
