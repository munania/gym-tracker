import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymtracker/db/databaseHelper.dart';

import 'custom_textfield.dart';

class FloatingActionButtonWidget extends StatefulWidget {

  const FloatingActionButtonWidget({super.key});

  @override
  State<FloatingActionButtonWidget> createState() => _FloatingActionButtonWidgetState();
}

class _FloatingActionButtonWidgetState extends State<FloatingActionButtonWidget> {
  final TextEditingController exerciseNameController = TextEditingController();
  final TextEditingController repsController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController restingTimeController = TextEditingController();
  final TextEditingController workoutDayController = TextEditingController();

  double spacing = 15;

  final _formKey = GlobalKey<FormState>();

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


  @override
  void initState() {
    super.initState();
    loadWorkoutDays();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _showExerciseDialog(context);
      },
      child: const Icon(Icons.add),
    );
  }

  void _showExerciseDialog(BuildContext context) {
    String selectedItem = options.isNotEmpty ? options[0] : '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Add Workout'),
              content: SingleChildScrollView(
                child: Container(
                  // height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width * 0.9, // Set the width to 80% of the screen width
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
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButtonFormField<String>(
                              value: selectedItem,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedItem = newValue!;
                                });
                              },
                              items: options.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                border: InputBorder.none, // Remove the default dropdown border
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
                    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
                    final workoutDayId = await databaseHelper.getWorkoutDayId(selectedItem);
                    final workoutName = exerciseNameController.text;
                    final sets = int.parse(setsController.text);
                    final reps = int.parse(repsController.text);
                    final weight = int.parse(weightController.text);
                    final duration = int.parse(restingTimeController.text);

                    await databaseHelper.insertWorkout(
                      workoutName: workoutName,
                      sets: sets,
                      reps: reps,
                      weight: weight,
                      duration: duration,
                      dayId: workoutDayId,
                    );

                    exerciseNameController.clear();
                    setsController.clear();
                    repsController.clear();
                    weightController.clear();
                    restingTimeController.clear();
                    Get.back();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

}



//   int? _parseInteger(String value) {
//     try {
//       return int.parse(value);
//     } catch (e) {
//       return null;
//     }
//   }
// }
