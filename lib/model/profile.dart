import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../database.dart';

class Profile {
  final storage = FlutterSecureStorage();

  final String email;
  final String smtpServer;
  final String imapServer;
  final String password;
  final bool useSSL;

  Profile({
    required this.email,
    required this.smtpServer,
    required this.imapServer,
    required this.password,
    this.useSSL = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'smtpServer': smtpServer,
      'imapServer': imapServer,
      'password': password,
      'useSSL': useSSL ? 1 : 0,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {

    return Profile(
      email: json['email'],
      smtpServer: json['smtpServer'],
      imapServer: json['imapServer'],
      password: json['password'],
      useSSL: json['useSSL'] == 1,
    );
  }

  static Future<List<Profile>> getProfiles(Database db) async {
    List<Map<String, dynamic>> profiles = await db.query("profile");
    return profiles.map((e) => Profile.fromJson(e)).toList();
  }

  Future<String?> getPassword() async {
    final encryptKey = await storage.read(key: 'email_$email');

    if (encryptKey == null) {
      return null;
    }

    // Use first 16 bytes of encryption key as IV
    final iv = encrypt.IV.fromUtf8(encryptKey.substring(0, 16));
    final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(encryptKey)));

    return encrypter.decrypt64(password, iv: iv);
  }

  Future<void> insert(Database db) async {
    var encryptedProfile = toJson();
    var encryptKey = await storage.read(key: 'email_$email');

    if (encryptKey == null) {
      encryptKey = Uuid().v4().replaceAll("-", "");
      await storage.write(key: 'email_$email', value: encryptKey);
    }


    // Use first 16 bytes of encryption key as IV
    final iv = encrypt.IV.fromUtf8(encryptKey.substring(0, 16));
    encryptedProfile["password"] =
        encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(encryptKey)))
            .encrypt(password, iv: iv)
            .base64;

    await db.insert("profile", encryptedProfile);
  }

  static Future<void> delete(Database db, String email) async {
    await db.delete("profile", where: "email = ?", whereArgs: [email]);
  }

  Future<void> update(Database db, String oldEmail) async {
    var encryptedProfile = {
      'email': email,
      'smtpServer': smtpServer,
      'imapServer': imapServer,
      'useSSL': useSSL ? 1 : 0,
    };

    if (password.isNotEmpty) {
      var encryptKey = await storage.read(key: 'email_$oldEmail');
      encryptKey ??= Uuid().v4().replaceAll("-", "");
      if (oldEmail != email) {
        await storage.delete(key: 'email_$oldEmail');
      }
      await storage.write(key: 'email_$email', value: encryptKey);

      final iv = encrypt.IV.fromUtf8(encryptKey.substring(0, 16));
      encryptedProfile["password"] =
          encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(encryptKey)))
              .encrypt(password, iv: iv)
              .base64;
    }

    await db.update("profile", encryptedProfile, where: "email = ?", whereArgs: [oldEmail]);
  }
}
