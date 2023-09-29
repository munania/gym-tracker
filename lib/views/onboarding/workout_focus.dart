import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../db/databaseHelper.dart';
import '../../provider/app_provider.dart';

class WorkoutFocus extends StatefulWidget {
  const WorkoutFocus({super.key});

  @override
  State<WorkoutFocus> createState() => _WorkoutFocusState();
}

class _WorkoutFocusState extends State<WorkoutFocus> {
  List days = [];
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDays();
  }

  void getDays(){
    // Save workout days to provider
    final workoutDays = Provider.of<AppProvider>(context, listen: false);
    days = workoutDays.getWorkoutDays;
  }

  void _onContinueButtonPressed() async {

    final DatabaseHelper databaseHelper = DatabaseHelper.instance;

    // Get the user's name from the provider
    final userName = Provider.of<AppProvider>(context, listen: false).userName;

    // Call the insertUser method
    await databaseHelper.insertUser(userName: userName);

    for (var i = 0; i < days.length; i++) {
      await databaseHelper.insertWorkoutDays(dayName: days[i], focusArea: controllers[i].text);
    }

    // Navigate to the dashboard and prevent navigation backward
    Get.offNamed('/homepage');
    Get.until((route) => route.isFirst); // Prevent navigation backward
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Select your workout focus",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20.0, left: 30, right: 30),
            child: Center(
              child: Text(
                  "For workout day, select which region of the body your focus will be on",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
              itemCount: days.length,
              itemBuilder: (_, index) {
                print(days.length,);
                controllers.add(TextEditingController());
                return Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: TextFormField(
                    controller: controllers[index],
                    decoration: InputDecoration(
                      labelText: days[index],
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _onContinueButtonPressed,
                    child: const Text("Continue",
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
