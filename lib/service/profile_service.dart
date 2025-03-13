import 'package:flutter/material.dart';
import 'package:flutter_mailer/database.dart';
import 'package:flutter_mailer/model/profile.dart';

class ProfileService {
  static final ProfileService _instance = ProfileService._internal();
  final DatabaseHelper databaseHelper = DatabaseHelper();

  ProfileService._internal();

  factory ProfileService() {
    return _instance;
  }

  Future<List<Profile>> getProfiles() async {
    var db = await databaseHelper.db;
    return Profile.getProfiles(db);
  }

  Future<void> addProfile(Profile profile) async {
    var db = await databaseHelper.db;
    await profile.insert(db);
  }

  Future<void> updateProfile(Profile profile, String oldEmail) async {
    var db = await databaseHelper.db;
    await profile.update(db, oldEmail);
  }

  Future<void> deleteProfile(Profile profile) async {
    var db = await databaseHelper.db;
    await Profile.delete(db, profile.email);
  }

  void showMessage(BuildContext context, String message, {Color color = Colors.green}) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}