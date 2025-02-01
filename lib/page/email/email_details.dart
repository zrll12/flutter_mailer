import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/model/email.dart';

class EmailDetails extends StatelessWidget {
  const EmailDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
      ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    var email = Email.fromMap(args!);

    return Scaffold(
      appBar: AppBar(
        title: Text('Email Detail'),
      ),
      body: SingleChildScrollView(  // Add ScrollView to handle overflow
        child: Container(
          margin: const EdgeInsets.only(left: 40, right: 40, top: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,  // Align text to the left
            children: [
              Text('From: ${email.sender}'),
              SizedBox(height: 15),  // Replace spacing with SizedBox
              Text('To: ${email.recipients}'),
              SizedBox(height: 15),
              Text('Subject: ${email.subject}'),
              SizedBox(height: 15),
              Text('Date: ${email.date}'),
              SizedBox(height: 15),
              Text('Content:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text(email.text),
            ],
          ),
        ),
      ),
    );
  }
}