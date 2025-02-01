import 'package:date_format/date_format.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/database.dart';
import 'package:flutter_mailer/model/email.dart';

import '../model/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Profile> _profiles = [];
  List<Email> _emails = [];

  Future<void> _freshEmails() async {
    databaseHelper.db.then((db) => Profile.getProfiles(db)).then((value) async {
      _profiles = value;

      for (var profile in _profiles) {
        final client = ImapClient(isLogEnabled: false);
        try {
          var server = profile.imapServer.split(":");
          if (server.length != 2) {
            server = [profile.imapServer, "993"];
          }
          await client.connectToServer(server[0], int.parse(server[1]),
              isSecure: profile.useSSL);
          await client.id(
              clientId: Id(
            name: 'Flutter Mailer',
            version: '1.0',
            vendor: 'Flutter',
          ));
          var password = await profile.getPassword();
          if (password == null) {
            continue;
          }
          await client.login(profile.email, password);

          var boxes = await client.listMailboxes();

          // for (var folder in boxes) {
          try {
            var folder = boxes.first;
            await client.selectMailbox(folder);

            var messages = await client.fetchRecentMessages(
              messageCount: 10,
            );

            for (var message in messages.messages) {
              Email email = Email(
                id: null,
                profileId: profile.id,
                sender: message.sender.toString(),
                recipients: message.recipients.toString(),
                subject: message.decodeSubject() ?? 'No Subject',
                text: message.decodeTextPlainPart() ?? '',
                html: message.decodeTextHtmlPart() ?? '',
                date: message.decodeDate() ?? DateTime.now(),
                sequenceId: message.sequenceId ?? 0,
                mailbox: folder.name,
              );
              databaseHelper.db
                  .then((db) => email.insert(db))
                  .then((_) => _loadEmails());
            }
          } catch (e) {
            continue;
          }
          // }
        } catch (e) {
          print('Error processing profile ${profile.email}: $e');
        } finally {
          await client.disconnect();
        }
      }
    });
  }

  Future<void> _loadEmails() async {
    databaseHelper.db.then((db) => Email.getEmails(db)).then((value) {
      setState(() {
        _emails = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadEmails();
  }

  @override
  Widget build(BuildContext context) {
    _loadEmails();

    var list = <Widget>[
      for (var i = 0; i < _emails.length; i++) ...[
        ListTile(
          title: Text(_emails[i].subject),
          subtitle: Text(
            '${formatDate(_emails[i].date, [
                  yyyy,
                  '-',
                  mm,
                  '-',
                  dd,
                  ' ',
                  HH,
                  ':',
                  mm
                ])} ${_emails[i].sender == 'null' ? "" : _emails[i].sender}',
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.pushNamed(context, 'email_details',
                arguments: _emails[i].toMap());
          },
        ),
        if (i < _emails.length - 1) Divider(), // 只在非最后一项添加分割线
      ]
    ];

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: list,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _freshEmails,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
