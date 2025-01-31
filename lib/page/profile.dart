import 'package:flutter/material.dart';
import 'package:flutter_mailer/database.dart';
import 'package:flutter_mailer/model/profile.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Profile> _profiles = [];
  bool loading = true;

  void addUser(context) {
    var result = Navigator.pushNamed(context, 'add_profile');
    result.then((value) => {
          if (value != null)
            {databaseHelper.db.then((db) => (value as Profile).insert(db))}
        });
  }

  void _readProfile() {
    setState(() {
      loading = true;
    });
    databaseHelper.db.then((db) => Profile.getProfiles(db)).then((value) {
      setState(() {
        _profiles = value;
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _readProfile();
  }

  @override
  Widget build(BuildContext context) {
    var list = <ListTile>[
      for (var profile in _profiles)
        ListTile(
          title: Text(profile.email),
          subtitle: Text(profile.imapServer),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.pushNamed(context, 'profile_details',
                arguments: profile.toJson())
            .then((result) => {
              if (result == true) {
                _readProfile()
              }
            });
          },
        )
    ];

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            if (loading)
              const CircularProgressIndicator()
            else
              Expanded(
                child: ListView(
                  children: list,
                ),
              ),
            OutlinedButton(
                onPressed: _readProfile, child: const Text("Refresh")),
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
