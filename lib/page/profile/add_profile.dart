import 'package:flutter/material.dart';
import 'package:flutter_mailer/model/profile.dart';

class AddProfilePage extends StatefulWidget {
  const AddProfilePage({super.key});

  @override
  State<AddProfilePage> createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  bool _isLoading = false;
  String email = '';
  String password = '';
  String imapServer = '';
  String smtpServer = '';
  bool useSSL = false;

  void addProfile() {
    setState(() {
      _isLoading = true;
    });

    Profile profile = Profile(
      email: email,
      password: password,
      smtpServer: smtpServer,
      imapServer: imapServer,
      useSSL: useSSL,
      id: 0,
    );

    Navigator.pop(context, profile);

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
                  labelText: 'SMTP Server',
                ),
                onChanged: (value) {
                  setState(() {
                    smtpServer = value;
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
              Row(
                children: [
                  const Text('Use SSL'),
                  Spacer(),
                  Switch(
                    value: useSSL,
                    onChanged: (value) {
                      setState(() {
                        useSSL = value;
                      });
                    },
                  ),
                ],
              ),
              FilledButton(
                onPressed: email.isEmpty ||
                        password.isEmpty ||
                        smtpServer.isEmpty ||
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
