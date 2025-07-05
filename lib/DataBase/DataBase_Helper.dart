import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'Models/User_Model.dart';
import 'Models/Category_Model.dart';
import 'Models/Transaction_Model.dart';


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'wallet_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    // Enable foreign keys
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
   
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        balance REAL NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        type TEXT NOT NULL CHECK (type IN ('income', 'expense'))
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        category_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL CHECK (type IN ('income', 'expense')),
        date TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
      )
    ''');

    await db.execute('''
      CREATE TRIGGER update_user_balance_after_insert
      AFTER INSERT ON transactions
      FOR EACH ROW
      BEGIN
        UPDATE users
        SET balance = balance + CASE 
          WHEN NEW.type = 'income' THEN NEW.amount
          WHEN NEW.type = 'expense' THEN -NEW.amount
          ELSE 0
        END
        WHERE id = NEW.user_id;
      END;
    ''');
  }

  // -------- Validation --------

  void _validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    throw ArgumentError('Email cannot be null or empty.');
  }
  final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
  if (!regex.hasMatch(email)) {
    throw ArgumentError('Invalid email format.');
  }
}


  void _validateType(String type) {
    if (type != 'income' && type != 'expense') {
      throw ArgumentError("Type must be 'income' or 'expense'.");
    }
  }

  void _validateDate(String date) {
    try {
      DateTime.parse(date);
    } catch (_) {
      throw ArgumentError('Invalid date format.');
    }
  }

  void _validateUserId(int userId) {
    if (userId <= 0) throw ArgumentError('Invalid user ID.');
  }

  void _validateAmount(double amount) {
    if (amount <= 0) throw ArgumentError('Amount must be greater than zero.');
  }

  void _validateUsername(String username) {
    if (username.isEmpty) throw ArgumentError('Username cannot be empty.');
  }

  void _validatePasswordHash(String hash) {
    if (hash.isEmpty) throw ArgumentError('Password hash cannot be empty.');
  }

  // -------- User Methods --------

  Future<int> insertUser(UserModel user) async {
    _validateUsername(user.username);
    _validatePasswordHash(user.passwordHash);
    _validateEmail(user.email);
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<UserModel?> getUserByEmail(String email) async {
    _validateEmail(email);
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? UserModel.fromMap(result.first) : null;
  }

  Future<UserModel?> getUserByUsername(String username) async {
    _validateUsername(username);
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty ? UserModel.fromMap(result.first) : null;
  }

  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final result = await db.query('users');
    return result.map((e) => UserModel.fromMap(e)).toList();
  }

  // -------- Category Methods --------

  Future<int> insertCategory(CategoryModel category) async {
    _validateType(category.type);
    if (category.name.isEmpty) throw ArgumentError('Category name cannot be empty.');
    final db = await database;
    return await db.insert('categories', category.toMap());
  }

  Future<List<CategoryModel>> getCategoriesByType(String type) async {
    _validateType(type);
    final db = await database;
    final result = await db.query(
      'categories',
      where: 'type = ?',
      whereArgs: [type],
    );
    return result.map((e) => CategoryModel.fromMap(e)).toList();
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final db = await database;
    final result = await db.query('categories');
    return result.map((e) => CategoryModel.fromMap(e)).toList();
  }

  // -------- Transaction Methods --------

  Future<int> insertTransaction(TransactionModel txn) async {
    _validateUserId(txn.userId);
    _validateType(txn.type);
    _validateDate(txn.date);
    _validateAmount(txn.amount);
    final db = await database;
    return await db.insert('transactions', txn.toMap());
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final result = await db.query('transactions');
    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<double> getTotalAmountByDate(int userId, String type, String date) async {
    _validateUserId(userId);
    _validateType(type);
    _validateDate(date);
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) as total FROM transactions 
      WHERE user_id = ? AND type = ? AND date = ?
      ''',
      [userId, type, date],
    );
    return result.first['total'] != null
        ? (result.first['total'] as num).toDouble()
        : 0.0;
  }

  Future<List<Map<String, dynamic>>> getExpenseByCategoryForDate(int userId, String date) async {
    _validateUserId(userId);
    _validateDate(date);
    final db = await database;
    return await db.rawQuery(
      '''
      SELECT c.name, SUM(t.amount) as total
      FROM transactions t
      JOIN categories c ON t.category_id = c.id
      WHERE t.user_id = ? AND t.type = 'expense' AND t.date = ?
      GROUP BY t.category_id
      ''',
      [userId, date],
    );
  }

  // -------- Close DB --------

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}

