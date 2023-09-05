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
            name TEXT NOT NULL,
            workout_days TEXT,
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
            duration INTEGER NOT NULL
        );
      ''');
      await db.execute('''
              CREATE TABLE exercise_categories (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
        );
      ''');
      await db.execute('''
            CREATE TABLE routines (
            id INTEGER PRIMARY KEY,
            user_id INTEGER,
            name TEXT NOT NULL,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users (id)
        );
     ''');
      await db.execute('''CREATE TABLE routine_exercises (
            id INTEGER PRIMARY KEY,
            routine_id INTEGER,
            exercise_id INTEGER,
            sets INTEGER,
            reps INTEGER,
            weight INTEGER,
            FOREIGN KEY (routine_id) REFERENCES routines (id),
            FOREIGN KEY (exercise_id) REFERENCES exercises (id)
      )''');

    } catch (err) {
      print("OHH SHIT!");
      print(err.toString());
      print("OHH SHIT");
    }
  }

  Future<void> insertWorkout({
    required String workoutName,
    required int sets,
    required int reps,
    required int weight,
    required int duration,
  }) async {
    final db = await instance.database;
    await db.insert('workouts', {
      'name': workoutName,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'duration': duration,
    });
  }

  Future<void> insertUser(
      {required String userName, required List<String> workoutDays}) async {
    final db = await instance.database;
    await db.insert('users', {
      'name': userName,
      'workout_days':
          workoutDays.join(', '), // Convert list to comma-separated string
    });
  }

  Future<void> insertQuotes(
      {required String text, required String author}) async {
    final db = await instance.database;
    await db.insert('quotes', {
      'text': text,
      'author': author, // Convert list to comma-separated string
    });
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
  Future<List<Map<String, dynamic>>?> getWorkoutDays() async {
    // Open the database
    final db = await instance.database;

    // Query the database to get the users workouts
    final List<Map<String, dynamic>> results = await db.query(
      'users',
      columns: ['workout_days'], // Select only the 'workout_days' column
      limit: 1, // Limit the result to the first user
    );

    // Close the database
    await db.close();

    // Check if a user was found
    if (results.isNotEmpty) {
      // Extract the name of the first user

      return results;
    }

    // No user found
    return null;
  }
}
