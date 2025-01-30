import 'package:flutter/material.dart';
import 'package:flutter_mailer/page/add_profile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void addUser(context) {
    print('Add User');
    Navigator.pushNamed(context, 'add_profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Profile'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addUser(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}