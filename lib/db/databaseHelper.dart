import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Open the database (or create if it doesn't exist)
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'gym-tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      print("Creating gym-tracker tables");
      await db.execute('''CREATE TABLE quotes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT NOT NULL,
            author TEXT NOT NULL
        );
      ''');
      await db.execute('''
        CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            username TEXT NOT NULL,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );      
      ''');
      await db.execute('''
            CREATE TABLE exercises (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            description TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
       ''');

      await db.execute('''
             CREATE TABLE workouts (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            sets INTEGER NOT NULL,
            reps INTEGER NOT NULL,
            weight INTEGER NOT NULL,
            duration INTEGER NOT NULL,
            day_id INTEGER,
            FOREIGN KEY (day_id) REFERENCES workout_days (day_id)
        );
      ''');

      await db.execute('''
          CREATE TABLE workout_days (
            day_id INTEGER PRIMARY KEY,
            user_id INTEGER,
            day_name TEXT,
            focus_area TEXT,
            FOREIGN KEY (user_id) REFERENCES users (id)
          );
      ''');
    } catch (err) {
      print("OHH SHIT!");
      print(err.toString());
      print("OHH SHIT");
    }
  }

  // Insert workouts to the workouts table
  Future<void> insertWorkout({
    required String workoutName,
    required int sets,
    required int reps,
    required int weight,
    required int duration,
    required int dayId,

  }) async {
    final db = await instance.database;
    await db.insert('workouts', {
      'name': workoutName,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'duration': duration,
      'day_id': dayId,

    });
  }

  // Insert user to the users table
  Future<void> insertUser({required String userName}) async {
    final db = await instance.database;

    // Check if a user with the same username already exists
    final existingUser =
        await db.query('users', where: 'username = ?', whereArgs: [userName]);

    if (existingUser.isEmpty) {
      await db.insert('users', {
        'username': userName,
      });
    } else {
      // User already exists, handle the error or provide feedback to the user
      print('User with username $userName already exists.');
    }
  }

  // Insert workoutDaya
  Future<void> insertWorkoutDays({required dayName, required focusArea}) async {
    final db = await instance.database;
    final userId = await getUserId();

    await db.insert('workout_days', {
      'day_name': dayName,
      'focus_area': focusArea,
      'user_id': userId,
    });
  }

  // Insert quotes from api to the quotes table
  Future<void> insertQuotes(
      {required String text, required String author}) async {
    final db = await instance.database;
    await db.insert('quotes', {
      'text': text,
      'author': author, // Convert list to comma-separated string
    });
  }

  // Get user id
  Future<int> getUserId() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> user = await db.query(
      'users',
      columns: ['id'],
      limit: 1,
    );
    return user[0]['id'];
  }

  // Get quotes from db
  Future<List<Map<String, dynamic>>?> getQuotes() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> quote = await db.query(
      'quotes',
      columns: ['author', 'text'],
    );

    // Check if a quote was found
    if (quote.isNotEmpty) {
      // Extract the name of the first user
      return quote;
    }
    return null;
  }

  // Get a random quote from the 'quotes' table
  Future<Map<String, dynamic>?> getRandomQuote() async {
    final db = await instance.database;
    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM quotes'));

    if (count == null || count == 0) {
      return null; // No quotes in the table
    }

    final randomId = (await db
        .rawQuery('SELECT id FROM quotes ORDER BY RANDOM() LIMIT 1'))[0]['id'];
    final quote =
        await db.query('quotes', where: 'id = ?', whereArgs: [randomId]);

    return quote.isNotEmpty ? quote.first : null;
  }

  // Fetch user from db
  Future<String?> getUserName() async {
    // Open the database
    final db = await instance.database;

    // Query the database to get the first user
    final List<Map<String, dynamic>> results = await db.query(
      'users',
      columns: ['name'], // Select only the 'name' column
      limit: 1, // Limit the result to the first user
    );

    // Check if a user was found
    if (results.isNotEmpty) {
      // Extract the name of the first user
      final userName = results.first['name'] as String;
      return userName;
    }

    // No user found
    return null;
  }

  // Fetch users workout days from db
  Future<List<String>> getWorkoutDayNames() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query('workout_days', columns: ['day_name']);

    List<String> dayNames = [];

    for (var result in results) {
      String dayName = result['day_name'];
      dayNames.add(dayName);
    }

    return dayNames;
  }

  Future<int> getWorkoutDayId(String selectedItem) async {
    final db = await instance.database;
    final result = await db.query(
      'workout_days',
      where: 'day_name = ?',
      whereArgs: [selectedItem],
    );
    if (result.isNotEmpty) {
      return result.first['day_id'] as int;
    } else {
      return -1; // Return a default value or handle the case when workout day is not found
    }
  }

  Future<String> getWorkoutDayName(int dayId) async {
    final db = await instance.database;
    final result = await db.query(
      'workout_days',
      where: 'day_id = ?',
      whereArgs: [dayId],
    );
    if (result.isNotEmpty) {
      return result.first['day_name'] as String;
    } else {
      return ""; // Return a default value or handle the case when workout day is not found
    }
  }

  Future<String?> getFocusAreaForDay(int dayId) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(
      'workout_days',
      where: 'day_id = ?',
      whereArgs: [dayId],
    );
    if (results.isNotEmpty) {
      return results.first['focus_area'];
    } else {
      return null;
    }
  }

  Future<String?> getFocusAreaForDayString(String dayName) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> results = await db.query(
      'workout_days',
      where: 'day_name = ?',
      whereArgs: [dayName],
    );
    if (results.isNotEmpty) {
      return results.first['focus_area'];
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWorkoutDaysForDay(int dayId) async {
    final db = await instance.database;
    return await db.query('workouts', where: 'day_id = ?', whereArgs: [dayId]);
  }


  Future<void> saveSelectedDaysWithFocusArea(Map<String, String> selectedDaysWithFocusArea) async {
    final db = await database;
    for (var entry in selectedDaysWithFocusArea.entries) {
      await db.insert(
        'workout_days',
        {
          'day_name': entry.key,
          'focus_area': entry.value,
          'user_id': await getUserId(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> deleteWorkout(id) async {
    final db = await database;
    await db.delete('workouts', where: 'id = ?' , whereArgs: [id]);
  }

  Future<void> updateFocusAreaForDay(String dayName, String newFocusArea) async {
    final db = await instance.database;
    await db.update(
      'workout_days',
      {'focus_area': newFocusArea},
      where: 'day_name = ?',
      whereArgs: [dayName],
    );
  }

  Future<void> deleteWorkoutDay(String day) async{
    final db = await instance.database;
    await db.delete('workout_days', where: 'day_name = ?', whereArgs: [day]);
  }

  Future<List<Map<String, dynamic>>>getAllWorkouts() async{
    final db = await instance.database;
    var workouts = await db.query('workouts');
    return workouts;
  }

}
