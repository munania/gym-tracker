import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymtracker/services/user_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

import '../db/databaseHelper.dart';
import '../models/quotes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<Quotes> quotes = [];

  @override
  void initState() {
    super.initState();
    // Call the motivation function after a delay
    Future.delayed(const Duration(seconds: 1), () {
      fetchAllQuotes();
    });
  }

  Future<void> fetchAllQuotes() async {
    final response = await UserApi.motivation();
    quotes = response;
  }

  Future<bool> _isFirstTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    // If it's the first time, set the flag to false for future launches
    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    }
    return isFirstTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: _isFirstTime(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While checking, show a loading indicator or some UI feedback
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            // Handle any errors
            return Text('Error: ${snapshot.error}');
          } else {
            // Check the value of isFirstTime and navigate accordingly
            final bool isFirstTime = snapshot.data ?? true;

            Future.delayed(const Duration(seconds: 5), () async {
              if (isFirstTime) {
                final DatabaseHelper databaseHelper = DatabaseHelper.instance;

                // Insert the quotes into the database
                for (final quote in quotes) {
                  await databaseHelper.insertQuotes(
                    text: quote.text,
                    author: quote.author.split(',')[0],
                  );
                }
                Get.offNamed('/nameInput');
              } else {
                Get.offNamed('/homepage');
              }
            });

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lottie/anim.json'),
                  const Text(
                    'Gym Tracker',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
