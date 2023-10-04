import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymtracker/db/databaseHelper.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/app_provider.dart';
import '../../widgets/floating_action_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? userName;

  void getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("username");
    setState(() {
      userName = userName;
    });
  }

  Future<DateTime?> getLastQuoteFetchTimestamp(SharedPreferences prefs) async {
    final timestamp = prefs.getInt('lastQuoteFetchTime');
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  Future<void> getQuoteFromDb(SharedPreferences prefs,
      AppProvider quotesProvider, BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final lastFetchTime = await getLastQuoteFetchTimestamp(prefs);

    if (lastFetchTime == null ||
        DateTime.now().difference(lastFetchTime).inHours >= 24) {
      final DatabaseHelper databaseHelper = DatabaseHelper.instance;
      final randomQuote = await databaseHelper.getRandomQuote();

      // final quotesProvider = Provider.of<AppProvider>(context, listen: false);
      quotesProvider.quote = randomQuote?['text'];
      quotesProvider.author = randomQuote?['author'];
      await prefs.setInt(
          'lastQuoteFetchTime', DateTime.now().millisecondsSinceEpoch);
    }
  }

  @override
  void initState() {
    super.initState();
    getUsername();
    SharedPreferences.getInstance().then((prefs) {
      final quotesProvider = Provider.of<AppProvider>(context, listen: false);
      getQuoteFromDb(prefs, quotesProvider, context);
    });
  }

  void getCurrentDayWorkoutSession(int dayId) async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    String? focusArea = await databaseHelper.getFocusAreaForDay(dayId);
    print('Focus Area: $focusArea');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym Tracker'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Hello \n',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: userName,
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Lottie.asset(
                'assets/lottie/gymworkout.json',
                repeat: true,
                reverse: true,
                height: 250,
                width: double.infinity,
              ),
              const SizedBox(height: 25),
              const TodaysWorkout(),
              const Motivation(),
            ],
          ),
        ),
      ),
      floatingActionButton: const FloatingActionButtonWidget(),
    );
  }
}

class TodaysWorkout extends StatelessWidget {
  const TodaysWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    Future<String?> getCurrentDayWorkoutSession(int dayId) async {
      final DatabaseHelper databaseHelper = DatabaseHelper.instance;
      String? focusArea = await databaseHelper.getFocusAreaForDay(dayId);
      print('Focus Area: $focusArea');
      return focusArea;
    }

    Future<String?> day() async {
      DateTime now = DateTime.now();
      int currentDay = now.weekday;
      String? x = await getCurrentDayWorkoutSession(currentDay);
      return x;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 36, 98, 90),
          ),
          child: Column(
            children: [
              FutureBuilder<String?>(
                future: day(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final focusArea = snapshot.data;
                    return Column(
                      children: [
                        const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 20.0, left: 16.0),
                              child: Text(
                                'Today\'s Workout is',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    "$focusArea",
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20, right: 20),
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    final quotesProvider =
                        Provider.of<AppProvider>(context, listen: false);
                    String d = quotesProvider.getCurrentDay();
                    print("Today is: $d");

                    Get.toNamed('/workoutData');
                  },
                  child: const Text(
                    'Start Workout',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container()
            ],
          ),
        ),
      ],
    );
  }
}

class Motivation extends StatelessWidget {
  const Motivation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
      child: Consumer<AppProvider>(
        builder: (context, appProvider, _) {
          return Column(
            children: [
              // A motivation text to be displayed in a standout color in italic and in quotes
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '" ${appProvider.quote} "',
                      style: const TextStyle(
                        // color: Colors.white,
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "by ${appProvider.author}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
