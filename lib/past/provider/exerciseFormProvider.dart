import 'package:flutter/material.dart';

class ExerciseFormProvider extends ChangeNotifier {
  String? exerciseNameError;

  void resetErrors() {
    exerciseNameError = null;
    notifyListeners();
  }

  void validateExerciseName(String value) {
    if (value.isEmpty) {
      exerciseNameError = 'Please enter an exercise name';
    } else {
      exerciseNameError = null;
    }
    notifyListeners();
  }
}
