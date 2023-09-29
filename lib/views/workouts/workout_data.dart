import 'package:flutter/material.dart';

class WorkoutData extends StatefulWidget {
  const WorkoutData({super.key});

  @override
  State<WorkoutData> createState() => _WorkoutDataState();
}

class _WorkoutDataState extends State<WorkoutData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Data'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return const Card(
            child: ListTile(
              title: Text('Crunches'),
              subtitle: Text('10 REPS 12 SETS'),
              trailing: Text('30 minutes'),
            ),
          );
        },
      ),
    );
  }
}
