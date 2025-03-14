import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper extends ChangeNotifier {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static late Database _db;
  static bool _initialized = false;

  final storage = FlutterSecureStorage();
  final String _dbName = 'flutter_mailer.db';
  final int _dbVersion = 3;

  DatabaseHelper._internal() {
    _init();
  }

  factory DatabaseHelper() {
    return _instance;
  }

  Future<void> _init() async {
    if (_initialized) return;
    
    _db = await openDatabase(
      _dbName,
      version: _dbVersion,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _db.execute('''
          CREATE TABLE IF NOT EXISTS profile (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT,
            password TEXT,
            imapServer TEXT,
            smtpServer TEXT,
            useSSL INTEGER
          )
        ''');

          await _db.execute('''
          CREATE TABLE IF NOT EXISTS email (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            mailbox TEXT,
            profileId INTEGER,
            text TEXT,
            html TEXT,
            subject TEXT,
            sender TEXT,
            recipients TEXT,
            date TEXT
          )
        ''');
        }
        if (oldVersion == 2) {
          // remove sequenceId from email table
          db.execute('''
            ALTER TABLE email
              DROP COLUMN sequenceId;
          ''');
        }
      },
    );
    
    _initialized = true;
  }

  Future<void> ensureInitialized() async {
    if (!_initialized) {
      await _init();
    }
  }

  Future<Database> get db async {
    await ensureInitialized();
    return _db;
  }
}