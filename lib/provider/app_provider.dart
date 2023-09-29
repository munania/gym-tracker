import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  String _userName = '';

  String get userName => _userName;

  set userName(String name) {
    _userName = name;
    notifyListeners();
  }

  String _quote = '';
  String _author = '';
  String get quote => _quote;
  String get author => _author;

  set quote(String quote){
    _quote = quote;
    notifyListeners();
  }
  set author(String author){
    _author = author;
    notifyListeners();
  }

//   Workout days provider
  List _selectedWorkoutDays = [];

  get getWorkoutDays => _selectedWorkoutDays;

  // set setWorkoutDays(List days){
  //   _selectedWorkoutDays = days;
  // }

  void setWorkoutDays(List days) { _selectedWorkoutDays = days;}

  late String _currentDay;

  void setCurrentDay(String day) {
    _currentDay = day;
  }

  String getCurrentDay() {
    return _currentDay;
  }
  // AppProvider({required this.currentDay});


}

class DayModel {
  final String name;
  bool isSelected;

  DayModel(this.name, this.isSelected);
}

