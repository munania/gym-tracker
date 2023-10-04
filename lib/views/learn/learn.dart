import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymtracker/db/databaseHelper.dart';

import '../../widgets/custom_textfield.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  final TextEditingController exerciseNameController = TextEditingController();
  final TextEditingController repsController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController restingTimeController = TextEditingController();
  final TextEditingController workoutDayController = TextEditingController();

  Future<List<Map<String, dynamic>>> getWorkouts() async {
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    var workouts = databaseHelper.getAllWorkouts();

    return workouts;
  }

  final _formKey = GlobalKey<FormState>();

  double spacing = 20.0;

  List<String> options = [];

  // String selectedItem = '';

  void loadWorkoutDays() async {
    List<String> workoutDays = await getWorkoutDays();
    setState(() {
      options = workoutDays.toSet().toList();
      if (kDebugMode) {
        print('OPTIONS: $options');
      }
    });
  }

  Future<List<String>> getWorkoutDays() async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    List<String> dayNames = await databaseHelper.getWorkoutDayNames();
    if (kDebugMode) {
      print("Our List $dayNames");
    }

    // Remove duplicates from the dayNames list
    List<String> uniqueDayNames = dayNames.toSet().toList();

    return uniqueDayNames;
  }

  Future<String> returnDay(int dayId) async{
    DatabaseHelper databaseHelper = DatabaseHelper.instance;
    print("BEFORE:");
    String day = await databaseHelper.getWorkoutDayName(dayId);
    return day;
  }

  @override
  void initState() {
    super.initState();
    loadWorkoutDays();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All my workouts'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            var allWorkouts = snapshot.data;
            // if (kDebugMode) {
            //   print(allWorkouts?[0]);
            // }
            return ListView.builder(
              itemCount: allWorkouts?.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    // Capture the context
                    BuildContext context = this.context;

                    String exerciseName = exerciseNameController.text;
                    String day = await returnDay(allWorkouts?[index]['day_id']);

                    String name = allWorkouts?[index]['name'];
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        String selectedItem =
                            options.isNotEmpty ? options[0] : '';

                        if (kDebugMode) {
                          print('OPTIONS $options');
                          print(day);
                        }

                        String exerciseName = allWorkouts?[index]['name'] ?? '';
                        int sets = allWorkouts?[index]['sets'] ?? 0;
                        int reps = allWorkouts?[index]['reps'] ?? 0;
                        int weight = allWorkouts?[index]['weight'] ?? 0;
                        int duration = allWorkouts?[index]['duration'] ?? 0;
                        int dayId = allWorkouts?[index]['day_id'] ?? 0;

                        exerciseNameController.text = exerciseName;
                        setsController.text = sets.toString();
                        repsController.text = reps.toString();
                        weightController.text = weight.toString();
                        restingTimeController.text = duration.toString();
                        workoutDayController.text = dayId.toString();



                        // ValueNotifier<String> selectedValue = ValueNotifier<String>('day'); // Step 1
                        // String selectedValue = day;
                        String selectedValue = options.contains(day) ? day : options.isNotEmpty ? options[0] : '';


                        String selectedWorkout = options.isNotEmpty ? options[0] : '';

                        return AlertDialog(
                          title: Text('Edit $name Workout'),
                          content: SingleChildScrollView(
                            child: SizedBox(
                              // height: MediaQuery.of(context).size.height * 0.9,
                              width: MediaQuery.of(context).size.width * 0.9,
                              // Set the width to 80% of the screen width
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: spacing,
                                    ),
                                    CustomTextField(
                                      keyBoard: TextInputType.text,
                                      labelText: 'Workout Name',
                                      hintText: "Burpees...",
                                      controller: exerciseNameController,
                                    ),
                                    SizedBox(
                                      height: spacing,
                                    ),
                                    CustomTextField(
                                      keyBoard: TextInputType.number,
                                      labelText: 'Sets',
                                      hintText: "10",
                                      controller: setsController,
                                    ),
                                    SizedBox(
                                      height: spacing,
                                    ),
                                    CustomTextField(
                                      keyBoard: TextInputType.number,
                                      labelText: 'Reps',
                                      hintText: "10",
                                      controller: repsController,
                                    ),
                                    SizedBox(
                                      height: spacing,
                                    ),
                                    CustomTextField(
                                      keyBoard: TextInputType.number,
                                      labelText: 'Weight',
                                      hintText: "45 kgs",
                                      controller: weightController,
                                    ),
                                    SizedBox(
                                      height: spacing,
                                    ),
                                    CustomTextField(
                                      keyBoard: TextInputType.number,
                                      labelText: 'Duration',
                                      hintText: "10 minutes",
                                      controller: restingTimeController,
                                    ),
                                    SizedBox(
                                      height: spacing,
                                    ),
                                    const Text("Select Workout Day"),
                                    SizedBox(
                                      height: spacing,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: DropdownButtonFormField<String>(
                                          value: selectedValue,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedItem = newValue!;
                                            });
                                          },
                                          items: options
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value, // Use the actual value from the options list
                                              child: Text(value),
                                            );
                                          }).toList(),
                                          decoration: const InputDecoration(
                                            border: InputBorder
                                                .none, // Remove the default dropdown border
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Get.back();
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(allWorkouts?[index]['name']),
                          subtitle: Text(
                            '${allWorkouts?[index]['sets']} Sets ${allWorkouts?[index]['reps']} Reps',
                          ),
                          // You can add more widgets here based on your data
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
