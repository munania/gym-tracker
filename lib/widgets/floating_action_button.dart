import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymtracker/db/databaseHelper.dart';

import 'custom_textfield.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  final TextEditingController exerciseNameController = TextEditingController();
  final TextEditingController repsController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController restingTimeController = TextEditingController();
  final TextEditingController workoutDayController = TextEditingController();

  double spacing = 15;

  final _formKey = GlobalKey<FormState>();

  FloatingActionButtonWidget({super.key});

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Workout'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              // autovalidateMode: AutovalidateMode.always,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Add fields here
                  SizedBox(
                    height: spacing,
                  ),
                  CustomTextField(
                    labelText: 'Workout Name',
                    hintText: "Burpees...",
                    controller: exerciseNameController,
                  ),
                  SizedBox(
                    height: spacing,
                  ),
                  CustomTextField(
                    labelText: 'Sets',
                    hintText: "10",
                    controller: setsController,
                  ),
                  SizedBox(
                    height: spacing,
                  ),
                  CustomTextField(
                    labelText: 'Reps',
                    hintText: "10",
                    controller: repsController,
                  ),
                  SizedBox(
                    height: spacing,
                  ),
                  CustomTextField(
                      labelText: 'Weight',
                      hintText: "45 kgs",
                      controller: weightController),
                  SizedBox(
                    height: spacing,
                  ),
                  CustomTextField(
                      labelText: 'Duration',
                      hintText: "10 minutes",
                      controller: restingTimeController),
                  SizedBox(
                    height: spacing,
                  ),
                  // CustomTextField(labelText: 'Workout Day', hintText: "Monday", controller: workoutDayController),
                ],
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
              onPressed: () {
                final DatabaseHelper databaseHelper = DatabaseHelper.instance;
                databaseHelper.insertWorkout(
                    workoutName: exerciseNameController.text,
                    sets: int.parse(setsController.text),
                    reps: int.parse(repsController.text),
                    weight: int.parse(weightController.text),
                    duration: int.parse(restingTimeController.text));

                exerciseNameController.clear();
                setsController.clear();
                repsController.clear();
                weightController.clear();
                restingTimeController.clear();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  int? _parseInteger(String value) {
    try {
      return int.parse(value);
    } catch (e) {
      return null;
    }
  }
}
