import 'package:flutter/material.dart';

class ExerciseListScreen extends StatelessWidget {
  const ExerciseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise List'),
      ),
      body: const Center(
        child: Text('Exercise List Screen'),
      ),
    );
  }
}
