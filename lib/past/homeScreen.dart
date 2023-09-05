// import 'dart:ui';

// import 'package:flutter/material.dart';

// import 'db/databaseHelper.dart';
// import 'floatingActionButton.dart';
// import 'models/exercise.dart';
// import 'models/exercise_details_page.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late List<Exercise> exercises;

//   @override
//   void initState() {
//     super.initState();
//     exercises = [];
//     fetchExercisesFromDatabase();
//   }

//   void fetchExercisesFromDatabase() async {
//     // Fetch exercises from the database using DatabaseHelper
//     exercises = await DatabaseHelper().getAllExercises();
//     exercises = exercises.reversed.toList();

//     // Update the state to reflect the changes
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 0),
//               child: Stack(
//                 children: [
//                   Image.asset(
//                     'assets/woman1.jpg',
//                     fit: BoxFit.cover,
//                     height: 250,
//                     width: double.infinity,
//                   ),
//                   Container(
//                     height: 250,
//                     width: double.infinity,
//                     color: Colors.black.withOpacity(0.5),
//                   ),
//                   SizedBox(
//                     height: 200,
//                     width: double.infinity,
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//                       child: const Center(
//                         child: Padding(
//                           padding: EdgeInsets.all(16),
//                           child: Text(
//                             'Welcome back! Let\'s do this',
//                             style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Text(
//                 'My Exercises',
//                 style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//               ),
//             ),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: exercises.length,
//               itemBuilder: (BuildContext context, int index) {
//                 final exercise = exercises[index];
//                 return Container(
//                   color: Colors.grey[200],
//                   margin: const EdgeInsets.only(bottom: 8.0),
//                   child: ListTile(
//                     key: Key(exercise.name.toString()),
//                     title: Text(
//                       exercise.name,
//                       style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ExerciseDetailsPage(exercise: exercise),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButtonWidget(),
//     );
//   }
// }
