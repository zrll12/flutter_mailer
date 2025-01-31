import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import 'model/profile.dart';

class DatabaseHelper extends ChangeNotifier {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static late Database _db;

  final storage = FlutterSecureStorage();
  final String _dbName = 'flutter_mailer.db';
  final int _dbVersion = 1;

  DatabaseHelper._internal() {
    _init();
  }

  factory DatabaseHelper() {
    return _instance;
  }



  void _init() async {
    _db = await openDatabase(
      _dbName,
      version: _dbVersion,
    );

    // _db.execute('''DROP TABLE IF EXISTS profile''');

    _db.execute('''
          CREATE TABLE IF NOT EXISTS profile (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT,
            password TEXT,
            imapServer TEXT,
            smtpServer TEXT,
            useSSL INTEGER
          )
        ''');
  }

  Future<void> addProfile(Profile profile) async {
    var encryptKey = await storage.read(key: 'email_${profile.email}');
    var encryptedProfile = profile.toJson();

    if (encryptKey == null) {
      encryptKey = Uuid().v4().replaceAll("-", "");
      await storage.write(key: 'email_${profile.email}', value: encryptKey);
    }

    // Use first 16 bytes of encryption key as IV
    final iv = encrypt.IV.fromUtf8(encryptKey.substring(0, 16));
    encryptedProfile["password"] =
        encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(encryptKey)))
            .encrypt(profile.password, iv: iv)
            .base64;
    encryptedProfile["useSSL"] = encryptedProfile["useSSL"] == true ? 1 : 0;

    await _db.insert("profile", encryptedProfile);
    notifyListeners();
  }

  Future<List<Profile>> getProfiles() async {
    List<Map<String, dynamic>> profiles = await _db.query("profile");

    return Future.wait(profiles.map((map) async {
      var decryptedProfile = Map<String, dynamic>.from(map);
      decryptedProfile['useSSL'] = map['useSSL'] == 1;
      
      final encryptKey = await storage.read(key: 'email_${map['email']}');
      if (encryptKey != null) {
        // Use first 16 bytes of encryption key as IV
        final iv = encrypt.IV.fromUtf8(encryptKey.substring(0, 16));
        final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(encryptKey)));
        decryptedProfile['password'] = encrypter.decrypt64(map['password'], iv: iv);
      }
      
      return Profile.fromJson(decryptedProfile);
    }));
  }
}
