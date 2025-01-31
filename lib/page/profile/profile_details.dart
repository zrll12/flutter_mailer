import 'package:flutter/material.dart';

import '../../model/profile.dart';

class ProfileDetails extends StatelessWidget {

  ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profile Detail'),
        ),
        body: Center(
          child: Text('No data'),
        )
      );
    }

    Profile profile = Profile.fromJson(args);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Detail'),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
        child: Center(
          child: Column(
            spacing: 15,
            children: [
              Text('Email: ${profile.email}'),
              Text('IMAP Server: ${profile.imapServer}'),
              Text('SMTP Server: ${profile.smtpServer}'),
              Text('Use SSL: ${profile.useSSL}'),
            ],
          ),
        ),
      ),
    );
  }
}