import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class DBService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'users.db');
    print('Database path: $path');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firstName TEXT,
            lastName TEXT,
            dob TEXT,
            gender TEXT,
            phone TEXT,
            email TEXT UNIQUE,
            password TEXT,
           
          )
        ''');
      },
    );
  }

  Future<int> registerUser(UserModel user) async {
    final db = await database;
    try {
      return await db.insert('users', user.toJson());
    } catch (e) {
      print("SQLite Error: $e"); // 🔍 Prints error in console
      return -1;
    }
  }


  // ✅ Login User (Fetch user by email & password)
  Future<UserModel?> loginUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return UserModel.fromJson(result.first);
    }
    return null;
  }

  // ✅ Fetch Only Name, Phone, and Email for Profile Page
  Future<UserModel?> getLoggedInUser(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['id', 'firstName', 'lastName', 'phone', 'email'], // Fetching all needed fields
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return UserModel.fromJson(result.first);
    }
    return null;
  }

  // ✅ Update User Name in Database
  Future<void> updateUserName(int userId, String firstName, String lastName) async {
    final db = await database;
    await db.update(
      'users',
      {'firstName': firstName, 'lastName': lastName},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // ✅ Delete User from Database (During Logout or Account Deletion)
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}



/*
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class DBService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'users.db');
    print('Database path: $path');

    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firstName TEXT,
            lastName TEXT,
            dob TEXT,
            gender TEXT,
            phone TEXT,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }

  // ✅ Register User (Stores all fields)
  Future<int> registerUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toJson());
  }

  // ✅ Login User (Fetch user by email & password)
  Future<UserModel?> loginUser(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return UserModel.fromJson(result.first);
    }
    return null;
  }

  // ✅ Fetch Only Name, Phone, and Email for Profile Page
  Future<UserModel?> getLoggedInUser(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['firstName', 'phone', 'email'], // Only fetching required fields
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isNotEmpty) {
      return UserModel.fromJson(result.first);
    }
    return null;
  }

  // ✅ Delete User from Database (During Logout or Account Deletion)
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
*/