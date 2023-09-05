// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gymtracker/homePage.dart';

// import 'db/databaseHelper.dart';
// import 'models/exercise.dart';

// class FloatingActionButtonWidget extends StatelessWidget {

//   final TextEditingController exerciseNameController = TextEditingController();
//   final TextEditingController repsController = TextEditingController();
//   final TextEditingController setsController = TextEditingController();
//   final TextEditingController weightController = TextEditingController();
//   final TextEditingController restingTimeController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   FloatingActionButtonWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       onPressed: () {
//         _showExerciseDialog(context);
//       },
//       child: const Icon(Icons.add),
//     );
//   }

//   void _showExerciseDialog(BuildContext context) {

//     showDialog(
      
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Add Exercise'),
//           content: SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               // autovalidateMode: AutovalidateMode.always,
//               child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     TextFormField(
//                       controller: exerciseNameController,
//                       decoration: const InputDecoration(labelText: 'Exercise Name',),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter an exercise name';
//                         }
//                         return null;
//                       },
//                       keyboardType: TextInputType.text,
//                       inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
//                     ),
//                     const SizedBox(height: 10),
//                     TextFormField(
//                       controller: setsController,
//                       decoration: const InputDecoration(labelText: 'Sets'),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter number of sets';
//                         }
//                         return null;
//                       },
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     ),
//                     const SizedBox(height: 10),
//                     TextFormField(
//                       controller: repsController,
//                       decoration: const InputDecoration(labelText: 'Reps'),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter number of reps';
//                         }
//                         return null;
//                       },
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     ),
                    
//                     const SizedBox(height: 10),
//                     TextFormField(
//                       controller: weightController,
//                       decoration: const InputDecoration(labelText: 'Weight per Rep'),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter weight';
//                         }
//                         return null;
//                       },
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     ),
//                     const SizedBox(height: 10),
//                     TextFormField(
//                       controller: restingTimeController,
//                       decoration: const InputDecoration(labelText: 'Resting Time(in seconds)'),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter resting time';
//                         }
//                         return null;
//                       },
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     ),
//                   ],
//                 ),
//             ),
//           ),
          
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {

//                 final form = _formKey.currentState;

//                 if (form != null && form.validate()) {
//                   final exercise = Exercise(
//                    name: exerciseNameController.text,
//                    reps: _parseInteger(repsController.text),
//                    sets: _parseInteger(setsController.text),
//                    weight: _parseInteger(weightController.text),
//                    restingTime: _parseInteger(restingTimeController.text),
//                   );
//                 await DatabaseHelper().insertExercise(exercise);

//                 Navigator.pop(context);
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => const HomePage()),
//                   (Route<dynamic> route) => false,
//                 );
//               }                            
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   int? _parseInteger(String value) {
//     try {
//       return int.parse(value);
//     } catch (e) {
//       return null;
//     }
//   }
// }
