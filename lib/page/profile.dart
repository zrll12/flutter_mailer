import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mailer/database.dart';
import 'package:flutter_mailer/model/profile.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  DatabaseHelper databaseHelper = DatabaseHelper();

  void addUser(context) {
    print('Add User');
    var result = Navigator.pushNamed(context, 'add_profile');
    result.then((value) => {
      if (value != null) {
        databaseHelper.addProfile(value as Profile)
      }
    });
  }

  void readProfile() {
    databaseHelper.getProfiles()
    .then((value) => {
      print(jsonEncode(value))
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            OutlinedButton(onPressed: readProfile, child: const Text("Read Profile")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addUser(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}