import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = 'my_database.db';
  static final _databaseVersion = 1;

  static final table = 'events';
  static final columnId = '_id';
  static final columnEventName = 'event_name';
  static final columnEventType = 'event_type';
  static final columnPriority = 'priority';
  static final columnStartDate = 'start_date';
  static final columnEndDate = 'end_date';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // initialize the database
  Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    String fullPath = join(path, _databaseName);
    return await openDatabase(fullPath,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // called when the database is created for the first time
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table(
        $columnId INTEGER PRIMARY KEY,
        $columnEventName TEXT,
        $columnEventType TEXT,
        $columnPriority TEXT,
        $columnStartDate TEXT,
        $columnEndDate TEXT
      )
    ''');
  }

  // insert a new event into the database
  Future<int> insertEvent(Map<String, dynamic> row) async {
    Database db = await instance.database;
    if (!(await _isTableExists(db))) {
      await _onCreate(db, _databaseVersion);
    }
    return await db.insert(table, row);
  }

  // check if table exists
  Future<bool> _isTableExists(Database db) async {
    var res = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='$table'");
    return res.isNotEmpty;
  }
  Future<List<Map<String, dynamic>>> getEvents() async {
    Database db = await instance.database;
    if (!(await _isTableExists(db))) {
      await _onCreate(db, _databaseVersion);
    }
    return await db.query(table);
  }
}
