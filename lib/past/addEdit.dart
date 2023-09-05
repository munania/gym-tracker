import 'package:flutter/material.dart';

class AddEditExerciseScreen extends StatelessWidget {
  const AddEditExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Edit Exercise'),
      ),
      body: const Center(
        child: Text('Add/Edit Exercise Screen'),
      ),
    );
  }
}
