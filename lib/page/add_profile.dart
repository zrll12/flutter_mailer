import 'package:flutter/material.dart';

class AddProfilePage extends StatefulWidget {
  const AddProfilePage({super.key});

  @override
  State<AddProfilePage> createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  bool _isLoading = false;
  String email = '';
  String password = '';
  String popServer = '';
  String imapServer = '';

  void addProfile() {
    print('Add Profile');
    setState(() {
      _isLoading = true;
    });
    // Add Profile
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Profile'),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
        child: Center(
          child: Column(
            spacing: 15,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'POP Server',
                ),
                onChanged: (value) {
                  setState(() {
                    popServer = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'IMAP Server',
                ),
                onChanged: (value) {
                  setState(() {
                    imapServer = value;
                  });
                },
              ),
              FilledButton(
                onPressed: email.isEmpty ||
                        password.isEmpty ||
                        popServer.isEmpty ||
                        imapServer.isEmpty ||
                        _isLoading
                    ? null
                    : addProfile,
                child: const Text('Add Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
