import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/app_provider.dart';
import '../../widgets/custom_textfield.dart';

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final nameInputController = TextEditingController();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  bool showError = false;


  void _onContinueButtonPressed() {
    if (nameInputController.text.isEmpty) {
      setState(() {
        showError = true;
      });
    } else {
      final userNameProvider = Provider.of<AppProvider>(context, listen: false);
      userNameProvider.userName = nameInputController.text;
      // print(userNameProvider.userName);
      setUsername(nameInputController.text);
      Get.offNamed('/workoutDays');
      Get.until((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldMessengerKey,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const Text(
                  "What is your name",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  labelText: "Username",
                  controller: nameInputController,
                  hintText: "Enter your username",
                  errorText: showError ? 'Please enter a username' : null,
                ),
                const SizedBox(
                  height: 30,
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
                // ElevatedButton(onPressed: _onContinueButtonPressed, child: const Text("Continue"),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


Future<void> setUsername(String username) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('username', username);
}