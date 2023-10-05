import 'package:flutter/material.dart';
import 'package:get/get.dart';


class EditWorkouts extends StatefulWidget {
  const EditWorkouts({super.key});

  @override
  State<EditWorkouts> createState() => _EditWorkoutsState();
}

class _EditWorkoutsState extends State<EditWorkouts> {


  @override
  Widget build(BuildContext context) {

    dynamic arguments = Get.arguments;
    String workoutName = arguments != null ? arguments.toString() : '';

    return Scaffold(
     appBar: AppBar(
       leading: IconButton(
         icon: Icon(Icons.arrow_back),
         onPressed: () {


         },
       ),
       title: Text('Edit $workoutName'),
       centerTitle: true,
     ),
    );
  }
}
