import 'package:drivers_log/models/question.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:drivers_log/models/driving_event.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'drivers_log.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE driving_events(id TEXT PRIMARY KEY, startDate TEXT NOT NULL, endDate TEXT NOT NULL, timeOfDay INTEGER NOT NULL, notes TEXT)',
        );
        await database.execute(
          'CREATE TABLE questions(id INTEGER PRIMARY KEY, question TEXT NOT NULL, imageString TEXT NOT NULL, answer TEXT NOT NULL, choiceA TEXT NOT NULL, choiceB TEXT NOT NULL, choiceC TEXT NOT NULL)',
        );
      },
      version: 1,
    );
  }

  void insertDrivingEvent(DrivingEvent event) async {
    final Database db = await initializeDB();
    await db.insert('driving_events', event.toMap());
  }

  Future<List<DrivingEvent>> fetchDrivingEvents() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('driving_events');
    return queryResult.map((e) => DrivingEvent.fromMap(e)).toList();
  }

  void deleteDrivingEvent(String id) async {
    final db = await initializeDB();
    await db.delete(
      'driving_events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  void replaceDrivingEvents(List<Question> questions) async {
    final db = await initializeDB();
    await db.delete('questions');
    final batch = db.batch();
    for (var question in questions) {
      db.insert('questions', question.toMap());
    }
    batch.commit();
  }

  Future<List<Question>> fetchQuestions() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('questions');
    return queryResult.map((e) => Question.fromMap(e)).toList();
  }
}
