import 'package:flutter/material.dart';
import 'package:gymtracker/views/settings/workoutDaysScreen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<String> weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  void _onDayTap(String day) {
    switch (day) {
      case 'Sunday':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => workoutDayPage(currentDay: "Sunday")));
        break;
      case 'Monday':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => workoutDayPage(currentDay: "Monday")));
        break;
      case 'Tuesday':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => workoutDayPage(currentDay: "Tuesday")));
        break;
      case 'Wednesday':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>  workoutDayPage(currentDay: "Wednesday")));
        break;
      case 'Thursday':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>  workoutDayPage(currentDay: "Thursday")));
        break;
      case 'Friday':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>  workoutDayPage(currentDay: "Friday")));
        break;
      case 'Saturday':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) =>  workoutDayPage(currentDay: "Saturday")));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit your workout days",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: weekDays.length,
                itemBuilder: (_, index) {
                  final day = weekDays[index];
                  return GestureDetector(
                    onTap: () {
                      _onDayTap(day);
                    },
                    child: Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.calendar_month,
                                color: Color.fromARGB(100, 99, 253, 217)),
                            title: Text(day),
                            // trailing: const Icon(Icons.edit,
                            //     color: Color.fromARGB(100, 99, 253, 217)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}