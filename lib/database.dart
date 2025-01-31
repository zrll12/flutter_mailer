import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'model/profile.dart';

class DatabaseHelper extends ChangeNotifier {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static late Database _db;
  static bool _initialized = false;

  final storage = FlutterSecureStorage();
  final String _dbName = 'flutter_mailer.db';
  final int _dbVersion = 1;

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
    );

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

class SecureRandom {
  final Random _random;

  SecureRandom() : _random = Random.secure();

  Uint8List generateRandomBytes(int length) {
    final Uint8List randomBytes = Uint8List(length);
    for (int i = 0; i < length; i++) {
      randomBytes[i] = _random.nextInt(256);
    }
    return randomBytes;
  }

  String generateRandomBase64String(int length) {
    final bytes = generateRandomBytes((length * 3 / 4).ceil());
    return base64.encode(bytes);
  }
}