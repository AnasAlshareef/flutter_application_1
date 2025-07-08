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

  Future<void> createCategoryTable(Database db) async {
    await db.execute('''
    CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL UNIQUE
    )
  ''');

    await db.insert('categories', {'name': 'الطعام والشراب'});
    await db.insert('categories', {'name': 'الإيجار أو السكن'});
    await db.insert('categories', {'name': 'المواصلات'});
    await db.insert('categories', {'name': 'الصحة'});
    await db.insert('categories', {'name': 'المرتب الشهري'});
    await db.insert('categories', {'name': 'استثمارات'});
    await db.insert('categories', {'name': 'التسوق والملابس'});
    await db.insert('categories', {'name': 'أخرى'});
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

    await createCategoryTable(db);

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
    final user = result.isNotEmpty ? UserModel.fromMap(result.first) : null;
    print('User fetched by email: $user'); // Debug print
    return user;
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

  Future<List<CategoryModel>> getAllCategories() async {
    final db = await database;
    final result = await db.query('categories');
    return result.map((e) => CategoryModel.fromMap(e)).toList();
  }

  Future<bool> categoryExistsByName(String categoryName) async {
    final db = await database;
    final result = await db.query(
      'categories',
      where: 'name = ?',
      whereArgs: [categoryName],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<int?> getCategoryIdByName(String categoryName) async {
    final db = await database;
    final result = await db.query(
      'categories',
      columns: ['id'],
      where: 'name = ?',
      whereArgs: [categoryName],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first['id'] as int;
    } else {
      return null; // Category name not found
    }
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

  Future<double> getTotalAmountByDate(
    int userId,
    String type,
    String date,
  ) async {
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
Future<List<Map<String, dynamic>>> getExpensesByCategoryForPeriod({
  required int userId,
  required String period,
}) async {
  _validateUserId(userId);

  final db = await database;
  final now = DateTime.now();
  late DateTime startDate;

  switch (period) {
    case 'daily':
      startDate = DateTime(now.year, now.month, now.day);
      break;
    case 'weekly':
      startDate = now.subtract(const Duration(days: 6));
      break;
    case 'monthly':
      startDate = now.subtract(const Duration(days: 29));
      break;
    case 'yearly':
      startDate = now.subtract(const Duration(days: 364));
      break;
    default:
      throw ArgumentError('Invalid period: $period');
  }

  final startDateStr = startDate.toIso8601String();

  return await db.rawQuery(
    '''
    SELECT c.name AS name, SUM(t.amount) as total
    FROM transactions t
    JOIN categories c ON t.category_id = c.id
    WHERE t.user_id = ? 
      AND t.type = 'expense' 
      AND datetime(t.date) >= datetime(?)
    GROUP BY t.category_id
    ''',
    [userId, startDateStr],
  );
}
 

  // -------- Close DB --------

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
