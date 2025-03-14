import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        title: Text(AppLocalizations.of(context)!.profile_add_profile),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
        child: Center(
          child: Column(
            spacing: 15,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.profile_email,
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
                  labelText: AppLocalizations.of(context)!.profile_password,
                ),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.profile_smtp_server,
                ),
                onChanged: (value) {
                  setState(() {
                    smtpServer = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.profile_imap_server,
                ),
                onChanged: (value) {
                  setState(() {
                    imapServer = value;
                  });
                },
              ),
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.profile_use_ssl),
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
                child: Text(AppLocalizations.of(context)!.profile_add_profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
